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
    ldr     r1, =test_case + 0x10000 + 1
    bx      r1

end_test:
    mov     r0, r7
    ldr     r1, =_exit + 0x10000
    bx      r1


test_case:
/* 0x0001001e - Test case starts here... */

    mov     r2, #2
    mov     r3, #0xFF
    mov     r6, #6
    mov     r7, #1
    cmp     r0, #0x18
    blt     end_test
    cmp     r0, #0x42
    bge     end_test
    cmp     r2, #0x2
    bne     end_test
    cmp     r0, #0x19
    bne     end_test
    bx      r2

/*   ... and ends here.     */
    mov     r7, #1
    ldr     r1, =end_test + 0x10000 +1
    bx      r1
    
