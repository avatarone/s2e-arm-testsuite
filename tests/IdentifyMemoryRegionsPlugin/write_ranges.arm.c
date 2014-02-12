/* This is a simple long program, with an annotation modifying its
 * workflow by overwriting the pc.
 */


// baremetal entry point
void _start() __attribute__((naked));

extern void s2e_kill_state(int status, const char* message);

void timer_init(void)
{
	volatile unsigned char * timer_control_reg = (volatile unsigned char *) 0x13000008;
	//see http://infocenter.arm.com/help/topic/com.arm.doc.dui0159b/DUI0159B_integratorcp_1_0_ug.pdf
	//timer enabled, free running, no interrupts, no prescale, 32 bit size, wrapping mode
	*timer_control_reg = (1 << 7) | (0 << 6) | (0 << 5) | (0b00 << 2) | (1 << 1) | (0 << 0);  
}

void recurse(int val)
{
	if (val > 10)
		return;
	else
		recurse(val + 1);
}

unsigned long timer_read(void)
{
	return *((volatile unsigned long *) 0x13000004);
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

  
  volatile unsigned* a = (volatile unsigned int *) 0x10000;
  volatile unsigned short * b = (volatile unsigned short *) 0x10090;
  volatile unsigned char * c = (volatile unsigned char *) 0x10045;
  
  //Use some variables, a,c readonly, b read-write 
  volatile unsigned x = *a;
  unsigned i;
  x = *b;
  x = *c;
  x = *a;
  *b = 42;
  
  //Use a bit of stack
  recurse(0);
  
  //Access an IO device
  timer_init();
  x = timer_read();
  
  for (i = 0; i < 10000; i++);
  
  x = timer_read();
  x = timer_read();
  x = timer_read();
  x = timer_read();
  
  s2e_kill_state(0, "OK: Terminated");
  while (1);
}
