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
  --"ArbitraryExecChecker",
  "FunctionMonitor",
  "Annotation",
  --"TestCaseGenerator",
  "ExecutionTracer"
}

pluginsConfig = {
  RawMonitor = {
    kernelStart = 0,
    jump = {
        delay      = false,
        name       = "jump",
        start      = 0x10000,
        size       = 0x100,
        nativebase = 0x10000,
        kernelmode = false
    }
  },
  ModuleExecutionDetector = {
    trackAllModules = true,
    configureAllModules = true,
    jump = {
      moduleName = "jump",
      kernelMode = true,
    }
  },
  Annotation = {
    myann = {
      module  = "jump",
      active  = true,
      address = 0x10012,
      beforeInstruction = true,
      switchInstructionToSymbolic = true,
      instructionAnnotation = "hello",
    }
  }  
}

function hello (state, plg)
    state:writeRegisterSymb("r0", "symb_target")
end



