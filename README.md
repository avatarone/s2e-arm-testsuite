# Testuite for S2E ARM port #

This repository contains the acceptance test-suite for the [ARM port 
of S2E](https://github.com/dslab-epfl/s2e/).

Running tests
---------------

Tests contains mini-firmwares written in C or ASM for ARM 
architecture (both thumb and arm modes); in order to compile them 
you need an ARM cross-compiler. We currently use and suggest the 
```gcc-4.7-arm-none-eabi``` available from
[linaro](https://launchpad.net/gcc-arm-embedded/4.7/4.7-2013-q1-update).

We use Cucumber and Aruba as test-runners, so you need to install them 
before starting the checks:

> sudo apt-get install cucumber ruby-aruba
>
> make all
