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
  
  int result;
  
  asm volatile
  (
	  "cmp   r0, #0x30        \n"
	  "cmpeq r1, #0x31        \n"
	  "cmpeq r2, #0x32        \n"
	  "cmpeq r3, #0x33        \n"
	  "ldr r12, =0xdeadbeef   \n"
	  "cmpeq r4, r12          \n"
	  "ldr r12, =0xcafebabe   \n"
	  "cmpeq r5, r12          \n"
	  "ldr r12, =0xb19b00b5   \n"
	  "cmpeq r6, r12          \n"
	  "movne %[result], #1    \n"
	  "bne finished           \n"
	  "ldr r0, =0x1000        \n"
	  "ldr r1, =0x10000       \n"
	  "loop_start:            \n"
	  "ldr r2, [r0]           \n"
	  "cmp r2, r0             \n"
	  "movne %[result], #1    \n"
	  "bne finished           \n"
	  "add r0, r0, #4         \n"
	  "cmp r0, r1             \n"
	  "ble loop_start         \n"
	  "mov %[result], #0      \n"
	  "finished:              \n" : [result] "=r" (result)
	  
  );
  
  if (result)  {
  	  s2e_kill_state(1, "ERROR: Wrong register values");
  }
  else {
	  s2e_kill_state(0, "OK: Good values");
  }
  
  
  while (1);
}
