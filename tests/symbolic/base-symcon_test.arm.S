.global _start
.text
.arm

.set stackstart, 	0x6000
.set symbstart,  	0x8000
.set exitval,     0xFF

/* Init */
_start:
	mov sp, #stackstart
	mov r8, #symbstart

/* Check conditional move */
symcon_main:
  bl symbolic_int
  mov r0, #0
  ldr r7, [r8]              @get the symbolic value
  cmp r7, #exitval
  movne r0, r7              @should fork into 2 states...
	adr r1, testok
	bl s2e_kill_state         @...exiting with different values

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

.align 2
testok:             .asciz "Test OK! Check exit values."
.align 2
symarea:		        .asciz "Symbolic area"
.align 2
symname:		        .asciz "Symbolic integer"
.end
