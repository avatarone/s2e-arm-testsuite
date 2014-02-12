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
  "Initializer",
  "RemoteMemory"
}

pluginsConfig = {
  MemoryInterceptor = {
      verbose = false
  },
  RemoteMemory = {
      verbose = true,
      listen = "127.0.0.1:5555",
      ranges = {
          test_io = {
              address = 0x00020000,
              size = 0x0000FFFF,
              access = {"read", "write", "execute"}
          }
      }
  }
}

