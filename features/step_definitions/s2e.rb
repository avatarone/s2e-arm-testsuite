Given /^current test directory at "(.*?)"$/ do |dir|
    cd(dir)
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
    @cmd = @s2e_cmd + " -monitor /dev/null -nographic -M integratorcp -cpu cortex-a8 -m 4M -s2e-config-file " + @luacfg + " -s2e-verbose -kernel " + @bin
    run(unescape(@cmd), @aruba_timeout_seconds)
end

When(/^S2E test is run for architecture "(.*?)"$/) do |arch|
    @s2e_dir = File.dirname(File.dirname(@s2e_cmd))
    @s2e_arch_cmd = File.join(@s2e_dir, arch + "-s2e-softmmu", "qemu-system-" + arch)
    @cmd = @s2e_arch_cmd + " -monitor /dev/null -nographic -M integratorcp -cpu cortex-a8 -m 4M -s2e-config-file " + @luacfg + " -s2e-verbose -kernel " + @bin
    run(unescape(@cmd), @aruba_timeout_seconds)
end

When(/^test program "(.*?)" is run after ([0-9]+?) seconds$/) do |cmd, time|
    @waittime = time
    @shellcmd = cmd
   
    sleep(@waittime.to_i()) 
    run(unescape(@shellcmd), @aruba_timeout_seconds)
end
