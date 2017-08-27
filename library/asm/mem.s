	.text

# MEMORY ROUTINES
################################################################################
# The following routines have to do with memory managment and conformity
	
	.global _transfer
	# %rax: frame size, %rbx: transfer size
_transfer:
	movq	%rdi, -8(%rsp)
_tf_lp:	movq	(%rbp, %rax, 8), %rdi
	xorq	_trf_mask(%rip), %rdi
	leaq	(%rax, %rbx, ), %r15
	leaq	(%rbp, %r15, 8), %r15
	cmpq	%r15, %rsp
	jz	_tf_en
	movq	(%r15), %r15
	movq	%r15, (%rdi)
	dec	%rax
	jmp	_tf_lp
_tf_en:	movq	-8(%rsp), %rdi
	ret

	.global _fill
	# %rbx: memory chunk, %r15: destination
_fill:
	cmpq	$0, %rbx
	jz	_f_en
_f_lp:	movq	(%rbx), %rax
	cmpq	$33, %rax
	jz	_f_en
	cmpq	%r15, %rsp
	jz	_f_en
	movq	%rax, (%r15)
	subq	$8, %rbx
	subq	$8, %r15
	jmp	_f_lp
_f_en:	ret

	.global	_varargs
	# %rax: final nargs, %r15: starting nargs
_varargs:
	movq	(%r12), %r15
	pushq	%r12
	pushq	%rax
	pushq	%r14
	subq	%r15, %rax
	negq	%rax
	jge	_va_ps
	movq	$33, (%r12)
	addq	$8, %r12
	movq	%r12, 16(%rsp)
	jmp	_va_en
_va_ps:	leaq	8(%r12, %rax, 8), %r12
	movq	8(%rsp), %rax
	movq	%r12, 16(%rsp)
	leaq	-6(%rax), %rbx
	cmpq	$0, %rbx
	jg	_va_lp
	movq	$1, %rbx
_va_lp:	cmpq	%rax, %r15
	jb	_va_en
	cmpq	$1, %rax
	jz	_va_1
	cmpq	$2, %rax
	jz	_va_2
	cmpq	$3, %rax
	jz	_va_3
	cmpq	$4, %rax
	jz	_va_4
	cmpq	$5, %rax
	jz	_va_5
	cmpq	$6, %rax
	jz	_va_6
	jmp	_va_g
_va_1:	movq	%rdi, (%r12)
	jmp	_va_cm
_va_2:	movq	%rsi, (%r12)
	jmp	_va_cm
_va_3:	movq	%rdx, (%r12)
	jmp	_va_cm
_va_4:	movq	%rcx, (%r12)
	jmp	_va_cm
_va_5:	movq	%r8, (%r12)
	jmp	_va_cm
_va_6:	movq	%r9, (%r12)
	jmp	_va_cm
_va_g:	movq	32(%rsp, %rbx, 8), %r14
	movq	%r14, (%r12)
	inc	%rbx
_va_cm:	subq	$8, %r12
	inc	%rax
	jmp	_va_lp
_va_en:	popq	%r14
	popq	%rax
	movq	$33, (%r12)
	popq	%r12
	leaq	5(, %r12, 8), %r15
	addq	$8, %r12
	ret
	
	.global	_nil_fill
	# %rax: final nargs, %r15: starting nargs
_nil_fill:
	cmpq	%rax, %r15
	jge	_nf_en
	pushq	%rax
	pushq	%rdi
	pushq	%r15
	movq	%r15, %rbx
	subq	$6, %rbx
	jge	_rs_0
	xorq	%rbx, %rbx
_rs_0:	subq	$6, %rax
	jbe	_rs_fn
_resize:
	subq	%rbx, %rax
	neg	%rax
	leaq	5(%rbx), %rbx
	leaq	(%rsp, %rax, 8), %rdi
_rs_lp:	cmpq	$0, %rbx
	jz	_rs_dn
	movq	(%rsp), %r15
	movq	%r15, (%rsp, %rax, 8)
	dec	%rbx
	addq	$8, %rsp
	jmp	_rs_lp
_rs_dn:	movq	%rdi, %rsp
_rs_fn:	popq	%r15
	popq	%rdi
	popq	%rax
_rs_en:	xorq	%rbx, %rbx
_nf_lp:	cmpq	%rax, %r15
	jge	_nf_en
	cmpq	$0, %r15
	jz	_nf_1
	cmpq	$1, %r15
	jz	_nf_2
	cmpq	$2, %r15
	jz	_nf_3
	cmpq	$3, %r15
	jz	_nf_4
	cmpq	$4, %r15
	jz	_nf_5
	cmpq	$5, %r15
	jz	_nf_6
	jmp	_nf_g
_nf_1:	movq	$17, %rdi
	jmp	_nf_cm
_nf_2:	movq	$17, %rsi
	jmp	_nf_cm
_nf_3:	movq	$17, %rdx
	jmp	_nf_cm
_nf_4:	movq	$17, %rcx
	jmp	_nf_cm
_nf_5:	movq	$17, %r8
	jmp	_nf_cm
_nf_6:	movq	$17, %r9
	jmp	_nf_cm
_nf_g:	movq	$17, 16(%rsp, %rbx, 8)
	inc	%rbx
_nf_cm:	inc	%r15
	jmp	_nf_lp
_nf_en:	ret

	.global _clear_regs
_clear_regs:
	xorl	%edi, %edi
	xorl	%esi, %esi
	xorl	%edx, %edx
	xorl	%ecx, %ecx
	xorq	%r8, %r8
	xorq	%r9, %r9
	xorq	%r10, %r10
	xorq	%r11, %r11
	ret

	.global _prep_gc
_prep_gc:
	cmpq	%r12, _mem_max(%rip)
	jb	_prep
	ret
_prep:
	popq	%r15 # return address
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	pushq	%rdx
	pushq	%rcx 
	pushq	%r8
	pushq	%r9 
	pushq	%r10
	pushq	%r11
	pushq	%rdi
	pushq	%rsi
	movq	%rsp, %rdi      # Stack pointer
	movq	%r12, %rsi      # Memory pointer
	movq	%r13, %rdx      # Memory base
	sarq	$3, %rdx
	pushq	%rax
	movq	%xmm4, %rax
	pushq	%rax
	movq	%xmm5, %rax
	pushq	%rax
	movq	%xmm6, %rax
	pushq	%rax
	movq	%xmm7, %rax
	pushq	%rax
	movq	%xmm8, %rax
	pushq	%rax
	movq	%xmm9, %rax
	pushq	%rax
	movq	%xmm10, %rax
	pushq	%rax
	movq	%xmm11, %rax
	pushq	%rax
	movq	%xmm12, %rax
	pushq	%rax
	movq	%xmm13, %rax
	pushq	%rax
	movq	%xmm14, %rax
	pushq	%rax
	movq	%xmm15, %rax
	pushq	%rax
	pushq	%rbp
	movq	%rsp, %rbp
	andq	$-16, %rsp
	call	_gc
	leave
	movq	%rdx, %r12
	leaq	3(, %rax, 8), %r13
	popq	%rax
	movq	%rax, %xmm15
	popq	%rax
	movq	%rax, %xmm14
	popq	%rax
	movq	%rax, %xmm13
	popq	%rax
	movq	%rax, %xmm12
	popq	%rax
	movq	%rax, %xmm11
	popq	%rax
	movq	%rax, %xmm10
	popq	%rax
	movq	%rax, %xmm9
	popq	%rax
	movq	%rax, %xmm8
	popq	%rax
	movq	%rax, %xmm7
	popq	%rax
	movq	%rax, %xmm6
	popq	%rax
	movq	%rax, %xmm5
	popq	%rax
	movq	%rax, %xmm4
	popq	%rax
	popq	%rsi
	popq	%rdi
	popq	%r11
	popq	%r10
	popq	%r9
	popq	%r8
	popq	%rcx
	popq	%rdx
	popq	%r14
	sarq	$3, %r14
	jmp	*%r15

	
	//https://studium.umontreal.ca/mod/resource/view.php?id=1166919
	.globl _minit
_minit:
        # determine if OS is linux or OS X

        movq	$-1, %rdi            	# parameter of system call is -1
        movq	$13, %rax            	# system call number 13 is "time" on linux and a noop on OS X
        syscall                      	# perform system call to OS

        cmpq	$0, %rax             	# negative means error which means linux
        js	mmap_syscall_linux

mmap_syscall_osx:
        movq	$0x20000c5, %rax     	# "mmap" system call is 0x20000c5
        movq	$0x1002, %rcx        	# rcx = MAP_PRIVATE | MAP_ANON
        jmp     mmap_syscall

mmap_syscall_linux:
        movq	$9, %rax             	# "mmap" system call is 9
        movq	$0x22, %rcx          	# rcx = MAP_PRIVATE | MAP_ANON

mmap_syscall:
        movq	$0, %rdi             	# rdi = address
        movq	_mem_size(%rip), %rsi	# rsi = block length
        movq	$7, %rdx            	# rdx = PROT_READ | PROT_WRITE | PROT_EXEC
        movq	$-1, %r8           	# r8 = file descriptor (-1 = none)
        movq	$0, %r9              	# r9 = offset
        movq	%rcx, %r10         	# r10 = rcx (unclear why this is needed)
        syscall
        ret
