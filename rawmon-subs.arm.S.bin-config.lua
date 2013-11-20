-- File: config.lua
s2e = {
  kleeArgs = {
    -- Pick a random path to execute among all the
    -- available paths.
    "--use-random-path=true",

    -- Run each state for at least 1 second before
    -- switching to the other:
    "--use-batching-search=true", "--batch-time=1.0"
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
    fn1 = {
        delay      = false,
        name       = "fn1",
        start      = 0x1002c,
        size       = 0x0c,
        nativebase = 0x1002c,
        kernelmode = false
    }
  },
  ModuleExecutionDetector = {
    trackAllModules = true,
    configureAllModules = true,
    fn1 = {
      moduleName = "fn1",
      kernelMode = true,
    }
  },
  Annotation = {
    myann = {
      module  = "fn1",
      active  = true,
      address = 0x1002c,
      callAnnotation = "hello",
      paramcount = 0
      
    }
  }  
}

function hello (state, plg)
  if plg:isCall() then
      print ("entering function, setting value")
      plg:setValue("answer", 42)
  elseif plg:isReturn() then
      a = plg:getValue("answer")
      print ("exiting function, value is " .. a)
      
  end
end

