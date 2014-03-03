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
	bl test_flag_Z_change
	mov r0, #10
	b _exit

test_flag_Z_change:
	movs r1, #0x0
	nop /* set Z flag to 0 here */
	beq __should_not_reach
	mov pc, lr

	# normal execution
	# return from function and continue
__should_not_reach:
	mov r0, #3
	b _exit

