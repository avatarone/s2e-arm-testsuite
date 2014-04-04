#!/usr/bin/env python3

import sys
import struct
import os
import gzip
import argparse

class ConcolicTraceFile():
    def __init__(self, filename):
        self._filename = filename

    def read_all(self):
        #read header
        if self._filename.endswith(".gz"):
            file = gzip.GzipFile(self._filename, "rb")
        else:
            file = open(self._filename, "rb")
            
        try:
            while True:
                (size, type) = struct.unpack("<LL", file.read(8))
                assert(type == 0)
            
                (pc, killed_state_id, condition_length) = struct.unpack("<QQH", file.read(18))
                condition = file.read(condition_length).decode(encoding = "iso-8859-1")
                yield {"pc": pc, "killed_state_id": killed_state_id, "condition": condition}
        except struct.error:
            pass
            
        file.close()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("tracefile", type = str, metavar = "FILE", help = "Concolic fork trace file")
    args = parser.parse_args()
    
    trace_file = ConcolicTraceFile(args.tracefile)
    for record in trace_file.read_all():
        print("killed_state_id = %d, condition = \"%s\"" % (record["killed_state_id"], " ".join(record["condition"].split())))

if __name__ == "__main__":
    main()