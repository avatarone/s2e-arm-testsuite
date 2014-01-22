.global _start
.text

.set stackstart, 	0xFF 

/* Init, this is at 0x10000 */
.arm
_start:
    adr     r0, _main + 1 
    bx      r0

_exit:
    .word   0xFF060000

.thumb
_main:
    mov     r1, #stackstart
    mov     sp, r1
    mov     r0, #0
    mov     r1, #0
;    ldr     r1, =test_case + 0x10000 + 1 	/* Thumb */
    ldr     r1, =test_case + 0x10000 		/* Arm */
    bx      r1

end_test:
    mov     r0, r7
    ldr     r1, =_exit + 0x10000
    bx      r1


test_case:
/* 0x0001001e - Test case starts here... */
.arm

    mov     R0, #0x00020000
    mov     R1, #0x0A00
    ADD     R2, R0, R1
    add     r2, r2, #0x1c
    mov     R1, #0x14
loop1:
    CMP     R0, R2
    LDRCC   R3, [R1],#4
    STRCC   R3, [R0],#4
    BCC     loop1
    mov     R0, #0x00020000
    mov     R1, #0x1900
    add     r1, r1, #0x9C
    MOV     R2, #0x88
    ADD     R1, R0, R1

loop2:
    CMP     R0, R1
    STRCC   R2, [R0],#4
    BCC     loop2
         
    sub     r0, r0,#4
    mov     r7, #0x42
    ldr     r7, [r0]

/*   ... and ends here.     */
    mov     r7, r0
    ldr     r1, =end_test + 0x10000 +1
    bx      r1
    
