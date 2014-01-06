/* This is a simple long program, with an annotation modifying its
 * workflow by overwriting the pc.
 */


// baremetal entry point
void _start() __attribute__((naked));

typedef unsigned long long uint64_t;

extern void s2e_kill_state(int status, const char* message);
extern void s2e_enable_symbolic();
extern void s2e_make_symbolic(void * address, unsigned size, const char* name);
extern uint64_t s2e_get_example(void* address, unsigned size);
extern void s2e_message(const char* msg);

void check_symbolic()
{
  unsigned long x = 0;
  
  s2e_enable_symbolic();

  //Make memory value symbolic and load it in a register
  s2e_make_symbolic(&x, sizeof(x), "symbolic_test");
  
  if (x < 42)
  {
	  uint64_t sample = s2e_get_example(&x, sizeof(x));
	  if (sample < 42)
	  {
	  	  s2e_kill_state(0, "OK: sample < 42");
	  }
	  else
	  {
	  	s2e_kill_state(0, "ERROR: not sample < 42");
	  }
  	   
  }
  else
  {
  	  uint64_t sample = s2e_get_example(&x, sizeof(x));
	  if (sample >= 42)
	  {
	  	  s2e_kill_state(0, "OK: sample >= 42");
	  }
	  else
	  {
	  	s2e_kill_state(0, "ERROR: not sample >= 42");
	  }
  }
}


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
  
  
  check_symbolic();
  
  while (1);
}
