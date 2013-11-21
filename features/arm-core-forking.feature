Feature: Core ARM support - state forking
    Check S2E for ARM capabilities, state forking

    Background:
        Given current test directory at "tests/arm-core"
        Given S2E config file named "base-forking_test.arm.S.bin-config.lua"
        Given ARM firmware named "base-forking_test.arm.S.bin"
        When S2E test is run

    Scenario: Insert a symbolic value
        Then the stdout should contain:
        """
        Inserting symbolic data at 0x10040 of size 0x4 with name 'symbolic value'
        """

    Scenario: Forking state 0
        Then the stdout should contain:
        """
        Forking state 0 at pc = 0x10024
        """

    Scenario: Killing state 0
        Then the stdout should contain:
        """
        [State 1] State was terminated by opcode
                    message: "Not equal zero"
                    status: 0x1
        """


    Scenario: Killing state 1
        Then the stdout should contain:
        """
        [State 1] State was terminated by opcode
                    message: "Not equal zero"
                    status: 0x1
        """
