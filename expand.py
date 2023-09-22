#!/usr/bin/python

FILENAME_IN = 'gyruss.nes'
FILENAME_OUT = 'expanded.nes'

HORIZONTAL = 0
VERTICAL = 1

# GNROM (INES Mapper 066)
PRG_ROM_SIZE_16K = 8
MIRRORING = VERTICAL
MAPPER = 66

with open(FILENAME_IN, 'rb') as inf:
    rom = bytearray(inf.read())

rom[4] = PRG_ROM_SIZE_16K
rom[6] = MIRRORING | ((MAPPER & 0xf) << 4)
rom[7] = MAPPER & 0xf0

rom_out = rom[:0x8010] + bytes(0x18000) + rom[0x8010:]

with open(FILENAME_OUT, 'wb') as outf:
    outf.write(rom_out)
