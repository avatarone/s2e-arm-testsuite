@filename hello.S
.global _start
.text
.arm

.set stackstart, 	0x7000

/* Init */
_start:
	mov sp, #stackstart
	
	mov r0, #0
	bl s2e_disable_symbolic
	bl s2e_enable_symbolic
	bl s2e_disable_forking
	bl s2e_enable_forking
	adr r0, msg
	bl s2e_message
	bl s2e_version
	mov r0, #0
	adr r1,testok
	bl s2e_kill_state

.align 2
msg:		.asciz "Hello (S2E) world!"

.align 2
testok:		.asciz "Test OK!"
