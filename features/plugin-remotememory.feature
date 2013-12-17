Feature: Test RemoteMemory plugin

    Background:
        Given current test directory at "tests/RemoteMemory"
        Given S2E config file named "remote_memory.arm.c.elf-config.lua"
        Given ARM firmware named "remote_memory.arm.c.elf"
        When S2E test is run
        When test program "python test_server.py localhost 5555" is run after 1 seconds

    Scenario: RemoteMemory plugin is loaded
        Then the file "s2e-last/debug.txt" should contain "Creating plugin RemoteMemory"

    Scenario: Test server can connect and answers requests
        Then the stdout should contain "First read received ok"
        And the stdout should contain "Second read received ok"
        And the stdout should contain "Third read received ok"
        And the stdout should contain "Fourth write received ok"
        And the stdout should contain "Fifth write received ok"
        And the stdout should contain "Sixth write received ok"

    Scenario: Program receives good data and terminates as expected
        Then the file "s2e-last/debug.txt" should contain:
        """
        [State 0] State was terminated by opcode
                    message: "OK: Terminated"
                    status: 0x0
        """
