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
  "MemoryInterceptor",
  "Annotation",
  "MemoryInterceptorAnnotation",
--  "InstructionPrinter",
  "ExecutionTracer",
  "TestCaseGenerator",
  "RawMonitor",
  "ModuleExecutionDetector",
}

pluginsConfig = {
  Annotation = {},
  MemoryInterceptor = {
      verbose = true
  },
  MemoryInterceptorAnnotation = {
      interceptors = {
          first_interceptor = {
              address = 0x900,
              size = 4,
              access_type = {"read", "concrete_address", "concrete_value"},
              read_handler = "ann_read_intercept"
          }
      }
  }
}

function ann_read_intercept(plg, state, address, size, is_io, is_code)
    io.write(string.format("read interception annotation called with address = 0x%x, size = 0x%x, is_io = %s, is_code = %s\n", address, size, tostring(is_io), tostring(is_code)))
    
    if address == 0x900 and size == 4 then
        return 2, "test"
    end
    
    return 0, 0
end

