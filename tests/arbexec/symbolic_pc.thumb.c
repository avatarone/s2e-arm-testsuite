#define RELOCATION 0x10000

// baremetal entry point
void _start() __attribute__((naked));
void jump_to(void (*pc)());

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

  
  register void (* landing)(void) = &s2e_kill_state + RELOCATION;
  jump_to(landing);

  s2e_kill_state(0, "");

}

void jump_to(void (*pc)(void)) {
  (*pc)();
}
