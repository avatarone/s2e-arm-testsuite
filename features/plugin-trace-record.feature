Feature: Test Record and Replay plugin (Record)

	Background:
		Given current test directory at "tests/trace"
		Given S2E config file named "record.arm.c.elf-config.lua"
		Given ARM firmware named "record-replay.arm.c.elf"
		When S2E test is run

	Scenario: Plugins are loaded
		Then the file "s2e-last/debug.txt" should not contain "Creating plugin ReplayMemoryAccess"
		And the file "s2e-last/debug.txt" should contain "Creating plugin ExecutionTracer"
		And the file "s2e-last/debug.txt" should contain "Creating plugin MemoryTracer"
		And the file "s2e-last/debug.txt" should contain "Creating plugin Annotation"
		And the file "s2e-last/debug.txt" should contain "Creating plugin MemoryInterceptorAnnotation"

	Scenario: Values are intercepted
		Then the file "s2e-last/debug.txt" should contain "OK: Terminated"

	Scenario: The trace file exists
		Then the following files should exist:
			| s2e-last/ExecutionTracer.dat |

	Scenario: The trace file contains the transactions
		Then the trace "s2e-last/ExecutionTracer.dat" should contain all the memory accesses from trace "ExecutionTracer.dat-recorded"
