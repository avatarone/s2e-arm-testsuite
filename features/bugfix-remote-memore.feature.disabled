Feature: Test RemoteMemory bugfix (will take a lot of time)

    Background:
        Given The default aruba timeout is 180 seconds
        Given current test directory at "tests/RemoteMemory"
        Given S2E config file named "bugfix_tight_loop.arm.S.bin-config.lua"
        Given ARM firmware named "bugfix_tight_loop.arm.S.bin"
        When S2E test is run
        When test program "python delayed_server.py 127.0.0.1 5555" is run after 1 seconds

    Scenario: No deadlock on tight-loop writing
        Then the file "s2e-last/debug.txt" should contain "Creating plugin RemoteMemory"
        And the stdout should contain "Delayed server started"
        And the file "s2e-last/debug.txt" should contain:
        """
        [State 0] State was terminated by opcode
                    message: ""
                    status: 0x21998
        """

