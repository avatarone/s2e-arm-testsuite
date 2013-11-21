.text
.global _start
.set stackstart, 	0x1000

_start:

/* Init */
  mov r0, #0
  mov sp, #stackstart
  adr r0, str_msg
  bl s2e_message

  /* Sleep for 5 seconds */
  mov r0, #2
  bl s2e_sleep

  /* Kill this state */ 
  mov r0, #0
  adr r1, str_kill
  bl s2e_kill_state

.align 2
str_kill:
    .ascii "Normal exit after 2s sleep\0"

.align 2
str_msg:
   .ascii "Going to sleep for 5s\0"
    
