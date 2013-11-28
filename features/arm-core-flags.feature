Feature: Core ARM support - CPU flags
    Check S2E for ARM capabilities, CPU flags handling

    Background:
        Given current test directory at "tests/arm-core"
        Given S2E config file named "base-flags.config.lua"
        Given ARM firmware named "base-flags_test.arm.S.bin"
        When S2E test is run

    Scenario: Set all flags to 0 (0x0)
        Then the stdout should contain:
        """
        SymbExpression Flagtest:  - 0x0
        SymbExpression Flagtest:  - Value: 0x0
        """

    Scenario: Set all flags to 1 (0xF)
        Then the stdout should contain:
        """
        SymbExpression Flagtest:  - 0xf0000000
        SymbExpression Flagtest:  - Value: 0xf0000000
        """

    Scenario: Set C=1 (0x2)
        Then the stdout should contain:
        """
        SymbExpression Flagtest:  - 0x20000000
        SymbExpression Flagtest:  - Value: 0x20000000
        """
        
    Scenario: Set Z=1 (0x4)
        Then the stdout should contain:
        """
        SymbExpression Flagtest:  - 0x40000000
        SymbExpression Flagtest:  - Value: 0x40000000
        """
        
    Scenario: Set [Z=1,C=1] (0x6)
        Then the stdout should contain:
        """
        SymbExpression Flagtest:  - 0x60000000
        SymbExpression Flagtest:  - Value: 0x60000000
        """

    Scenario: Set N=1 (0x8)
        Then the stdout should contain:
        """
        SymbExpression Flagtest:  - 0x80000000
        SymbExpression Flagtest:  - Value: 0x80000000
        """

