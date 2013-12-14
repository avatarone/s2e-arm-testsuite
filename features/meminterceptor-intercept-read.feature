Feature: Annotations - Check that intercepting memory reads works
    Check MemoryInterceptorAnnotation read_handler call

    Background:
        Given current test directory at "tests/AnnotationMemoryInterceptor"
        Given S2E config file named "read_intercept.arm.c.elf-config.lua"
        Given ARM firmware named "read_intercept.arm.c.elf"
        When S2E test is run

    Scenario: MemoryInterceptorAnnotation read handler is called the first time
        Then the stdout should contain "0: address = 0x900, size = 0x4, is_io = false, is_code = false"

    Scenario: MemoryInterceptorAnnotation read handler is called the second time
        Then the stdout should contain "1: address = 0x900, size = 0x4, is_io = false, is_code = false"

    Scenario: Check that the injected values arrived in the virtual machine
        Then the stdout should contain "OK: Values 42 and 13 were injected"

    Scenario: Check that the MemoryInterceptor plugin is invoked
        Then the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x0 [concrete], access_type = 0xa4, size = 8, is_io = 0, is_code = 1"
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x0 [concrete], access_type = 0xa4, size = 32, is_io = 0, is_code = 1" 
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x4 [concrete], access_type = 0xa4, size = 32, is_io = 0, is_code = 1" 
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x8 [concrete], access_type = 0xa4, size = 32, is_io = 0, is_code = 1" 
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0xc [concrete], access_type = 0xa4, size = 32, is_io = 0, is_code = 1" 
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x10 [concrete], access_type = 0xa4, size = 32, is_io = 0, is_code = 1" 
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x14 [concrete], access_type = 0xa4, size = 32, is_io = 0, is_code = 1" 
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x18 [concrete], access_type = 0xa4, size = 32, is_io = 0, is_code = 1" 
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x900 [concrete], access_type = 0xa1, size = 32, is_io = 0, is_code = 0" 
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x900 [concrete], access_type = 0xa1, size = 32, is_io = 0, is_code = 0" 
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x1c [concrete], access_type = 0xa4, size = 32, is_io = 0, is_code = 1" 
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x20 [concrete], access_type = 0xa4, size = 32, is_io = 0, is_code = 1" 
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x34 [concrete], access_type = 0xa4, size = 32, is_io = 0, is_code = 1" 
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x38 [concrete], access_type = 0xa4, size = 32, is_io = 0, is_code = 1" 
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x3c [concrete], access_type = 0xa4, size = 32, is_io = 0, is_code = 1" 
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x48 [concrete], access_type = 0xa1, size = 32, is_io = 0, is_code = 0" 
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x88 [concrete], access_type = 0xa4, size = 32, is_io = 0, is_code = 1" 
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x8c [concrete], access_type = 0xa4, size = 32, is_io = 0, is_code = 1" 
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryRead called with address = 0x90 [concrete], access_type = 0xa4, size = 32, is_io = 0, is_code = 1"
