/* This is a simple long program, with an annotation modifying its
 * workflow by overwriting the pc.
 */


// baremetal entry point
void _start() __attribute__((naked));

int sum(int, int);
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

  volatile unsigned* a = (unsigned int *) 0x900;
  volatile unsigned* b = (unsigned int *) 0x904;
  
  *a = 42;
  
  if (*a != 13 || *b != 42)
  {
     s2e_kill_state(1, "ERROR: no values for address 0x900 injected");
  }
  else
  { 
    s2e_kill_state(0, "OK: Values 13 and 42 were read after write");
  }
  
  while (1);
}
