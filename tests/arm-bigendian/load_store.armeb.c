/* This is a simple long program, with an annotation modifying its
 * workflow by overwriting the pc.
 */


// baremetal entry point
void _start() __attribute__((naked));

int sum(int, int);
extern void s2e_kill_state(int status, const char* message);

__attribute__((__naked__)) static int test_load_int32(void)
{
    asm(
      "ldr r0, test_int32_const    \n"
      "mov r1,     #0xde000000   \n"
      "orr r1, r1, #0x00ad0000    \n"
      "orr r1, r1, #0x0000be00    \n"
      "orr r1, r1, #0x000000ef    \n"
      "cmp r0, r1            \n"
      "moveq r0, #1          \n"
      "movne r0, #0          \n"
      "bx  lr                \n"
      "test_int32_const:     \n"
      ".long 0xdeadbeef   \n");
    
    /* Not used, just to satisfy compiler */
    return 0;
}

__attribute__((__naked__)) static int test_load_int16(void)
{
    asm(
      "ldrh r0, test_int16_const    \n"
      "mov     r1, #0x0000be00    \n"
      "orr r1, r1, #0x000000ef    \n"
      "cmp r0, r1            \n"
      "moveq r0, #1          \n"
      "movne r0, #0          \n"
      "bx  lr                \n"
      "test_int16_const:     \n"
      ".short 0xbeef   \n");
    
    /* Not used, just to satisfy compiler */
    return 0;
}

__attribute__((__naked__)) static int test_load_int8(void)
{
    asm(
      "ldrb r0, test_int8_const    \n"
      "mov r1, #0x42         \n"
      "cmp r0, r1            \n"
      "moveq r0, #1          \n"
      "movne r0, #0          \n"
      "bx  lr                \n"
      "test_int8_const:     \n"
      ".byte 0x42   \n");
    
    /* Not used, just to satisfy compiler */
    return 0;
}

__attribute__((__naked__)) static int test_load_be8(void)
{
    asm(
      /* Test if bytes are really loaded big-endian */
      "ldr r0, test_be8_const    \n"
      "mov r1,     #0xde000000   \n"
      "orr r1, r1, #0x00ad0000    \n"
      "orr r1, r1, #0x0000be00    \n"
      "orr r1, r1, #0x000000ef    \n"
      "cmp r0, r1            \n"
      "movne r0, #0          \n"
      "bxne  lr              \n"
      /* Test that half-word offset is ok according to be8 */
      "lsr r1, #16           \n"
      "ldrh r0, test_be8_const  \n"
      "cmp r0, r1            \n"
      "movne r0, #0          \n"
      "bxne  lr              \n"
      /* Test that byte offset is ok according to be8 */   
      "lsr r1, #8            \n"
      "ldrb r0, test_be8_const  \n"
      "cmp r0, r1            \n"
      "movne r0, #0          \n"
      "bxne  lr              \n"
      /* Done, everything is ok */
      "mov r0, #1          \n"
      "bx  lr                \n"
      "test_be8_const:     \n"
      ".byte 0xde, 0xad, 0xbe, 0xef   \n");
    
    /* Not used, just to satisfy compiler */
    return 0;
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
  
  if (test_load_int32())
      s2e_message("OK: 32-bit constant load test passed");
  else
      s2e_message("ERROR: 32-bit constant load test failed");
  
  if (test_load_int16())
      s2e_message("OK: 16-bit constant load test passed");
  else
      s2e_message("ERROR: 16-bit constant load test failed");
  
  if (test_load_int8())
      s2e_message("OK: 8-bit constant load test passed");
  else
      s2e_message("ERROR: 8-bit constant load test failed");
  
  if (test_load_be8())
      s2e_message("OK: BE8 load test passed");
  else
      s2e_message("ERROR: BE8 load test failed");
  
  
  s2e_kill_state(0, "Done");
  
  while (1);
}
