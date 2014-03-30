-- File: config.lua
s2e = {
  kleeArgs = {
    -- Pick a random path to execute among all the
    -- available paths.
    "--use-random-path=true",

    -- Run each state for at least 1 second before
    -- switching to the other:
    "--use-batching-search=true", 
    "--batch-time=1.0",
    "--use-concolic-execution=true",
	"--debug-print-instructions",
	"--print-llvm-instructions",
	"--print-mode-switch",
	"--use-cache=false",
	"--use-cex-cache=false"
  }
}

plugins = {
  -- Enable a plugin that handles S2E custom opcode
  "BaseInstructions",
  "TestCaseGenerator",
  "ExecutionTracer"
}

pluginsConfig = {
}
