Feature: Monitors - ARMFunctionMonitor
    Check basic ARMFunctionMonitor features

    Background:
        Given current test directory at "tests/monitors"
        Given S2E config file named "simplefn.thumb.c.bin-config.lua"
        Given ARM firmware named "simplefn.thumb.c.bin"
        When S2E test is run

    Scenario: Forking state 0
        Then the stdout should contain:
        """
        Forking state 0 at pc = 0x1001c
        """

    Scenario: Exactly two states
        Then the stdout should contain "State 0"
        And the stdout should contain "State 1"
        And the stdout should not contain "State 2"

    Scenario: Two different sum results
        Then the stdout should contain "status: 0x2"
            And the stdout should contain "status: 0x9"
