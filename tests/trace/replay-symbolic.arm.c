void _start() __attribute__((naked));

extern void s2e_kill_state(int status, const char* message);
extern void s2e_print_expression(int expr, const char * msg);

void _start() {

	asm volatile
		(
		 "mov sp, #0x1000       \n\t"
		 "beq .+4\n\t" /* annotation doesn't work on the first basic block */
		 "nop \n\t"
		 "nop \n\t"
		 "nop \n\t"
		 "nop \n\t"
		);

	volatile unsigned* a = (volatile unsigned int *) 0x10000;
	volatile unsigned short * b = (volatile unsigned short *) 0x10010;
	volatile unsigned char * c = (volatile unsigned char *) 0x10020;
	unsigned tmp;
	unsigned symb_tmp;

	tmp = *a;
	symb_tmp = tmp * 0x20;
	s2e_print_expression(symb_tmp, "first_var");
	if (tmp != 0xdeadbeef)
		s2e_kill_state(1, "ERROR: first read returned wrong result");

	tmp = *b;
	symb_tmp = tmp+0x20;
	symb_tmp++;
	s2e_print_expression(symb_tmp, "second_var");
	if (tmp != 0xbabe)
		s2e_kill_state(2, "ERROR: second read returned wrong result");

	tmp = *c;
	symb_tmp = tmp+0x20;
	s2e_print_expression(symb_tmp, "third_var_not_zero");
	symb_tmp = 0x0;
	s2e_print_expression(symb_tmp, "third_var_zero");
	if (tmp != 0x13)
		s2e_kill_state(3, "ERROR: third read returned wrong result");

	s2e_kill_state(0, "OK: Terminated");
	while (1);
}
