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
  "FunctionMonitor",
  "ModuleExecutionDetector",
  "Annotation",
  "Snapshot"
}

pluginsConfig = {
	Snapshot = {
		verbose = true
	},
	-- Module in RawMonitor always needs to be kernelmode = false and in ModuleExecutionDetector kernelMode = true
	RawMonitor = {
		kernelStart = 0,
		blubb = {
		    delay      = false,
		    name       = "blubb",
		    start      = 0x0,
		    size       = 0x10000,
		    nativebase = 0x0,
		    kernelmode = false
		}
	},
	ModuleExecutionDetector = {
		trackAllModules = true,
		configureAllModules = true,
		blubb = {
		  moduleName = "blubb",
		  kernelMode = true,
		}
	},
	Annotation = {
		myann = {
		  module  = "blubb",
		  active  = true,
		  -- Annotation cannot be on the first basic block after module loading, thus insert an artificial beq .+4 in
		  -- the beginning of the test
		  address = 0x5c,
		  beforeInstruction = true,
		  switchInstructionToSymbolic = false,
		  instructionAnnotation = "ann_snapshot",
		}
	} 
}

function ann_snapshot(state, plg)
	print("Snapshot annotation called")
	Snapshot.takeSnapshot("testname", 0x7, {{address = 0x1000, size = 0x20000}})
end
