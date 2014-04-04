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
  
  //Just do some stupid stuff
  asm volatile
  (
	  "mov r1, #0x2000        \n"
	  "mov r2, #0x4000        \n"
	  "ldr r3, [r1]           \n"
	  "str r3, [r2]           \n"
	  "mov r0, #0             \n"
	  "adr r1, str_done       \n"
	  "bl s2e_kill_state      \n"
	  "str_done:              \n"
	  ".ascii \"OK: Terminated\\0\"     \n"	
  );
		  
  while (1);
}
