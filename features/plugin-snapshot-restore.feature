Feature: Snapshot plugin
    Test saving a snapshot

    Background:
        Given current test directory at "tests/SnapshotPlugin"
        Given S2E config file named "restore.arm.c.elf-config.lua"
        Given ARM firmware named "restore.arm.c.elf"
        When S2E test is run

    Scenario: Plugin is loaded
        Then the stdout should contain "Creating plugin Snapshot"
		
	Scenario: Snapshot file is restored correctly
		The the output should contain "OK: Good values"
		
	