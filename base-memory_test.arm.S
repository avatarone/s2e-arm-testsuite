.global _start
.text
.arm

.set memstart,    0x04000
.set stackstart, 	0x06000

/* Init */
_start:
	mov r0, #0
	mov sp, #stackstart
	bl test_mem
	b _exit

/* ---- */ 

test_mem:
/** registers with special roles:  
 *  r4  ... contains the current address to store/check
 *  r5  ... contains path id of current path (+10)
 *  r6  ... contains ram object bits (to build pagesize)
 *  r8  ... custom stack where symbolic data is written, has to 
 *          be decremented by <sizeof(last_symvalue)> before use
 *  r9  ... contains pagesize
**/
	stmfd sp!,{r5, r14}

	bl s2e_get_ram_object_bits
	mov r2, r0
	adr r1, ram_object_bits
	bl s2e_print_expression
// This is 7 by default. Comment the test if you changed it in s2e_config.h
	cmp r2, #7
	bne _test_error
// Shift by ram_object_bits to get the size of the page (128b default)
	mov r9, #1
	mov r9, r9, lsl r2

stm1:
	bl s2e_get_path_id
  mov r5, r0
	adr r1, pathid	                  @print path ID
	bl s2e_print_expression
	add r5, #10	                      @avoid using 0 for false-positive
	mov r0, r9	                      @print pagesize (default 0x80)
	adr r1, val	                      @pagesize label
	bl s2e_print_expression
	
	mov r10, r9                       @reset counter
/* Fill page with test pattern (path id stored in r5) */
fill_pattern:
  mov r4, $memstart                 @starting memory address
	add r4, r4, r10, lsl #2
	str r5, [r4]
	sub r10, r10, #1                  @decrease counter
	cmp r10, #0
	bne fill_pattern
  
	mov r0, r5                        @print testvalue
	adr r1, testval                   @testvalue label
	bl s2e_print_expression
  
	mov r10, r9                       @reset counter
/* Check if the memory is correct */
check_pattern:
	mov r4, $memstart                 @starting memory address
	add r4, r4, r10, lsl #2
	ldr r0, [r4]
	cmp r0, r5                        @do we get the path id back?
	bne _sterr                         @if not, goto error
	sub r10, r10, #1
	cmp r10, #0
	bne check_pattern

	mov r0, r9
	adr r1, cnt	                      @memval label
	bl s2e_print_expression
  
  sub r4, #4
  mov r2, #memstart
	cmp r4, r2
  bne _test_error
	
/* Successfully completed mem test */
	mov r0, #0
	adr r1, memok
	bl s2e_kill_state
	ldmfd sp!,{r5, r15}

_exit:
	mov r0, #0
	adr r1, memok
	bl s2e_kill_state

_test_error:
	mov r0, r2
	adr r1, testerror
	bl s2e_kill_state

_sterr:
	adr r1, membadval
	bl s2e_print_expression
	mov r0, r5
	adr r1, membad
	bl s2e_kill_state


.align 2
val:		          .asciz "Pagesize"
.align 2
testval:          .asciz "Testvalue used:"
.align 2
membad: 	        .asciz "Memory ERROR! Expected value below..."
.align 2
membadval: 	      .asciz "Reading returned a bad value"
.align 2
cnt:		          .asciz "MemCheck iterations"
.align 2
pathid:		        .asciz "Path ID:"
.align 2
ram_object_bits:  .asciz "S2E_RAM_OBJECT_BITS:"
.align 2
memok:		        .asciz "Test OK!"
.align 2
testerror:	      .asciz "Test ERROR! Expected value below..."
.end
