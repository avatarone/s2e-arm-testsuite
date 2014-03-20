Feature: Snapshot plugin
    Test saving a snapshot

    Background:
        Given current test directory at "tests/SnapshotPlugin"
        Given S2E config file named "snapshot.arm.c.elf-config.lua"
        Given ARM firmware named "snapshot.arm.c.elf"
        When S2E test is run

    Scenario: Plugin is loaded
        Then the stdout should contain "Creating plugin Snapshot"
		
	Scenario: Snapshot file is created
		The the file "s2e-last/snapshots/testname.snapshot" should be present
		
	