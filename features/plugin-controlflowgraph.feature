Feature: Test ControlFlowGraph plugin

    Background:
        Given current test directory at "tests/ControlFlowGraphPlugin"
        Given S2E config file named "all_jumps.arm.c.elf-config.lua"
        Given ARM firmware named "all_jumps.arm.c.elf"
        When S2E test is run

    Scenario: Plugin is loaded
        Then the file "s2e-last/debug.txt" should contain "Creating plugin ControlFlowGraph"

    Scenario: Plugin is outputting a correct control flow graph
        Then the file "s2e-last/cfg.dot" should contain:
"""
digraph CFG {
    tb_0_0x54 [shape=oval,peripheries=2];
    tb_4_0x0 -> tb_5_0x8c;
    tb_4_0x0 -> tb_6_0x8c;
    tb_7_0x1c -> tb_5_0x8c;
    tb_8_0x38 -> tb_5_0x8c;
    tb_0_0x54 -> tb_1_0x90;
    tb_3_0x60 -> tb_4_0x0;
    tb_3_0x60 -> tb_7_0x1c;
    tb_3_0x60 -> tb_8_0x38;
    tb_5_0x8c -> tb_3_0x60;
    tb_6_0x8c -> tb_9_0x98;
    tb_1_0x90 -> tb_3_0x60;
}
"""
		
		
	
