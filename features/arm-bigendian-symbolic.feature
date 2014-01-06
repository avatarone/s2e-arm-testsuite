Feature: Check if symbolic execution creates the right constraints for big endian values

    Background:
        Given current test directory at "tests/arm-bigendian"
        Given S2E config file named "symbolic.armeb.c.elf-config.lua"
        Given ARM firmware named "symbolic.armeb.c.elf"
        When S2E test is run for architecture "armeb"

    Scenario: Both branches are executed
        Then the file "s2e-last/debug.txt" should contain "OK: sample < 42"
		And the file "s2e-last/debug.txt" should contain "OK: sample >= 42"