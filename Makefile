.DELETE_ON_ERROR:

AS = wla-6502
LD = wlalink
LDFLAGS = -S
LINKFILE = linkfile

hack.nes: hack.o
	$(LD) $(LDFLAGS) $(LINKFILE) $@

hack.o: hack.asm expanded.nes
	$(AS) -o $@ $<

expanded.nes: expand.py
	python3 $<

.PHONY:
clean:
	rm -rf *.o hack.nes expanded.nes hack.sym
