-- level.lua
gameLevels = {}
levelVersion=2
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

function saveLevel(filename,level,name,author,ents)
	love.filesystem.write(filename,'')
	file, errorstr = love.filesystem.newFile( filename, 'w' )
	if errorstr then
		error("An error occurred"..errorstr)
	end
	file:write(string.char(180,247)) --Magic bytes
	file:write(ShortToPStruct(levelVersion)) --Version number
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
	if levelVersion >= 2 then
		entData = ""
		for _,ent in pairs(ents) do
			entData = entData .. ShortToPStruct(ents[1]) --Pointer
			entData = entData .. ShortToPStruct(ents[2]) --Type
			entData = entData .. ShortToPStruct(table.getn(ents[3])) --Props
			for _,prop in ents[3] do
				datatype = prop[2]
				if prop[2] == 2 then --string
					data = prop[1]
					datalen = len(string.len(prop[1]))
				elseif prop[2] == 0 then
					data = ShortToPStruct(prop[1])
					datalen = 2
				elseif prop[2] == 0 then
					data = IntToPStruct(prop[1])
					datalen = 4
				else
					print("Unknown data type (",prop[2],")")
				end
				entData = entData .. ShortToPStruct(datalen)
				entData = entData .. ShortToPStruct(datatype)
				entData = entData .. data
			end
		end
		file:write(IntToPStruct(string.len(entData)))
		file:write(entData)
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
		return nil,nil,nil,nil
	end
	local bytes, err = file:read(2)
	MagicOK = (string.byte(bytes) == 180 and string.byte(bytes,2) == 247)
	if MagicOK == false then
		print("The file is not of level format.")
		return nil,nil,nil,nil
	end
	version = pStructToShort(file:read(2))
	headerlen = pStructToInt(file:read(4))
	lvllen = pStructToInt(file:read(4))
	LevelName = file:read(lvllen)
	Author = file:read(headerlen - lvllen)
	local Ents = {}
	local entitys
	if includedata then
		Width = pStructToInt(file:read(4))
		DataSize = pStructToInt(file:read(4))
		Height = DataSize / (Width*4)
		RowN = 1
		TileN = 1
		Rows = {{}}
		for i=1,DataSize/6 do
			TileType = pStructToShort(file:read(2))
			TileRot = pStructToShort(file:read(2)) --Rotation in degrees
			TileEnt = pStructToShort(file:read(2))
			Rows[RowN][TileN] = {TileType,TileRot,TileEnt}
			TileN = TileN + 1
			if TileN > Width then
				RowN = RowN + 1
				TileN = 1
				Rows[RowN] = {}
			end
		end
		
		--Entites
		if version >= 2 then
			blockSize = pStructToInt(file:read(4))
			readSize = 0
			while blockSize > readSize do
				pointer = pStructToShort(file:read(2)) readSize = readSize + 2
				enttype = pStructToShort(file:read(2)) readSize = readSize + 2
				propcount = pStructToShort(file:read(2)) readSize = readSize + 2
				local props = {}
				for i=1,propcount do
					propsize = pStructToShort(file:read(2)) readSize = readSize + 2
					proptype = pStructToShort(file:read(2)) readSize = readSize + 2
					if proptype == 0 then
						prop = pStructToShort(file:read(2)) readSize = readSize + 2
					elseif proptype == 1 then
						prop = pStructToInt(file:read(4)) readSize = readSize + 4
					elseif proptype == 2 then --string
						prop = file:read(propsize) readSize = readSize + propsize
					else
						print("Warning: Unknown property type for entity. Corruption possible or mismatched versions.(",proptype,")")
					end
					table.insert(props,{prop,type})
				end
			table.insert(Ents,{pointer,enttype,props})
			end
		end
		
		bytes = file:read(2)
		MagicOK = (string.byte(bytes) == 180 and string.byte(bytes,2) == 247)
		if MagicOK == false then
			error("The level file did not end properly. It could be corrupted.")
		end
	end
	file:close()
	return LevelName, Author, Rows, Ents
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
