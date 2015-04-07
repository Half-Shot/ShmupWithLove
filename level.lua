-- level.lua
gameLevels = {}
function getLevels(dir)
	files = love.filesystem.getDirectoryItems( dir )
	for _,file in pairs(files) do
		if string .ends(file,".swl") then
			Name,Author = loadLevel(dir.."/"..file,false)
			print("Loaded level '"..Name.."' by '"..Author.."'")
			table.insert(gameLevels={file,Name,Author}
		end
	end
end

function loadLevel(filename,includedata)
	if includedata == nil then
		includedata = true
	end
	file, errorstr = love.filesystem.newFile( filename, 'r' )
	if errorstr then
		error("An error occurred"..errorstr)
	end
	bytes, err = file:read(2)
	MagicOK = (string.byte(bytes) == 180 and string.byte(bytes,2) == 247)
	if MagicOK == false then
		error("The file is not of level format.")
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
		for i=1,DataSize/4 do
			TileType = pStructToShort(file:read(2))
			TileEnd = pStructToShort(file:read(2))
			Rows[RowN][TileN] = {TileType,TileEnd}
			if i % Width == 0 then
				RowN = RowN + 1
				TileN = 1
				Rows[RowN] = {}
			end
			TileN = TileN + 1
		end
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

function pStructToInt(bytes)
	ByteA = string.byte(bytes,1)
	ByteB = string.byte(bytes,2)*256
	ByteC = string.byte(bytes,3)*256*256
	ByteD = string.byte(bytes,4)*256*256*256
	return ByteA + ByteB + ByteC + ByteD
end
