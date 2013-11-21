Feature: Monitors - ARMFunctionMonitor via annotations
    Check ARMFunctionMonitor features used in annotations

    Background:
        Given current test directory at "tests/monitors"
        Given S2E config file named "rawmon-subs.arm.S.bin-config.lua"
        Given ARM firmware named "rawmon-subs.arm.S.bin"
        When S2E test is run

    Scenario: No forking
        Then the stdout should contain "State 0"
        And the stdout should not contain "Forking state 0 at pc"

    Scenario: Check call trigger
        Then the stdout should contain:
        """
        entering function, setting value
        """

    Scenario: Check return trigger
        Then the stdout should contain:
        """
        exiting function, value is 42
        """

    Scenario: Check exit status
        Then the stdout should contain "status: 0xf"

    Scenario: Test OK
        Then the stdout should contain:
        """
        [State 0] State was terminated by opcode
                    message: "Test OK!"
        """
