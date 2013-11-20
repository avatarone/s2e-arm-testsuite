.text
.global _start
.set stackstart, 	0x1000

_start:

/* Init */
  mov r0, #0
  mov sp, #stackstart

/* Enable forking */
  bl s2e_enable_forking

/* Make value symbolic */
  adr r0, symbolic_buffer
  mov r1, #4
  adr r2, str_buffer_name
  bl s2e_make_symbolic

  ldr r0, symbolic_buffer
  cmp r0, #0
  beq eq_zero

  /* Kill this state */
  mov r0, #1
  adr r1, str_kill_neq_zero 
  bl s2e_kill_state

eq_zero:
  /* And also kill this state */
  mov r0, #0
  adr r1, str_kill_eq_zero
  bl s2e_kill_state

.align 2
symbolic_buffer:
  .long 0

.align 2
str_buffer_name:
    .ascii "symbolic value\0"
.align 2
str_kill_neq_zero:
    .ascii "Not equal zero\0"
.align 2
str_kill_eq_zero:
    .ascii "Equal zero\0"

