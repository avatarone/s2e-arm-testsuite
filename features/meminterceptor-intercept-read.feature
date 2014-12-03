Feature: Annotations - Check that intercepting memory reads works
    Check MemoryInterceptorAnnotation read_handler call

    Background:
        Given current test directory at "tests/AnnotationMemoryInterceptor"
        Given S2E config file named "read_intercept.arm.c.elf-config.lua"
        Given ARM firmware named "read_intercept.arm.c.elf"
        When S2E test is run

    Scenario:  MemoryInterceptorAnnotation plugin is loaded
        Then the file "s2e-last/debug.txt" should contain "Creating plugin MemoryInterceptorAnnotation"

    Scenario: MemoryInterceptorAnnotation read handler is called the first time
        Then the file "s2e-last/debug.txt" should contain "0: address = 0x900, size = 0x4, is_io = false, is_code = false"

    Scenario: MemoryInterceptorAnnotation read handler is called the second time
        Then the file "s2e-last/debug.txt" should contain "1: address = 0x900, size = 0x4, is_io = false, is_code = false"

    Scenario: Check that the injected values arrived in the virtual machine
        Then the file "s2e-last/debug.txt" should contain "OK: Values 42 and 13 were injected"

    Scenario: Check that injector is not invoked for not selected memory ranges
        Then the file "s2e-last/debug.txt" should not contain "2: address = 0x908, size = 0x4, is_io = false, is_code = false"

    Scenario: Check that the MemoryInterceptor plugin is invoked for code and data reads

        Then the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x0 [concrete], access_type = 0x10a4, size = 8, is_io = 0, is_code = 1"
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x0 [concrete], access_type = 0x40a4, size = 32, is_io = 0, is_code = 1"
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x4 [concrete], access_type = 0x40a4, size = 32, is_io = 0, is_code = 1"
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x8 [concrete], access_type = 0x40a4, size = 32, is_io = 0, is_code = 1"
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0xc [concrete], access_type = 0x40a4, size = 32, is_io = 0, is_code = 1"
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x10 [concrete], access_type = 0x40a4, size = 32, is_io = 0, is_code = 1"
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x14 [concrete], access_type = 0x40a4, size = 32, is_io = 0, is_code = 1"
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x18 [concrete], access_type = 0x40a4, size = 32, is_io = 0, is_code = 1"
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x900 [concrete], access_type = 0x40a1, size = 32, is_io = 0, is_code = 0"
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x900 [concrete], access_type = 0x40a1, size = 32, is_io = 0, is_code = 0"
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x908 [concrete], access_type = 0x40a1, size = 32, is_io = 0, is_code = 0"
