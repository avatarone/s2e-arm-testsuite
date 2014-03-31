Given /^current test directory at "(.*?)"$/ do |dir|
    cd(dir)
	@test_dir = dir
end

Given /^S2E binary at "(.*?)"$/ do |cmd|
    @s2e_cmd = cmd
    check_file_presence([@s2e_cmd], true)
end

Given(/^S2E config file named "(.*?)"$/) do |cfg|
    @luacfg = cfg
    check_file_presence([@luacfg], true)
end

Given(/^ARM firmware named "(.*?)"$/) do |fw|
    @bin = fw
    check_file_presence([@luacfg], true)
end

When /^S2E test is run$/ do
    if system "test $(uname) != \"Darwin\""
	@monitor = " -monitor /dev/null"
    else
        @monitor = ""
    end
    @cmd = @s2e_cmd + " -nographic -M integratorcp -cpu cortex-a8 -m 4M -s2e-config-file " + @luacfg + " -s2e-verbose -kernel " + @bin + @monitor
    run(unescape(@cmd), @aruba_timeout_seconds)
end

When(/^S2E test is run for architecture "(.*?)"$/) do |arch|
    if system "test $(uname) != \"Darwin\""
	@monitor = " -monitor /dev/null"
    else
        @monitor = ""
    end
    @s2e_dir = File.dirname(File.dirname(@s2e_cmd))
    @s2e_arch_cmd = File.join(@s2e_dir, arch + "-s2e-softmmu", "qemu-system-" + arch)
    @cmd = @s2e_arch_cmd + " -nographic -M integratorcp -cpu cortex-a8 -m 4M -s2e-config-file " + @luacfg + " -s2e-verbose -kernel " + @bin + @monitor
    run(unescape(@cmd), @aruba_timeout_seconds)
end

When(/^test program "(.*?)" is run after ([0-9]+?) seconds$/) do |cmd, time|
    @waittime = time
    @shellcmd = cmd
   
    sleep(@waittime.to_i()) 
    run(unescape(@shellcmd), @aruba_timeout_seconds)
end

Then(/^then trace "(.*?)" should contain the same memory accesses as the trace "(.*?)"$/) do |first_file, second_file|
	check_file_presence([first_file], true)
	check_file_presence([second_file], true)

	traceentry_to_string_file = "../memtrace/DisplayMemoryEntries.py"
	first_file_dat_path = @test_dir + "/" + first_file
	second_file_dat_path = @test_dir + "/" + second_file
	first_file_txt_path = first_file_dat_path + "-text"
	second_file_txt_path = second_file_dat_path + "-text"

	assert_success(system("python " + " " + traceentry_to_string_file + " " + first_file_dat_path + " > " + first_file_txt_path))
	assert_success(system("python " + " " + traceentry_to_string_file + " " + second_file_dat_path + " > " + second_file_txt_path))
	assert_success(system("diff " + second_file_txt_path + " " + first_file_txt_path))
end

Then(/^then trace "(.*?)" should contain all the memory accesses from trace "(.*?)"$/) do |first_file, second_file|
	check_file_presence([first_file], true)
	check_file_presence([second_file], true)

	traceentry_to_string_file = "../memtrace/DisplayMemoryEntries.py"
	first_file_dat_path = @test_dir + "/" + first_file
	second_file_dat_path = @test_dir + "/" + second_file
	first_file_txt_path = first_file_dat_path + "-text"
	second_file_txt_path = second_file_dat_path + "-text"

	assert_success(system("python " + " " + traceentry_to_string_file + " " + first_file_dat_path + " > " + first_file_txt_path))
	assert_success(system("python " + " " + traceentry_to_string_file + " " + second_file_dat_path + " > " + second_file_txt_path))

	ret = system("test 0 -eq `diff -w " + second_file_txt_path + " " + first_file_txt_path + " | grep -c -e '^<'`")
	assert_success(ret)
end
