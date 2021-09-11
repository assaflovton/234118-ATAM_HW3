.global hook
.extern _start

.section .data
msg: .ascii "This code was hacked by Noa Killa's gang\n"
endmsg:

.section .text
hook:
   #first, we want to inject the code for printing the msg
   #in the nop area
   mov $the_injected_code,%rax  #our code
   mov $_start+30,%rdx   # the first nop
   mov $0x8,%rcx     #number of nops in a.o
   loop_inject_to_nop:
	movb (%rax),%sil
	movb %sil,(%rdx)
	inc %rax
	inc %rdx
	loopq loop_inject_to_nop

   #now push the function to print noa_kirel_msg and start a.o
   pushq $print_our_msg
   jmp _start
   #start ends the program for us
   print_our_msg:
	 push %r11
	 push %r10
	 push %r9
	 push %r8
	 push %rcx
	 push %rdx
	 push %rsi
	 push %rdi
	 push %rax 
	 movq $msg, %rsi
	 movq $endmsg , %rdx
	 movq $0x1, %rax
	 movq $0x1, %rdi
	 subq %rsi , %rdx #endmsg-msg=len
	 syscall
	 pop %rax
	 pop %rdi
	 pop %rsi
	 pop %rdx
	 pop %rcx
	 pop %r8
	 pop %r9
	 pop %r10
	 pop %r11
	 ret

   the_injected_code:
   	pop %rax
	call *%rax
	nop
	nop
	nop
	nop
	nop
	nop
	nop

