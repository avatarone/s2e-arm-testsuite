/* This is a simple long program, with an annotation modifying its
 * workflow by overwriting the pc.
 */

#include "s2e_arm_base_instructions.h"


// baremetal entry point
void _start() __attribute__((naked));

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
  
  unsigned long result;
  unsigned long *address = (unsigned long *) 0x2000;
  
  *address = 0x42;
  
  s2e_enable_forking();
  s2e_enable_symbolic();
  s2e_make_concolic((unsigned char *)address, sizeof(unsigned long), "blubb");
  
  asm volatile
  (
	  "mov r1, #0x2000       \n"
	  "ldr r0, [r1]          \n"	//r0 now contains concolic value loaded from *0x2000
	  "add r0, #0x42         \n"
	  "cmp r0, #0x70         \n"
	  "movhi %[result], #1   \n"
	  "movls %[result], #0   \n" : [result] "=r" (result)
  );
  
  if (result == 0)
  	s2e_kill_state(0, "Bad result");
  else
	s2e_kill_state(1, "Good result");
  while (1);
}
