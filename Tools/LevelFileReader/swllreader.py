#!/bin/env python3
#ShmupWithLove Level Reader
import argparse
import struct
# Structure of a level file
# =========================
# 0-1 Magic Bytes that should always be 0xb4,0xf7
# 2-3 Version of the file. 
# 4-7 Length of the Header
# Header
    # 9-12 LevelNameLength
    # LevelName
    # Author
# +4 Level Width (Height is not nessacery)
# +4 Length of the data
# Data
        # Tile Data
            # +2 TileType
            # +2 TileRotation
            # +2 EntityIndex (index of a defined entity)
#====version 2
# +4 Entity Data Length
# Entites
   # +2 Entity Pointer Index
   # +2 Entiy Prop Count
   # Entity Props
     # + 2 Prop Length
     # + 2 Prop Type (0 for short,1 for int,2 for string)
     # + X Data
# +2 Magic Bytes again to denote end of file.

class DummyEntity:
    Pointer = 1
    PropCount = 2
    Name = "DumbEnt"
    Value = 12345

class LevelWriter:
    MAGICBYTES = bytes([0xb4,0xf7]) #MagicBytes
    VERSION = 2
    def open(self,filename):
        self.f = open(filename,'wb')
        
    def header(self,levelName,author):
        self.f.write(self.MAGICBYTES)
        self.f.write(struct.pack("H", self.VERSION))
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
        self.f.write(struct.pack("I", 6*len(data)))
        for tile in data: # Tuple with type,entity
                self.f.write(struct.pack("H", tile[0]))
                self.f.write(struct.pack("H", tile[1]))
                self.f.write(struct.pack("H", tile[2]))
    def entitys(self,ents):
        if self.VERSION < 2:
            raise Exception("Cannot attach entity data before version 2")
        data = b''
        for ent in ents:
            data += struct.pack("H", ent.Pointer)
            data += struct.pack("H", ent.PropCount)
            
            propdata = bytes(ent.Name,'utf-8')
            data += struct.pack("H", len(propdata))
            data += struct.pack("H", 2)
            data += propdata
            
            propdata = struct.pack("H",ent.Value)
            data += struct.pack("H", len(propdata))
            data += struct.pack("H", 0)
            data += propdata
        self.f.write(struct.pack("I", len(data)))
        self.f.write(data)
    def close(self):
        self.f.write(self.MAGICBYTES) # Write the end bytes
        self.f.close()
        pass

class LevelReader:
    MAGICBYTES = bytes([0xb4,0xf7]) #MagicBytes
    VERSION = 2
    fver = 0
    def open(self,filename):
        self.f = open(filename,'rb')
        magic = self.f.read(2)
        if magic != self.MAGICBYTES:
            self.f.close()
            raise Exception("File is not a recognised level file.")
        pass
    def close(self):
        self.f.close()
        
    @property
    def header(self):
        self.fver = struct.unpack("H",self.f.read(2))[0]
        if self.fver > self.VERSION:
            print("Warn: Version of file is _greater_ than supported by this file reader.")
        headerLen = struct.unpack("I",self.f.read(4))[0]
        nameLen = struct.unpack("I",self.f.read(4))[0]
        LevelName = self.f.read(nameLen).decode('utf-8')
        Author = self.f.read(headerLen - nameLen).decode('utf-8')
        return (LevelName,Author)
    @property
    def data(self):
        width = struct.unpack("I",self.f.read(4))[0]
        dataSize = struct.unpack("I",self.f.read(4))[0]
        height =  int(( dataSize / 6 ) / width)
        tiles = []
        entCount = 0
        for i in range(0,dataSize,6):
            tileType = self.f.read(2)
            tileType = struct.unpack("H",tileType)[0]
            
            tileRot = self.f.read(2)
            tileRot = struct.unpack("H",tileRot)[0]
            
            tileEnt = self.f.read(2)
            tileEnt = struct.unpack("H",tileEnt)[0]
            tiles.append((tileType,tileRot,tileEnt))
            if tileEnt != 0:
                entCount += 1
        return (width,height,entCount,tiles)
    @property
    def entitys(self):
        if self.VERSION < 2:
            raise Exception("Cannot read entity data before version 2")
        if self.fver < 2:
            print("Since the file version is outdated, entity data will not be loaded.",self.fver,"< 2")
            return
        ents = []
        blockLen = self.f.read(4)
        blockLen = struct.unpack("I",blockLen)[0]
        readSize = 0
        while blockLen > readSize:
            ent = {}
            pointer = self.f.read(2)
            readSize += 2
            ent["pointer"] = struct.unpack("H",pointer)[0]
            propcount = self.f.read(2)
            readSize += 2
            propcount = struct.unpack("H",propcount)[0]
            ent["props"] = []
            for i in range(0,propcount):
                proplen = self.f.read(2)
                readSize += 2
                proplen = struct.unpack("H",proplen)[0]
                
                proptype = self.f.read(2)
                readSize += 2
                proptype = struct.unpack("H",proptype)[0]
                
                prop = self.f.read(proplen)
                readSize += proplen
                if proptype == 0:
                    prop = struct.unpack("H",prop)[0]
                elif proptype == 1:
                    prop = struct.unpack("I",prop)[0]
                elif proptype == 2:
                    prop = prop.decode('utf-8')
                else:
                    print("Warning: Unknown property type for entity. Corruption possible or mismatched versions.(",proptype,")")
                ent["props"].append(prop)
            ents.append(ent)
        return ents
    def checkEnd(self):
        bfr = self.f.read(2)
        if bfr != self.MAGICBYTES:
            print("Warn: Possible data corruption, missing end of file.")
            
if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog="ShmupWithLove Level Library",description='Read and Write Level Data')
    parser.add_argument('-w', help='Write a basic file',action='store_true')
    parser.add_argument('-l', help='Level Name to write')
    parser.add_argument('-a', help='Author Name to write')
    
    parser.add_argument('filename', type=str, help='Filename to read/write to.')
    args = parser.parse_args()
    width = 32
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
        writer.data(width,[(0,0,0)]*width*2048)
        writer.entitys([DummyEntity()]*5)
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
        ents = r.entitys
        print("Entity Data Found:")
        for ent in ents:
            print("Ent " + str(ent["pointer"]) + ":")
            for prop in ent["props"]:
                print("\t" + str(prop))
        r.checkEnd()
        r.close()
