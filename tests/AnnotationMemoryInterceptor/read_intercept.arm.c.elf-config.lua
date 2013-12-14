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
              access_type = {"read", "concrete_address", "concrete_value"},
              read_handler = "ann_read_intercept"
          }
      }
  }
}

function ann_read_intercept(state, plg, address, size, is_io, is_code)
    local call_nr = state:getValue("call_nr")
    state:setValue("call_nr", call_nr + 1)
    io.write(string.format("%d: address = 0x%x, size = 0x%x, is_io = %s, is_code = %s\n", call_nr, address, size, tostring(is_io), tostring(is_code)))
    if address == 0x900 and size == 4 then
        if state:getValue("bla") == 0 then
            state:setValue("bla", 1)
            -- 1 = concrete value
             -- 42 = actual value
            return 1, 42
        else
            -- 1 = concrete value
            -- 13 = actual value
            return 1, 13
        end
    end
    
    -- 0 = do not intercept
    -- 0 = not used
    return 0, 0
end

