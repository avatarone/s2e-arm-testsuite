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

  volatile unsigned* a = (volatile unsigned int *) 0x10000;
  volatile unsigned short * b = (volatile unsigned short *) 0x10010;
  volatile unsigned char * c = (volatile unsigned char *) 0x10020;
  
  
  unsigned tmp;
  
  tmp = *a;
  if (tmp != 0xdeadbeef)
      s2e_kill_state(1, "ERROR: first read returned wrong result");   
  tmp = *b;
  if (tmp != 0xbabe)
      s2e_kill_state(2, "ERROR: second read returned wrong result");
  tmp = *c;
  if (tmp != 0x13)
      s2e_kill_state(3, "ERROR: third read returned wrong result");
  
  *a = 0xb16b00b5;
  *b = 0xcafe;
  *c = 0x42;
  
  s2e_kill_state(0, "OK: Terminated");
  while (1);
}
