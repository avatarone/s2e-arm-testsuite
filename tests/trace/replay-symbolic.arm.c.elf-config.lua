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
	"--use-expr-simplifier=false",
--	"--debug-print-instructions=true",
--	"--print-llvm-instructions=true",
	--"--always-klee"
  }
}

plugins = {
  "BaseInstructions",
  "MemoryInterceptor",
  -- "Annotation",
  "MemoryTracer",
  "ModuleExecutionDetector",
  "ExecutionTracer",
  "RawMonitor",
  "ReplayMemoryAccesses",
  "TestCaseGenerator",
  --"InstructionPrinter",
}

pluginsConfig = {
	MemoryInterceptor = {
		verbose = false
	},
	ReplayMemoryAccesses = {
		verbose = true,
		replayTraceFileName = "ExecutionTracer.dat-recorded",
		insertSymbol = true,
		ranges = {
			all_the_memory = {
				address = 0x10000,
				size = 0x1000,
				access_type = {"write", "read", "concrete_address", "concrete_value"},
			}
		}
	},
}
