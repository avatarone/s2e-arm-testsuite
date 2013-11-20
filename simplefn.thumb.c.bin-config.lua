
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
}

pluginsConfig = {
  RawMonitor = {
    kernelStart = 0,
    sum = {
        delay      = false,
        name       = "sum",
        start      = 0x10000,
        size       = 0x70,
        nativebase = 0x10000,
        kernelmode = false
    }
  },
  ModuleExecutionDetector = {
    trackAllModules = true,
    configureAllModules = true,
    sum = {
      moduleName = "sum",
      kernelMode = true,
    }
  },
  Annotation = {
    myann = {
      module  = "sum",
      active  = true,
      address = 0x10034,
      callAnnotation = "sum_call",
      paramcount = 2
      
    }
  }  
}

function sum_call (state, plg)
  if plg:isCall() then
    print ("calling sum()")
    r0 = state:readRegister("r0")
    r1 = state:readRegister("r1")
    print(string.format("op0=0x%08x", r0))
    print(string.format("op1=0x%08x", r1))
    r1bis = -3
    state:writeParameter(1, r1bis, "aapcs")
    r1 = state:readRegister("r1")
    print(string.format("injected op1=0x%08x", r1))
  elseif plg:isReturn() then
    out = state:readRegister("r0")
    print ("output=" .. out)
    state:writeRegisterSymb("r0", "op1")
  end
end





