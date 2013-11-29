.global _start
.text
.arm

.set stackstart,    0x6000

/* Init, this is at 0x10000 */
_start:
MVN     R1, #0x44000
ADD     R1, R1, #1
MOV     R0, #0
//STR   R0, [R1,#4]
MVN     R1, #0xAE000
ADD     R1, R1, #1
MOV     R0, #0x20000000
orr     R0, R0, R2

/* Let's die, right now */
mov     pc,#0x20000000

/* .word 0xFF060000 */
