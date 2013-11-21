.global _start
.text
.arm

.set stackstart, 	0x6000

/* Init, this is at 0x10000 */
_start:
	mov sp, #stackstart
  mov r0, #0
  mov r12, #1
 
  bl fn1
  mov r12, #2
  bl fn2
  mov r12, #3
  bl fn3
  mov r12, #4
  bl fn4
  b _exit
  
/* 0x1002c */
fn1:
	stmfd sp!,{r14}
	add r0, r0, #1
  ldmfd sp!,{r15}

fn2:
	stmfd sp!,{lr}
	add r0, r0, #2
  ldmfd sp!,{pc}

fn3:
	stmfd sp!,{lr}
	add r0, r0, #3
  ldmfd sp!,{pc}

fn4:
	stmfd sp!,{lr}
	add r0, r0, #4
  bl nested_fn5
  ldmfd sp!,{pc}

nested_fn5:
	stmfd sp!,{lr}
	add r0, r0, #5
  ldmfd sp!,{pc}
  
_exit:
	adr r1, testok
	bl s2e_kill_state

.align 2
modname:             .asciz "TestModule"
.align 2
testok:             .asciz "Test OK!"
.end
