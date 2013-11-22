Feature: Annotations - Check concolic injection to register
    Check writeRegisterSymb concolic mode

    Background:
        Given current test directory at "tests/annotations"
        Given S2E config file named "concolic-reg.thumb.S.bin-config.lua"
        Given ARM firmware named "concolic-reg.thumb.S.bin"
        When S2E test is run


    Scenario: Check exit status
        Then the stdout should contain "status: 0x1"

    Scenario: Check initial values
        Then the stdout should contain:
        """
        Before injection R2 contains 0x00000002.
        Before injection R3 contains 0x000000ff.
        """


    Scenario: Check concolic injection
        Then the file "s2e-last/debug.txt" should contain:
        """
        S2ELUAExecutionState: Writing to register r2
        S2ELUAExecutionState: Writing to register r3
        """
    
    Scenario: Check concolic example
        Then the stdout should contain:
        """
        After injection R2 example is 0x00000002.
        After injection R3 example is 0x000000ff.
        """

