-- level.lua
gameLevels = {}
levelVersion=1
function getLevels(dir)
	files = love.filesystem.getDirectoryItems( dir )
	for _,file in pairs(files) do
		if string.ends(file,".swl") then
			Name,Author = loadLevel(dir.."/"..file,false)
			print("Loaded level '"..Name.."' by '"..Author.."'")
			table.insert(gameLevels,{dir.."/"..file,Name,Author})
		end
	end
end

function saveLevel(filename,level,name,author)
	love.filesystem.write(filename,'')
	file, errorstr = love.filesystem.newFile( filename, 'w' )
	if errorstr then
		error("An error occurred"..errorstr)
	end
	file:write(string.char(180,247)) --Magic bytes
	file:write(IntToPStruct(levelVersion)) --Version number
	file:write(IntToPStruct(name:len() +author:len())) --Header len
	file:write(IntToPStruct(name:len())) --Name len
	file:write(name)
	file:write(author)
	file:write(IntToPStruct(table.getn(level[1])))--Write width
	height = table.getn(level)-1
	datasize = table.getn(level[1])*height*6
	datasize = IntToPStruct(datasize)
	file:write(datasize)--Data length:6 bytes for each tile
	for _,row in pairs(level) do
		for _,tile in pairs(row) do
			file:write(ShortToPStruct(tile[1])) --Tile Type
			file:write(ShortToPStruct(tile[2])) --Tile Rotation
			file:write(ShortToPStruct(tile[3])) --Tile Entity
		end
	end
	file:write(string.char(180,247)) --Ends with magic bytes
	file:close()
end

function loadLevel(filename,includedata)
	print("Loading " .. filename)
	if includedata then
	print("\t(Complete Load).")
	end
	if includedata == nil then
		includedata = true
	end
	file, errorstr = love.filesystem.newFile( filename, 'r' )
	if errorstr then
		print("An error occurred"..errorstr)
		return nil,nil,nil
	end
	local bytes, err = file:read(2)
	MagicOK = (string.byte(bytes) == 180 and string.byte(bytes,2) == 247)
	if MagicOK == false then
		print("The file is not of level format.")
		return nil,nil,nil
	end
	version = pStructToInt(file:read(4))
	headerlen = pStructToInt(file:read(4))
	lvllen = pStructToInt(file:read(4))
	LevelName = file:read(lvllen)
	Author = file:read(headerlen - lvllen)
	if includedata then
		Width = pStructToInt(file:read(4))
		DataSize = pStructToInt(file:read(4))
		Height = DataSize / (Width*4)
		RowN = 1
		TileN = 1
		Rows = {{}}
		for i=1,DataSize/6 do
			TileType = pStructToShort(file:read(2))
			TileRot = pStructToShort(file:read(2))
			TileEnt = pStructToShort(file:read(2))
			Rows[RowN][TileN] = {TileType,TileRot,TileEnt}
			TileN = TileN + 1
			if TileN > Width then
				RowN = RowN + 1
				TileN = 1
				Rows[RowN] = {}
			end
		end
		bytes = file:read(2)
		MagicOK = (string.byte(bytes) == 180 and string.byte(bytes,2) == 247)
		if MagicOK == false then
			error("The level file did not end properly. It could be corrupted.")
		end
	end
	file:close()
	return LevelName, Author, Rows
end

function pStructToShort(bytes)
	ByteA = string.byte(bytes,1)
	ByteB = string.byte(bytes,2)*256
	return ByteA + ByteB
end

function ShortToPStruct(short)
	hexstring = string.format("%04x",short)
	ByteA = tonumber(string.sub(hexstring,3,4),16)
	ByteB = tonumber(string.sub(hexstring,1,2),16)
	return string.char(ByteA,ByteB)
end

function IntToPStruct(int)
	hexstring = string.format("%08x",int)
	ByteA = tonumber(string.sub(hexstring,7,8),16)
	ByteB = tonumber(string.sub(hexstring,5,6),16)
	ByteC = tonumber(string.sub(hexstring,3,4),16)
	ByteD = tonumber(string.sub(hexstring,1,2),16)
	local str = string.char(ByteA,ByteB,ByteC,ByteD)
	return str
end

function pStructToInt(bytes)
	ByteA = string.byte(bytes,1)
	ByteB = string.byte(bytes,2)*256
	ByteC = string.byte(bytes,3)*256*256
	ByteD = string.byte(bytes,4)*256*256*256
	return ByteA + ByteB + ByteC + ByteD
end
