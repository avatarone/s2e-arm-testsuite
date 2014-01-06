Feature: Check if symbolic execution creates the right constraints for big endian values

    Background:
        Given current test directory at "tests/arm-bigendian"
        Given S2E config file named "symbolic_uint16.armeb.c.elf-config.lua"
        Given ARM firmware named "symbolic_uint16.armeb.c.elf"
        When S2E test is run for architecture "armeb"

    Scenario: Both branches are executed and the symbolic value is correctly converted to a concrete
        Then the file "s2e-last/debug.txt" should contain "OK: sample == 42"
		And the file "s2e-last/debug.txt" should contain "OK: sample != 42"

    Scenario: Testcase generator is converting bytes to int values correctly
        Then the file "s2e-last/debug.txt" should contain:
        """
        v0_symbolic_test_0: 00 00, (string) ".."
        """
        And the file "s2e-last/debug.txt" should contain:
        """
        v0_symbolic_test_0: 00 2a, (string) ".*"
        """
