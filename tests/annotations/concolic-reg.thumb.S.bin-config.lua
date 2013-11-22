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
    insert = {
      module  = "jump",
      active  = true,
      address = 0x10022,
      beforeInstruction = true,
      switchInstructionToSymbolic = true,
      instructionAnnotation = "test1",
    },
    retrieve = {
      module  = "jump",
      active  = true,
      address = 0x10024,
      beforeInstruction = true,
      switchInstructionToSymbolic = true,
      instructionAnnotation = "test2",
    }
  }  
}

function test1 (state, plg)
    r2 = state:readRegister("r2")
    r3 = state:readRegister("r3")
    print(string.format("Before injection R2 contains 0x%08x.", r2))
    print(string.format("Before injection R3 contains 0x%08x.", r3))
    state:writeRegisterSymb("r2", "concolic_symbol_R2")
    state:writeRegisterSymb("r3", "concolic_symbol_R3")
end

function test2 (state, plg)
    r2 = state:readRegister("r2")
    r3 = state:readRegister("r3")
    print(string.format("After injection R2 example is 0x%08x.", r2))
    print(string.format("After injection R3 example is 0x%08x.", r3))
end


