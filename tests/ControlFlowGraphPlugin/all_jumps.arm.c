/* This is a simple long program, with an annotation modifying its
 * workflow by overwriting the pc.
 */

unsigned func1() {return 1;}
unsigned func2() {return 2;}
unsigned func3() {return 3;}

typedef unsigned (*func_ptr)();

func_ptr functions[] = {func1, func2, func3};

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
  
  volatile unsigned x;
  unsigned i;
  
  for (i = 0; i < 10; i++)
  {
  	//Normal control flow branch
  	if (i < 3)
	{
		x = 0;
	}
	
	//Indirect jump
	x = functions[i % 3]();
  }
  
  s2e_kill_state(0, "OK: Terminated");
  while (1);
}
