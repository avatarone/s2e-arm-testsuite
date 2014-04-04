Feature: Check that the ConcolicForkTracer plugin traces concolic forks

    Background:
        Given current test directory at "tests/ConcolicForkTracerPlugin"
        Given S2E config file named "concolic.arm.c.elf-compressed-config.lua"
        Given ARM firmware named "concolic.arm.c.elf"
        When S2E test is run

    Scenario: Test that concolic value is returned correctly
		Then an invocation of "parse_concolic_fork_trace.py" with the file "s2e-last/ConcolicForkTrace.dat.gz" should print:
		"""
		killed_state_id = 1, condition = "(Eq (w32 0x0) (Concat w32 (w8 0x0) (Concat w24 (w8 0x0) (Concat w16 (w8 0x0) (ZExt w8 (Ule (w32 0x70) (Add w32 (w32 0x42) (ReadLSB w32 0x0 v0_blubb_0))))))))"
		killed_state_id = 2, condition = "(Eq (w32 0x2e) (ReadLSB w32 0x0 v0_blubb_0))"
		killed_state_id = 3, condition = "(Eq (w32 0x0) (Concat w32 (w8 0x0) (Concat w24 (w8 0x0) (Concat w16 (w8 0x0) (ZExt w8 (Ule (w32 0x70) (Add w32 (w32 0x42) (ReadLSB w32 0x0 v0_blubb_0))))))))"
		killed_state_id = 4, condition = "(Eq (w32 0x2e) (ReadLSB w32 0x0 v0_blubb_0))"
		"""