require 'aruba/cucumber'

Before do
    if ENV.key?('S2E')
        @s2e_cmd = ENV['S2E']
    else
        @s2e_cmd = ENV['HOME']+'/build/build/qemu-debug/arm-s2e-softmmu/qemu-system-arm'
    end
    @dirs = ["."]
    @aruba_timeout_seconds = 30
end
