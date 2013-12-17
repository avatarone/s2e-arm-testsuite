Feature: Test MemoryInjectorAnnotation plugin symbolic injections on read
    Check MemoryInterceptorAnnotation read_handler call with symbolic values

    Background:
        Given current test directory at "tests/AnnotationMemoryInterceptor"
        Given S2E config file named "intercept_symbolic.arm.c.elf-config.lua"
        Given ARM firmware named "intercept_symbolic.arm.c.elf"
        When S2E test is run

    Scenario: MemoryInterceptor plugin is loaded
        Then the file "s2e-last/debug.txt" should contain "Creating plugin MemoryInterceptor"

    Scenario: S2E switches to symbolic mode because a symbolic value has been inserted
        Then the file "s2e-last/debug.txt" should contain "[MemoryInterceptorAnnotation] read annotation returned symbolic value in concrete mode"
        And the file "s2e-last/debug.txt" should contain "switching to symbolic mode"

    Scenario: State 0 terminates
        Then the file "s2e-last/debug.txt" should contain "state with condition b != 42 terminated"
        And the file "s2e-last/debug.txt" should contain:
        """
        v0_test_0: 00 00 00 00, (int32_t) 0, (string) "...."
        """

    Scenario: State 1 terminates
        Then the file "s2e-last/debug.txt" should contain "state with condition b == 42 terminated"
        And the file "s2e-last/debug.txt" should contain:
        """
        v0_test_0: 2a 00 00 00, (int32_t) 42, (string) "*..."
        """