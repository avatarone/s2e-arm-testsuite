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
  "ArbitraryExecChecker",
  "FunctionMonitor",
  "Annotation",
  "TestCaseGenerator",
  "ExecutionTracer"
}

pluginsConfig = {
  RawMonitor = {
    kernelStart = 0,
    jump = {
        delay      = false,
        name       = "jump",
        start      = 0x10000,
        size       = 0xF0,
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
      address = 0x10038,
      callAnnotation = "hello",
      paramcount = 1
      
    }
  }  
}

function hello (state, plg)
  if plg:isCall() then
    lr = state:readRegister("lr")
    print(string.format("Skipping function, going straight to 0x%08x", lr))
    plg:setSkip(true);
    print("Exit status should be 0x42.")
  end
end

