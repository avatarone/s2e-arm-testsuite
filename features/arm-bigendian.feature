Feature: Check if endianness is respected for an ARM big endian processor

    Background:
        Given current test directory at "tests/arm-bigendian"
        Given S2E config file named "load_store.armeb.c.elf-config.lua"
        Given ARM firmware named "load_store.armeb.c.elf"
        When S2E test is run for architecture "armeb"

    Scenario: 32-bit constant load works
        Then the file "s2e-last/debug.txt" should contain "OK: 32-bit constant load test passed"

    Scenario: 16-bit constant load works
        Then the file "s2e-last/debug.txt" should contain "OK: 16-bit constant load test passed"

    Scenario: 8-bit constant load works
        Then the file "s2e-last/debug.txt" should contain "OK: 8-bit constant load test passed"

    Scenario: BE8 constant load works
        Then the file "s2e-last/debug.txt" should contain "OK: BE8 load test passed"