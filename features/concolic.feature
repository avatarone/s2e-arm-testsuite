Feature: Test concolic values

    Background:
        Given current test directory at "tests/ConcolicValues"
        Given S2E config file named "concolic.arm.c.elf-config.lua"
        Given ARM firmware named "concolic.arm.c.elf"
        When S2E test is run

    Scenario: Only one state is executed with a concolic value
        Then the output should contain "Result = 1"
		And the output should contain "Killing state 0"
		And the output should not contain "Killing state 1"
		And the output should contain "(ReadLSB w32 0x0 v0_blubb_0))"