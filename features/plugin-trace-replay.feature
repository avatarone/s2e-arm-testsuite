Feature: Test Record and Replay plugin (Replay)

	Background:
		Given current test directory at "tests/trace"
		Given S2E config file named "replay.arm.c.elf-config.lua"
		Given ARM firmware named "record-replay.arm.c.elf"
		When S2E test is run

	Scenario: Plugins are loaded
		Then the file "s2e-last/debug.txt" should contain "Creating plugin ReplayMemoryAccess"
		And the file "s2e-last/debug.txt" should not contain "Creating plugin Annotation"
		And the file "s2e-last/debug.txt" should not contain "Creating plugin MemoryInterceptorAnnotation"

	Scenario: Values are replaied
		Then the file "s2e-last/debug.txt" should contain "OK: Terminated"
