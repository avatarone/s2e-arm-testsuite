#!/usr/bin/env python3

import sys
import struct

SECTION_TYPE_EOF = 0
SECTION_TYPE_START = 1
SECTION_TYPE_FULL = 2

ARCH_I386 = 0x03
ARCH_ARM = 0x28
ARCH_X86_64 = 0x3e

ENDIANNESS = {0: "little", 1: "big_be32", 2:"big_be8"}
ARCHITECTURE = {ARCH_I386: "i386", ARCH_X86_64: "x86_64", ARCH_ARM: "arm"}




class Snapshot():
    def __init__(self, filename):
        with open(filename, 'rb') as file:
            self.file = file
            self._check_header(file)
            self._sections = []
            while True:
                section_data = self._read_section(file)
                if section_data is None:
                    break
                self._sections.append(section_data)
                    
            
            
    def _check_header(self, fh):
        if fh.read(4) != bytes([0x51, 0x53, 0x32, 0x45]):
            raise Exception("Wrong file magic")
        version = struct.unpack(">L", fh.read(4))[0]
        if version != 1:
            raise Exception("Unknown snapshot file version %d; don't know how to unpack" % version)
            
    def _read_section(self, fh):
        section_start = fh.read(1)[0]
        
        if (section_start == 0x00): #EOF
            return None
        assert(section_start == 0xfe)
        section_size = struct.unpack(">L", fh.read(4))[0]
        section_id = struct.unpack(">L", fh.read(4))[0]
        section_name = self._get_string(fh)
        
        section_remaining_size = section_size - (1 + 4 + 4 + 2 + len(section_name))
        section_data = self._parse_section(fh, section_remaining_size, section_id, section_name)
        
        return {"id": section_id, "size": section_size, "name": section_name, "data": section_data}
        
    def _parse_section(self, fh, size, section_id, section_name):
        if section_id == 1 and section_name == "machine":
            return self._parse_machine_section(fh, size)
        elif section_id == 0 and section_name == "cpu":
            return self._parse_cpu_section(fh, size)
        else:
            assert(False)
            
    def _parse_machine_section(self, fh, size):
        version = struct.unpack(">L", fh.read(4))[0]
        assert(version == 0)
        name = self._get_string(fh)
        endianness = fh.read(1)[0]

        assert(size == 4 + len(name) + 2 + 1)
        
        return {"name": name, "endianness": ENDIANNESS[endianness]}
        
    def _parse_cpu_section(self, fh, size):
        version = struct.unpack(">L", fh.read(4))[0]
        architecture = fh.read(1)[0]
        model = self._get_string(fh)
        assert(version == 6)
        assert(architecture == ARCH_ARM) #Nothing else implemented yet
        
        cpu_state = self._parse_arm_cpu_section(fh, size - 4 - 1 - len(model) - 2)
        return {"model": model, "architecture": ARCHITECTURE[architecture], "state": cpu_state}
        
    def _parse_arm_cpu_section(self, fh, size):
        state = {}
        for i in range(0, 14):
            value = struct.unpack(">L", fh.read(4))[0]
            state["r%d" % i] = value
        state["pc"] = struct.unpack(">L", fh.read(4))[0]
        state["cpsr"] = struct.unpack(">L", fh.read(4))[0]
        state["spsr"] = struct.unpack(">L", fh.read(4))[0]
        #TODO: Other registers
        
        
        fh.seek(size - 15 * 4 - 3 * 4, 1)
        
        return state
        
    def _get_string(self, fh):
        length = struct.unpack(">H", fh.read(2))[0]
        return fh.read(length).decode(encoding = "iso-8859-1")
        
        

def main():
    snapshot = Snapshot(sys.argv[1])
    print(snapshot._sections)


if __name__ == "__main__":
	main()