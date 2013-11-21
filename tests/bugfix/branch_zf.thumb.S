.global _start
.text

.set stackstart, 	0xFF 

/* Init, this is at 0x10000 */
.arm
_start:
    adr r0, _main + 1 
    bx r0

_exit:
    .word 0xFF060000

.thumb
_main:
    mov r1, #stackstart
    mov sp, r1
    mov r0, #0
    cmp r0, #0
    bne test1
    beq test2
  
test1:
    mov r0, #1
    ldr r1, =_exit + 0x10000
    bx r1
    
test2:
    mov r0, #2
    ldr r1, =_exit + 0x10000
    bx r1

