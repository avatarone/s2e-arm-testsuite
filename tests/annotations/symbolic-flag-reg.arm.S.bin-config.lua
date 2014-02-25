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
  "RawMonitor",
  "ModuleExecutionDetector",
  "FunctionMonitor",
  "Annotation",
  "ExecutionTracer",
  "MemoryTracer",
	"MemoryInterceptor",
}

pluginsConfig = {
  RawMonitor = {
    kernelStart = 0,
    main = {
        delay      = false,
        name       = "main",
        start      = 0x10000,
        size       = 0xF0,
        nativebase = 0x10000,
        kernelmode = false
    }
  },
	MemoryTracer = {
		
		                    monitorMemory = true,
		                    manualTrigger = false,
		                    timeTrigger = false,
		                
	},
	MemoryInterceptor = {
		
		                verbose = true
	},
  ModuleExecutionDetector = {
    trackAllModules = true,
    configureAllModules = true,
    main = {
      moduleName = "main",
      kernelMode = true,
    }
  },
  Annotation = {
    myann = {
      module  = "main",
      active  = true,
      address = 0x10030,
      instructionAnnotation = "mark_flag_symbolic",
      beforeInstruction = true,
      switchInstructionToSymbolic = true,
	  --paramcount = 1,
    }
  }
}

function mark_flag_symbolic (state, plg)
	-- print("HitHitHitHitHitHitHitHitHitHitHitHit")
	state:setFlagSymb("ZF")
end

