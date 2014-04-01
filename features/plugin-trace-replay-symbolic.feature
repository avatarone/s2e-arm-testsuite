Feature: Test Record and Replay plugin (Replay Symbols)

	Background:
		Given current test directory at "tests/trace"
		Given S2E config file named "replay-symbolic.arm.c.elf-config.lua"
		Given ARM firmware named "replay-symbolic.arm.c.elf"
		When S2E test is run

	Scenario: Plugins are loaded
		Then the file "s2e-last/debug.txt" should contain "Creating plugin ReplayMemoryAccess"
		And the file "s2e-last/debug.txt" should contain "Creating plugin TestCaseGenerator"
		And the file "s2e-last/debug.txt" should not contain "Creating plugin Annotation"
		And the file "s2e-last/debug.txt" should not contain "Creating plugin MemoryInterceptorAnnotation"

	Scenario: Values are replaied
		Then the file "s2e-last/debug.txt" should contain "OK: Terminated"

	Scenario: Values are symbolical at the end
		Then the file "s2e-last/debug.txt" should match /v0_replay_symbolic_@0x[0-9a-fA-F]+_0: ef be ad de/
		And the file "s2e-last/debug.txt" should match /v1_replay_symbolic_@0x[0-9a-fA-F]+_1: be ba/
		And the file "s2e-last/debug.txt" should match /v2_replay_symbolic_@0x[0-9a-fA-F]+_2: 13/

	Scenario: Constraints are printed for third var (override)
		Then the file "s2e-last/debug.txt" should contain "SymbExpression third_var_zero - Value: 0x0"
		And the file "s2e-last/debug.txt" should contain "SymbExpression third_var_zero - 0x0"

	Scenario: Constraints are printed for third var
		Then the file "s2e-last/debug.txt" should contain "SymbExpression third_var_not_zero - (Add w32 (w32 0x20)"
		And the file "s2e-last/debug.txt" should match /ZExt w32 \(Read w8 0x0 v2_replay_symbolic_@0x[0-9a-fA-F]+_2\)\)\)/
		And the file "s2e-last/debug.txt" should contain "SymbExpression third_var_not_zero - Value: 0x33"

	Scenario: Constraints are printed for second var
		Then the file "s2e-last/debug.txt" should contain "SymbExpression second_var - (Add w32 (w32 0x21)"
		And the file "s2e-last/debug.txt" should match /\(ZExt w32 \(ReadLSB w16 0x0 v1_replay_symbolic_@0x[0-9a-fA-F]+_1\)\)\)/
		And the file "s2e-last/debug.txt" should contain "SymbExpression second_var - Value: 0xbadf"

	Scenario: Constraints are printed for the first var
		Then the file "s2e-last/debug.txt" should match /SymbExpression first_var - \(Shl w32 \(ReadLSB w32 0x0 v0_replay_symbolic_@0x[0-9a-fA-F]+_0\)/
		And the file "s2e-last/debug.txt" should contain "(w32 0x5))"
		And the file "s2e-last/debug.txt" should contain "SymbExpression first_var - Value: 0xd5b7dde0"
