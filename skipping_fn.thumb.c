#define RELOCATION 0x10000

// baremetal entry point
void _start();
void change_status(int * status);

extern void s2e_kill_state(int status, const char* message);

void _start() {
  
  asm volatile
  (
    ".code 32              \n\t"
    "mov sp, #0x1000       \n\t"
    "orr     r12, pc, #1    \n\t"
    "bx      r12            \n\t"
    ".code 16              \n\t"    
  );

  int s=0x42;
  // We want to skip this via annotations
  change_status(&s);      
  s2e_kill_state(s, "");
}

void change_status(int *s) {
  *s=0xFF;
}
