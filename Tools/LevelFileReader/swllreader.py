#!/bin/env python3
#ShmupWithLove Level Reader
import argparse
import struct
# Structure of a level file
# =========================
# 0-1 Magic Bytes that should always be 0xb4,0xf7
# 2-5 Version of the file. 
# 6-9 Length of the Header
# Header
    # 9-12 LevelNameLength
    # LevelName
    # Author
# +4 Level Width (Height is not nessacery)
# +4 Length of the data
# Data
        # Tile Data
            # +2 TileType
            # +2 EntityIndex (index of a defined entity)
# +2 Magic Bytes again to denote end of file.

class LevelWriter:
    MAGICBYTES = bytes([0xb4,0xf7]) #MagicBytes
    VERSION = 1
    def open(self,filename):
        self.f = open(filename,'wb')
        
    def header(self,levelName,author):
        self.f.write(self.MAGICBYTES)
        self.f.write(struct.pack("I", self.VERSION))
        lNBytes = bytes(levelName,'utf-8')
        aBytes = bytes(author,'utf-8')
        headerSize = len(lNBytes)+len(aBytes)
        self.f.write(struct.pack("I", headerSize))
        self.f.write(struct.pack("I", len(lNBytes)))
        self.f.write(lNBytes)
        self.f.write(aBytes)
        self.f.flush()
    def data(self,width,data):
        self.f.write(struct.pack("I", width))
        self.f.write(struct.pack("I", 4*len(data)))
        for tile in data: # Tuple with type,entity
                self.f.write(struct.pack("H", tile[0]))
                self.f.write(struct.pack("H", tile[1]))
    def close(self):
        self.f.write(self.MAGICBYTES) # Write the end bytes
        self.f.close()
        pass

class LevelReader:
    MAGICBYTES = bytes([0xb4,0xf7]) #MagicBytes
    VERSION = 1
    def open(self,filename):
        self.f = open(filename,'rb')
        magic = self.f.read(2)
        if magic != self.MAGICBYTES:
            self.f.close()
            raise Exception("File is not a recognised level file.")
        pass
    def close(self):
        self.f.close()
        pass
        
    @property
    def header(self):
        version = struct.unpack("I",self.f.read(4))
        if version[0] > self.VERSION:
            print("Warn: Version of file is _greater_ than supported by this file reader.")
        headerLen = struct.unpack("I",self.f.read(4))[0]
        nameLen = struct.unpack("I",self.f.read(4))[0]
        LevelName = self.f.read(nameLen).decode('utf-8')
        Author = self.f.read(headerLen - nameLen).decode('utf-8')
        return (LevelName,Author)
        pass
    @property
    def data(self):
        width = struct.unpack("I",self.f.read(4))[0]
        dataSize = struct.unpack("I",self.f.read(4))[0]
        height =  int(( dataSize / 4 ) / width)
        tiles = []
        entCount = 0
        for i in range(0,dataSize,4):
            tileType = self.f.read(2)
            tileType = struct.unpack("H",tileType)[0]
            tileEnt = self.f.read(2)
            tileEnt = struct.unpack("H",tileEnt)[0]
            tiles.append((tileType,tileEnt))
            if tileEnt != 0:
                entCount += 1
        bfr = self.f.read(2)
        if bfr != self.MAGICBYTES:
            print("Warn: Possible data corruption, missing end of file.")
        return (width,height,entCount,tiles)
        pass

if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog="ShmupWithLove Level Library",description='Read and Write Level Data')
    parser.add_argument('-w', help='Write a basic file',action='store_true')
    parser.add_argument('-l', help='Level Name to write')
    parser.add_argument('-a', help='Author Name to write')
    
    parser.add_argument('filename', type=str, help='Filename to read/write to.')
    args = parser.parse_args()
    width = 64
    if args.w:
        writer = LevelWriter()
        writer.open(args.filename)
        if not args.l:
            name = input("Level Name:")
        else:
            name = args.l
        if not args.a:
            author = input("Author:")
        else:
            author = args.a
        writer.header(name,author)
        writer.data(width,[(0,0)]*width*2048)
        writer.close()
    else: #Reading
        r = LevelReader()
        r.open(args.filename)
        header =  r.header 
        print("Level Name:",header[0])
        print("Author:",header[1])
        data = r.data
        print("Width",data[0])
        print("Height",data[1])
        print("Entity Count",data[2])
        r.close()
