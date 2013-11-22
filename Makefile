S2E_QEMU ?= ~/build/build/qemu-debug/arm-s2e-softmmu/qemu-system-arm

TARGETS = \
		tests/annotations \
		tests/arm-core \
		tests/monitors \
		tests/bugfix \
		tests/arbexec \
		tests/symbolic \
		tests/s2e-opcodes

.SECONDARY:

all: check

build:
	$(foreach dir,$(TARGETS),$(MAKE) -C $(dir) build;)

check: build
	S2E=$(S2E_QEMU) cucumber -q && $(MAKE) clean

.PHONY: run debug
run: $(TARGETS)
	$(foreach bin,$^,echo $(bin); $(S2E_QEMU) -M integratorcp -m 4M -s2e-config-file $(bin)-config.lua -s2e-verbose -kernel $(bin) $(EXTRA);)
	@echo -e '\n--> Run `make logclean` to remove all output dirs \n'

debug: $(TARGET)
	$(foreach bin,$^,echo $(bin); gdbserver localhost:10000 $(S2E_QEMU) -M integratorcp -m 4M -s2e-config-file $(bin)-config.lua -s2e-verbose -kernel $(bin) $(EXTRA);)
	@echo -e '\n--> Run `make logclean` to remove all output dirs \n'

.PHONY: clean logclean
clean: logclean
	$(foreach dir,$(TARGETS),$(MAKE) -C $(dir) clean;)

logclean:
	$(foreach dir,$(TARGETS),$(MAKE) -C $(dir) logclean;)
