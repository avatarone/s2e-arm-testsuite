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
  
  asm volatile
  (
	  /* Setup and create concolic value */
	  "bl s2e_disable_forking  \n"
	  "bl s2e_enable_symbolic  \n"
	  "mov r0, #0x2000       \n"
	  "mov r1, #0x42         \n"
	  "str r1, [r0]          \n"
	  "mov r0, #0x2000       \n"
	  "mov r1, #4            \n"
	  "adr r2, str_blubb     \n"
	  "bl s2e_make_concolic  \n"
	  /* Print concolic value to check that it is there */
	  "mov r1, #0x2000       \n"
	  "ldr r0, [r1]          \n"	//r0 now contains concolic value loaded from *0x2000
	  "adr r1, str_should_be_symbolic \n"
	  "bl s2e_print_expression  \n"
	  "bl s2e_message           \n"
	  /* Overwrite concolic value with concrete value and print again */
	  "mov r12, r0             \n"
	  "mov r0, #0x29           \n"
	  "adr r1, str_should_be_zero \n"
	  "bl s2e_print_expression  \n"
	  /* Done */
	  "mov r0, #0            \n"
	  "adr r1, str_done      \n"
	  "bl s2e_kill_state     \n"
	  "str_should_be_zero: .ascii \"should_be_zero\\0\" \n"
	  "str_should_be_symbolic: .ascii \"should_be_symbolic\\0\" \n"
	  "str_blubb: .ascii \"blubb\\0\"  \n"
	  "str_done: .ascii \"done\\0\"  \n"
  );

  while (1);
}
