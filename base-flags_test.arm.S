@filename hello.S
.global _start
.text
.arm
/***********************************************************************************
section: a range of address with no gaps.
main sections: text, data, bss.
other: absolute, undefined

text section: contains instructions, constants, ...
data section: similar to text, but alterable.
bss section: hold uninitialized variables, common storage,
absolute section: is unrelocable (address 0 of this section maps to runtime address 0.)

run as with the following option:
-mcpu=arm926e
-march=armv5te

 
************************************************************************************/
.equ testvar, 10 @just for fun
.set stackstart, 	0x7000
.set symbstart,  	0x8000
.set memstart,		0x40000
.set testvalue, 	0xDE

/* Init */
_start:
	mov r0, #0
	mov sp, #stackstart

        bl test_flags
	b _exit

test_flags:
	stmfd sp!,{r14}

/* set all flags to 1 (0xF) */
	msr cpsr_f, 0xF0000000
	mov r2, #0xF0000000
	mrs r0, cpsr
	bl print_status

/* set all flags to 0 (0x0)  */
	msr cpsr_f, 0x00000000
	mov r2, #0x00000000
	mrs r0, cpsr
	bl print_status

/* set C=1 (0x2) */
	mov r2, #0x20000000
	mov r0, #3
	lsrs r0, #1	
	mrs r0, cpsr
	bl print_status

/* set Z=1 (0x4) */
	mov r2, #0x40000000
	mov r0, #0
	teq r0, r0, LSR #1	
	mrs r0, cpsr
	bl print_status

/* set Z=1,C=1 (0x6) */
	mov r2, #0x60000000
	mov r0, #0
	mov r1, #1
	teq r0, r1, LSR #1 
	mrs r0, cpsr
	bl print_status

/* set N=1 (0x8)*/
	mov r2, #0x80000000
	mov r0, #0
        subs r0, #1
	mrs r0, cpsr
	bl print_status

	ldmfd sp!,{r15}

@input[r0]: value to check
print_status:
	stmfd sp!,{r14}
	mov r1, #0xF0000000 @flags mask
	and r0, r0, r1
	adr r1, flagtest
	bl s2e_print_expression
	cmp r0, r2
	bne _test_error
	msr cpsr_f, 0x00000000
	ldmfd sp!,{r15}

_idle:
	nop
	b _idle

_test_error:
	mov r0, r2
	adr r1, testerror
	bl s2e_kill_state

_exit:
	mov r0, #0
	adr r1, testok
	bl s2e_kill_state

.align 2
flagtest:	.asciz "Flagtest: "
.align 2
testerror:	.asciz "Test ERROR!"
.align 2
testok:		.asciz "Test OK!"
.end
