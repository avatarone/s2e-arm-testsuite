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
    "--use-concolic-execution=true"
  }
}

plugins = {
  -- Enable a plugin that handles S2E custom opcode
  "BaseInstructions",
  "ExecutionTracer",
  "MemoryTracer",
  "ModuleExecutionDetector",
  "RawMonitor"
}

pluginsConfig = {
	ExecutionTracer = {
		compression = "gzip"
	},
	MemoryTracer = {
		monitorMemory = true,
		manualTrigger = false,
		timeTrigger = false,
	},
	ModuleExecutionDetector = {
		trackAllModules = true,
		configureAllModules = true,
		ram_module = {
			moduleName = "ram_module",
			kernelMode = true,
		},
	},
	RawMonitor = {
		kernelStart = 0,
		-- we consider RAM
		ram_module = {
			delay      = false,
			name       = "ram_module",
			start      = 0x00000000,
			size       = 0xffffffff,
			nativebase = 0x00000000,
			kernelmode = false
		},
	}
}
