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
  "MemoryInterceptorAnnotation"
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
              access_type = {"write", "concrete_address", "concrete_value"},
              write_handler = "ann_write_intercept"
          }
      }
  }
}

function ann_write_intercept(state, plg, address, size, value, is_io)
    io.write(string.format("write interception annotation called with address = 0x%08x, size = %d, value = 0x%08x, is_io = %s\n", address, size, value, tostring(is_io)))
    if address == 0x900 and size == 4 then
        plg:writeMemory(0x900, 4, 13)
        plg:writeMemory(0x904, size, value)
        
        return true
    end
    
    return false
end

