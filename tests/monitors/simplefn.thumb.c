// baremetal entry point
void _start() __attribute__((naked));
int sum(int, int);

extern void s2e_kill_state(int status, const char* message);

void _start() {
  
  asm volatile
  (
    ".code 32              \n\t"
    "mov sp, #0x1000       \n\t"
    "orr     r12, pc, #1   \n\t"
    "bx      r12           \n\t"
    ".code 16              \n\t"    
  );

  register int op1 = 4;
  register int op2 = 5;
  register int s = sum(op1,op2);

  s = (s == 1 ? 2 : 9);

  s2e_kill_state(s, "Sum result");

}

int sum(int a, int b) {
  register int s = a+b;
  return s;
}
