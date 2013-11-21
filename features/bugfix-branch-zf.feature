Feature: Bugfixes and regressions - Branch on zf
    Check regression against wrong ZF exemplification by S2E

    Background:
        Given current test directory at "tests/bugfix"
        Given S2E config file named "branch_zf.thumb.S.bin-config.lua"
        Given ARM firmware named "branch_zf.thumb.S.bin"
        When S2E test is run

    Scenario: Forking state 0
        Then the stdout should contain:
        """
        Forking state 0 at pc = 0x10014
        """
        And the stdout should contain:
        """
        Forking state 0 at pc = 0x10016
        """

    Scenario: Exactly two states
        Then the stdout should contain "State 0"
        And the stdout should contain "State 1"
        And the stdout should not contain "State 2"

    Scenario: Killing state 0
        Then the stdout should contain:
        """
        [State 0] State was terminated by opcode
                    message: ""
                    status: 0x2
        """


    Scenario: Killing state 1
        Then the stdout should contain:
        """
        [State 1] State was terminated by opcode
                    message: ""
                    status: 0x1
        """
