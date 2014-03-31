Feature: Test IdentifyMemoryRegions plugin

    Background:
        Given current test directory at "tests/IdentifyMemoryRegionsPlugin"
        Given S2E config file named "write_ranges.arm.c.elf-config.lua"
        Given ARM firmware named "write_ranges.arm.c.elf"
        When S2E test is run

    Scenario: Plugin is loaded
        Then the file "s2e-last/debug.txt" should contain "Creating plugin IdentifyMemoryRegions"

    Scenario: Ranges are detected correctly
        Then the file "s2e-last/memory_regions.csv" should contain:
            """
            0x00000000, 0x00000100, code+rodata
            0x00000100, 0x00000040, rodata
            0x00000f40, 0x00000100, stack
            0x00010000, 0x00000080, rodata
            0x00010080, 0x00000040, data
            0x13000000, 0x00000040, io
            """
