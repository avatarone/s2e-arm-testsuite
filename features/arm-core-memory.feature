Feature: Core ARM support - Memory operations
    Check S2E for ARM capabilities, memory handling

    Background:
        Given current test directory at "tests/arm-core"
        Given S2E config file named "base-memory_test.arm.S.bin-config.lua"
        Given ARM firmware named "base-memory_test.arm.S.bin"
        When S2E test is run

    Scenario: Check S2E_RAM_OBJECT_BITS value
        Then the stdout should contain:
        """
        SymbExpression S2E_RAM_OBJECT_BITS: - 0x7
        SymbExpression S2E_RAM_OBJECT_BITS: - Value: 0x7
        """

    Scenario: Check PathID
        Then the stdout should contain:
        """
        SymbExpression Path ID: - 0x0
        SymbExpression Path ID: - Value: 0x0
        """

    Scenario: Check Pagesize
        Then the stdout should contain:
        """
        SymbExpression Pagesize - 0x80
        SymbExpression Pagesize - Value: 0x80
        """
        
    Scenario: Check MemCheck iterations
        Then the stdout should contain:
        """
        SymbExpression MemCheck iterations - 0x80
        SymbExpression MemCheck iterations - Value: 0x80
        """
        
    Scenario: Overall memory OK
        Then the stdout should contain "Test OK!"
        
    Scenario: No Memory error
        Then the stdout should not contain "Memory ERROR!"

    Scenario: No Test error
        Then the stdout should not contain "Test ERROR!"
