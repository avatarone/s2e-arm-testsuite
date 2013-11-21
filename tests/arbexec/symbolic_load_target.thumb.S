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
    mov r1, #0
    ldr r1, =test_case + 0x10000 + 1
    bx r1

end_test:
    mov r0, #1
    ldr r1, =_exit + 0x10000
    bx r1


test_case:
/* 0x0001001e - Test case starts here... */

   mov      R2, #0
   MOV      R1, #0
   ldr      r7, =end_test + 0x10000
   cmp      r0, #0x18
   blt      end_test
   cmp      r0, #0x42
   bge      end_test
   cmp      r2, #0x2
   bne      end_test
   LDRB     R0, [R0, #0xC]      /* symbolic load at 0x00010030 */
   cmp      r0, #0x19
   bne      end_test
   bx r2

/*   ... and ends here.     */
    ldr r1, =end_test + 0x10000 +1
    bx r1
    
