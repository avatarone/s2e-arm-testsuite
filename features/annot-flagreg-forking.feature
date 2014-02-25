Feature: Annotations - Check making a flag register symbolic

    Background:
        Given current test directory at "tests/annotations"
        Given S2E config file named "symbolic-flag-reg.arm.S.bin-config.lua"
        Given ARM firmware named "symbolic-flag-reg.arm.S.bin"
        When S2E test is run


    Scenario: Check exit status
        Then the stdout should contain "status: 0x1"

    Scenario: Check exit status
        Then the stdout should contain "status: 0x2"

