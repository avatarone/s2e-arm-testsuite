Feature: Annotations - Check changing the value of a flag

    Background:
        Given current test directory at "tests/annotations"
        Given S2E config file named "flag-reg.arm.S.bin-config.lua"
        Given ARM firmware named "flag-reg.arm.S.bin"
        When S2E test is run

	Scenario: Check execution path changing
		Then the stdout should not contain "status: 0x3"
		And the stdout should contain "status: 0xa"
		And the stdout should not contain "Forking state"
		And the stdout should not contain "Failed to change the flag"
