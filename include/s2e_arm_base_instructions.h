#ifndef _S2E_BASE_INSTRUCTIONS_H
#define _S2E_BASE_INSTRUCTIONS_H

#ifdef WITH_DEFINITIONS
#define MAKE_S2E_FUNCTION(name, code, ret, ...) \
	__asm__(".type " #name ", %function\n.global " #name "\n" #name ": \n   .long " #code "\n   bx lr\n");
#else /* WITH_DEFINITIONS */
#define MAKE_S2E_FUNCTION(name, code, ret, ...) \
	extern ret name(__VA_ARGS__);
#endif /* WITH_DEFINITIONS */
	
MAKE_S2E_FUNCTION(s2e_version, 0xFF000000, unsigned);
MAKE_S2E_FUNCTION(s2e_enable_symbolic, 0xFF010000, void);
MAKE_S2E_FUNCTION(s2e_disable_symbolic, 0xFF020000, void);
MAKE_S2E_FUNCTION(s2e_make_symbolic, 0xFF030000, void, void* address, unsigned size, const char* name);
MAKE_S2E_FUNCTION(s2e_get_path_id, 0xFF050000, unsigned);
MAKE_S2E_FUNCTION(s2e_kill_state, 0xFF060000, void);

#ifdef WITH_DEFINITIONS
	__asm__(".type s2e_print_expression, %function\n.global s2e_print_expression\n"
		"s2e_print_expression:\n   mov r2, r1\n   .long 0xFF070000\n   bx lr\n");
#else /* WITH_DEFINITIONS */
void s2e_print_expression(int expression, const char* name);
#endif /* WITH_DEFINITIONS */

MAKE_S2E_FUNCTION(s2e_print_memory, 0xFF080000, void, void* address, unsigned size, const char* name);
MAKE_S2E_FUNCTION(s2e_enable_forking, 0xFF090000, void);
MAKE_S2E_FUNCTION(s2e_disable_forking, 0xFF0A0000, void);
MAKE_S2E_FUNCTION(s2e_message, 0xFF100000, void, const char* message);
MAKE_S2E_FUNCTION(s2e_make_concolic, 0xFF110000, void, void* address, unsigned size, const char* name);
MAKE_S2E_FUNCTION(s2e_concretize, 0xFF200000, void, void* address, unsigned size);
MAKE_S2E_FUNCTION(s2e_get_example, 0xFF210000, unsigned long, void* address, unsigned size);
MAKE_S2E_FUNCTION(s2e_sleep, 0xFF320000, void, unsigned duration);
MAKE_S2E_FUNCTION(s2e_get_ram_object_bits, 0xFF520000, void);
MAKE_S2E_FUNCTION(s2e_merge_point, 0xFF700000, void);
MAKE_S2E_FUNCTION(s2e_rawmon_loadmodule, 0xFFAA0000, void, const char* module_name, void* loadbase, unsigned size);


#endif /* _S2E_BASE_INSTRUCTIONS_H */