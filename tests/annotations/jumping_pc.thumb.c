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
#endif
    
  int s = 0;

  int a=5, b=6, c=7, d=8, e=42, i=0;
  
  s=b+a;
  
  s++;
  
  
  for (i=0;i<=e;i++)
  s += i;
  
  c--;
  s -= c;
  
  s=16;
  
  s2e_kill_state(s, "Normal exit");

  d -= a;
  s *= d;

  s=1;
  s2e_kill_state(s, "Jump exit");

}
