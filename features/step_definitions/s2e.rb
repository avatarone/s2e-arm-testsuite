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
    @cmd = @s2e_cmd + " -M integratorcp -cpu cortex-a8 -m 4M -s2e-config-file " + @luacfg + " -s2e-verbose -kernel " + @bin
    run_simple(unescape(@cmd), false)
end
