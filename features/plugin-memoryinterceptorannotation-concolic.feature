Feature: Annotations - Check that returning concolic value works

    Background:
        Given current test directory at "tests/AnnotationMemoryInterceptor"
        Given S2E config file named "concolic.arm.c.elf-config.lua"
        Given ARM firmware named "concolic.arm.c.elf"
        When S2E test is run

    Scenario: Test that concolic value is returned correctly
        Then the output should contain "Result = 1"
		And the output should contain "Killing state 0"
		And the output should not contain "Killing state 1"
		And the output should not contain "Result = 0"
		And the output should contain:
		"""
		status: (Add w32 (w32 0x42)
		         (ReadLSB w32 0x0 v1_test_1))
		"""