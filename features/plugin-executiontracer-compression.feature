Feature: Test compressed trace file generation of ExecutionTracer

	Background:
		Given current test directory at "tests/ExecutionTracerPlugin"
		Given S2E config file named "compressed.arm.c.elf-config.lua"
		Given ARM firmware named "compressed.arm.c.elf"
		When S2E test is run

	Scenario: Good trace file is generated
		Then the following files should exist:
			 | s2e-last/ExecutionTracer.dat.gz |
		And the trace "s2e-last/ExecutionTracer.dat.gz" should contain all the memory accesses from trace "ExecutionTracer.dat.gz-recorded.gz"
		And the file "s2e-last/debug.txt" should contain "OK: Terminated"
