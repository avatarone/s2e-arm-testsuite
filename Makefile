S2E_QEMU ?= ~/build/build/qemu-debug/arm-s2e-softmmu/qemu-system-arm

TARGETS = \
		tests/annotations \
		tests/arm-core \
		tests/armeb-core \
		tests/monitors \
		tests/bugfix \
		tests/arbexec \
		tests/symbolic \
		tests/s2e-opcodes \
		tests/AnnotationMemoryInterceptor \
		tests/RemoteMemory \
		tests/arm-bigendian \
		tests/IdentifyMemoryRegionsPlugin \
		tests/ControlFlowGraphPlugin \
		tests/SnapshotPlugin \
		tests/trace \
		tests/ConcolicValues \
		tests/ConcolicForkTracerPlugin \

.SECONDARY:

all: check

build:
	$(foreach dir,$(TARGETS),$(MAKE) -C $(dir) build;)

check: build
	S2E=$(S2E_QEMU) cucumber -q && $(MAKE) clean

.PHONY: run debug rdebug
run:
	$(foreach dir,$(TARGETS),$(MAKE) -C $(dir) run;)

debug: $(TARGET)
	$(foreach dir,$(TARGETS),$(MAKE) -C $(dir) debug;)

rdebug: $(TARGET)
	$(foreach dir,$(TARGETS),$(MAKE) -C $(dir) rdebug;)

.PHONY: clean logclean
clean: logclean
	$(foreach dir,$(TARGETS),$(MAKE) -C $(dir) clean;)

logclean:
	$(foreach dir,$(TARGETS),$(MAKE) -C $(dir) logclean;)
