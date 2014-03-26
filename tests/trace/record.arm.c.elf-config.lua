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
  "MemoryTracer",
  "ModuleExecutionDetector",
  "ExecutionTracer",
  "RawMonitor",
}

pluginsConfig = {
	MemoryInterceptor = {
		verbose = false
	},
	MemoryInterceptorAnnotation = {
		verbose = true,
		interceptors = {
			first_interceptor = {
				address = 0x10000,
				size = 4,
				access_type = {"read", "concrete_address", "concrete_value"},
				read_handler = "ann_read_intercept"
			},
			second_interceptor = {
				address = 0x10010,
				size = 2,
				access_type = {"read", "concrete_address", "concrete_value"},
				read_handler = "ann_read_intercept"
			},
			third_interceptor = {
				address = 0x10020,
				size = 1,
				access_type = {"read", "concrete_address", "concrete_value"},
				read_handler = "ann_read_intercept"
			}
		}
	},
	MemoryTracer = {
		monitorMemory = true,
		manualTrigger = false,
		timeTrigger = false,
	},
	ModuleExecutionDetector = {
		trackAllModules = true,
		configureAllModules = true,
		ram_module = {
			moduleName = "ram_module",
			kernelMode = true,
		},
	},
	RawMonitor = {
		kernelStart = 0,
		-- we consider RAM
		ram_module = {
			delay      = false,
			name       = "ram_module",
			start      = 0x00000000,
			size       = 0xffffffff,
			nativebase = 0x00000000,
			kernelmode = false
		},
	}
}

function ann_read_intercept(plg, state, address, size, is_io, is_code)
	io.write(string.format("address = 0x%x, size = 0x%x, is_io = %s, is_code = %s\n", address, size, tostring(is_io), tostring(is_code)))
	if address == 0x10000 and size == 4 then
		-- 1 = concrete value
		-- x = actual value
		return 1, 0xdeadbeef
	end
	if address == 0x10010 and size == 2 then
		-- 1 = concrete value
		-- x = actual value
		return 1, 0xbabe
	end
	if address == 0x10020 and size == 1 then
		-- 1 = concrete value
		-- x = actual value
		return 1, 0x13
	end
	return 0, 0
end
