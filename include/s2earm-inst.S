@filename s2earm-inst.S
.text
.arm

.type s2e_version, %function
.global s2e_version
@returns version in r0
s2e_version:
    stmfd sp!,{r14}
    .word 0xFF000000
    ldmfd sp!,{r15}

.type s2e_enable_symbolic, %function
.global s2e_enable_symbolic
s2e_enable_symbolic:
    stmfd sp!,{r14}
    .word 0xFF010000
    ldmfd sp!,{r15}

.type s2e_disable_symbolic, %function
.global s2e_disable_symbolic
s2e_disable_symbolic:
    stmfd sp!,{r14}
    .word 0xFF020000
    ldmfd sp!,{r15}

.type s2e_make_symbolic, %function
.global s2e_make_symbolic
@requires r0: address
@requires r1: size
@requires r2: address to symbolic name
s2e_make_symbolic:
    stmfd sp!,{r14}
    .word 0xFF030000
    ldmfd sp!,{r15}

.type s2e_get_path_id, %function
.global s2e_get_path_id
@returns path id to r0
s2e_get_path_id:
    stmfd sp!,{r14}
    .word 0xFF050000
    ldmfd sp!,{r15}

.type s2e_kill_state, %function
.global s2e_kill_state
@requires r0: status code number
@requires r1: address to kill message
s2e_kill_state:
    stmfd sp!,{r14}
    .word 0xFF060000
    ldmfd sp!,{r15}

.type s2e_print_expression, %function
.global s2e_print_expression
@requires r0: expression number
@requires r2: address to symbolic name
s2e_print_expression:
    stmfd sp!,{r14}
    .word 0xFF070000
    ldmfd sp!,{r15}

.type s2e_print_memory, %function
.global s2e_print_memory
@requires r0: address
@requires r1: size
@requires r2: address to (your abitrary) name of this memory region
s2e_print_memory:
    stmfd sp!,{r14}
    .word 0xFF080000
    ldmfd sp!,{r15}

.type s2e_enable_forking, %function
.global s2e_enable_forking
s2e_enable_forking:
    stmfd sp!,{r14}
    .word 0xFF090000
    ldmfd sp!,{r15}

.type s2e_disable_forking, %function
.global s2e_disable_forking
s2e_disable_forking:
    stmfd sp!,{r14}
    .word 0xFF0A0000
    ldmfd sp!,{r15}

.type s2e_message, %function
.global s2e_message
@requires r0 to point to the address with the string to be printed
s2e_message:
    stmfd sp!,{r14}
    .word 0xFF100000
    ldmfd sp!,{r15}
	
.type s2e_make_concolic, %function
.global s2e_make_concolic
@requires r0 The address of the memory that will be made concolic
@requires r1 Size of the concolic expression
@requires r2 Pointer to name of concolic expression
s2e_make_concolic:
    .word 0xFF110000
	bx lr

.type s2e_concretize, %function
.global s2e_concretize
@requires r0: address
@requires r1: size
s2e_concretize:
    stmfd sp!,{r14}
    .word 0xFF200000
    ldmfd sp!,{r15}

.type s2e_get_example, %function
.global s2e_get_example
@requires r0: address
@requires r1: size
s2e_get_example:
    stmfd sp!,{r14}
    .word 0xFF210000
    ldmfd sp!,{r15}

.type s2e_sleep, %function
.global s2e_sleep
@requires r0: duration
s2e_sleep:
    stmfd sp!,{r14}
    .word 0xFF320000
    ldmfd sp!,{r15}

.type s2e_get_ram_object_bits, %function
.global s2e_get_ram_object_bits
s2e_get_ram_object_bits:
    stmfd sp!,{r14}
    .word 0xFF520000
    ldmfd sp!,{r15}

.type s2e_merge_point, %function
.global s2e_merge_point
s2e_merge_point:
    stmfd sp!,{r14}
    .word 0xFF700000
    ldmfd sp!,{r15}

.type s2e_rawmon_loadmodule, %function
.global s2e_rawmon_loadmodule
@requires r0: module name
@requires r1: loadbase
@requires r2: size
s2e_rawmon_loadmodule:
    stmfd sp!,{r14}
    .word 0xFFAA0000
    ldmfd sp!,{r15}
