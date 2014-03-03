.global _start
.text

.set stackstart, 0xFF

.arm
/* this is at 0x10000 */
_start:
	b _main

_exit:
	.word   0xFF060000


_main:
	mov r1, #stackstart
	mov sp, r1
	mov r0, #0
	mov r1, #0
	b test_cases

test_cases:
	bl s2e_enable_forking
	bl test_flag_Z_symbolic
	mov r0, #10
	b _exit

test_flag_Z_symbolic:

	movs r1, #0x0
	/* zero flag should be one,
	   mark it symbolic, the next conditional instruction should trigger
	   a state spawning
	 */
	nop
	beq __flag_Z_set
	mov r0, #1
	b _exit
__flag_Z_set:
	# normal execution
	# return from function and continue
	mov pc, lr
