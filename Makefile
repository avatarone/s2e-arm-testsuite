TOOLS_PREFIX ?= arm-linux-gnueabi-
CROSS_CC ?= $(TOOLS_PREFIX)gcc-4.7
OBJCOPY ?= $(TOOLS_PREFIX)objcopy
S2E_QEMU ?= ~/build/build/qemu-debug/arm-s2e-softmmu/qemu-system-arm
LDFLAGS += -Ttext=0x0  -nostdlib -nostdinc
CFLAGS += -march=armv5te -Wall -O0

TARGET ?= \
		hello.arm.S.bin \
		base-sleep_test.arm.S.bin \
		base-symexample_test.arm.S.bin \
		base-initial_test.arm.S.bin \
		base-forking_test.arm.S.bin \
		base-flags_test.arm.S.bin \
		base-memory_test.arm.S.bin \
		base-symreg_test.arm.S.bin \
		base-symcon_test.arm.S.bin \
		rawmon-subs.arm.S.bin \
		symbolic_pc.thumb.c.bin \
		simplefn.thumb.c.bin \
		jonas_bug_zf.thumb.S.bin \
		jumping_pc.thumb.c.bin \
		skipping_fn.thumb.c.bin \
		symbolic_load_target.thumb.S.bin


.SECONDARY:

all: $(TARGET)

%.arm.S.elf: %.arm.S s2earm-inst.S
	$(CROSS_CC) $(CFLAGS) $(LDFLAGS) -marm -o $@ $^

%.arm.c.elf: %.arm.c s2earm-inst.S
	$(CROSS_CC) $(CFLAGS) $(LDFLAGS) -marm -o $@ $^

%.thumb.S.elf: %.thumb.S s2earm-inst.S
	$(CROSS_CC) $(CFLAGS) $(LDFLAGS) -mthumb -o $@ $^

%.thumb.c.elf: %.thumb.c s2earm-inst.S
	$(CROSS_CC) $(CFLAGS) $(LDFLAGS) -mthumb -o $@ $^

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

.PHONY: run debug
run: $(TARGET)
	$(foreach bin,$^,echo $(bin); $(S2E_QEMU) -M integratorcp -m 4M -s2e-config-file $(bin)-config.lua -s2e-verbose -kernel $(bin) $(EXTRA);)
	@echo -e '\n--> Run `make logclean` to remove all output dirs \n'

debug: $(TARGET)
	$(foreach bin,$^,echo $(bin); gdbserver localhost:1222 $(S2E_QEMU) -M integratorcp -m 4M -s2e-config-file $(bin)-config.lua -s2e-verbose -kernel $(bin) $(EXTRA);)
	@echo -e '\n--> Run `make logclean` to remove all output dirs \n'

.PHONY: clean
clean: logclean
	rm -f *.bin *.elf *.o

logclean:
	rm -Rf s2e-last s2e-out-*
