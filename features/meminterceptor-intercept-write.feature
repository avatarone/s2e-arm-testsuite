Feature: Annotations - Check that intercepting memory reads works
    Check MemoryInterceptorAnnotation read_handler call

    Background:
        Given current test directory at "tests/AnnotationMemoryInterceptor"
        Given S2E config file named "write_intercept.arm.c.elf-config.lua"
        Given ARM firmware named "write_intercept.arm.c.elf"
        When S2E test is run

    Scenario: MemoryInterceptor plugin is loaded
        Then the file "s2e-last/debug.txt" should contain "Creating plugin MemoryInterceptor"

    Scenario: MemoryInterceptorAnnotation plugin is loaded
        TThen the file "s2e-last/debug.txt" should contain "Creating plugin MemoryInterceptorAnnotation"

    Scenario: Write annotation is added
        Then the file "s2e-last/debug.txt" should contain "[MemoryInterceptorAnnotation] Adding annotation for memory range 0x900-0x904 with access type 0x1aa, read handler '', write handler 'ann_write_intercept'"    

    Scenario: Write annotation is invoked
        Then the stdout should contain "write interception annotation called with address = 0x00000900, size = 4, value = 0x0000002a, is_io = false"
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryWrite called with address = 0x900 [concrete], access_type = 0xaa, is_io = 0"

    Scenario: Write annotation is not invoked for not selected memory ranges
        Then the stdout should not contain "write interception annotation called with address = 0x00000908, size = 4, value = 0x0000000d, is_io = false"
        And the file "s2e-last/debug.txt" should contain "[MemoryInterceptor] slotMemoryWrite called with address = 0x908 [concrete], access_type = 0xaa, is_io = 0"

    Scenario: Memory values are read by code inside virtual machine
        Then the stdout should contain "OK: Values 13 and 42 were read after write"
