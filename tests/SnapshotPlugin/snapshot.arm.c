/* This is a simple long program, with an annotation modifying its
 * workflow by overwriting the pc.
 */


// baremetal entry point
void _start() __attribute__((naked));

extern void s2e_kill_state(int status, const char* message);

void _start() {
  
#ifdef __thumb__
  // switch to thumb
  asm volatile
  (
    ".code 32              \n\t"
    "mov sp, #0x1000       \n\t"
    "orr     r12, pc, #1   \n\t"
    "bx      r12           \n\t"
    ".code 16              \n\t"    
  );
#else
  asm volatile
  (
    "mov sp, #0x1000       \n\t"
  );
#endif
  
  asm volatile
  (
	  "mov r0, #0x1000       \n"
	  "mov r1, #0x10000      \n"
	"loop_start:            \n"
	  "str r0, [r0]         \n"
	  "add r0, r0, #4       \n"
	  "cmp r0, r1           \n"
	  "ble loop_start       \n"
	  "nop                  \n"
	  "nop                  \n"
	  "nop                  \n"
	  "nop                  \n"
	  "movs r0, #0          \n"
	  "beq .+4              \n"
	  "nop                  \n"
	  "nop                  \n"
	  "nop                  \n"
	  "mov r0, #0x30        \n"
	  "mov r1, #0x31        \n"
	  "mov r2, #0x32        \n"
	  "mov r3, #0x33        \n"
	  "ldr r4, =0xdeadbeef  \n"
	  "ldr r5, =0xcafebabe  \n"
	  "ldr r6, =0xb19b00b5  \n"
	  "snapshot_here:       \n"
  );
  
  s2e_kill_state(0, "Done");
  while (1);
}
