.global _start
.text
.arm

.set stackstart, 	0x7000
.set symbstart,  	0x8000

/* Init */
_start:
	mov sp, #stackstart
	
// Prepare a symbolic value
  mov r8, #symbstart
  bl symbolic_int
  bl register_check
	b _exit
  
register_check:
	stmfd sp!,{r14}

// Init regs: r0-r12 concrete, r18 symbolic
	mov r0, #1
	mov r1, #2
	mov r2, #3
	mov r3, #4
	mov r4, #5
	mov r5, #6
	mov r6, #7
	mov r7, #8
	mov r9, #9
  mov r10, #10
  mov r11, #11
	ldr r12, [r8]	              @fill with the symbolic value

// symbolic comparison
  cmp r12, #0			            @will fork here
  bleq register_check_compare

// concrete comparison
  mov r12, #12
  cmp r12, #12						    @will NOT fork here
  bne unreachable             @we should NEVER branch here
  
  mov r0, #0
  adr r1, regcheck_done
  bl s2e_kill_state
  ldmfd sp!,{r15}

register_check_compare:
	stmfd sp!,{r14}
	cmp r0, #1
	bne switch_error
	cmp r1, #2
	bne switch_error
	cmp r2, #3
	bne switch_error
	cmp r3, #4
	bne switch_error
	cmp r4, #5
	bne switch_error
	cmp r5, #6
	bne switch_error
	cmp r6, #7
	bne switch_error
	cmp r7, #8
	bne switch_error
	cmp r9, #9
	bne switch_error
  cmp r10, #10
	bne switch_error
  cmp r11, #11
	bne switch_error
  mov r0, #0
  adr r1, testok
  bl s2e_kill_state
  ldmfd sp!,{r15}

/* Create a symbolic integer value */
symbolic_int:
	stmfd sp!,{r14}
	sub r8, r8, #4		        @decrement (custom symb. value 'stack')
  // create symbint
	mov r0, r8			          @address of symb. value
	mov r1, #4			          @size of symb. value = 4byte
	adr r2, symname	          @symbol name
  bl s2e_make_symbolic
  // dump symbint
  mov r0, r8
  mov r1, #4
  adr r2, symarea
  bl s2e_print_memory
  ldmfd sp!,{r15}

/* Control-flow error */
unreachable:
	mov r0, #0
	adr r1, unreach
	bl s2e_kill_state

/* Error when checking registers */
switch_error:
	mov r0, #0
	adr r1, statebad
	bl s2e_kill_state

_exit:
	mov r0, #0
	adr r1, testok
	bl s2e_kill_state

_test_error:
	mov r0, r2
	adr r1, testerror
	bl s2e_kill_state

.align 2
regcheck_done:	    .asciz "End of register_check reached"
.align 2
statebad:	          .asciz "Register check FAILED!"
.align 2
symarea:		        .asciz "Symbolic area"
.align 2
symname:		        .asciz "Symbolic integer"
.align 2
testok:	  	        .asciz "Test OK!"
.align 2
unreach:    	      .asciz "Test ERROR! Executing unreachable code!"
.align 2
testerror:  	      .asciz "Test ERROR! Expceted value below..."
.end
