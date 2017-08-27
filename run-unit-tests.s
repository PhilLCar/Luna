	.text
	.global	_main
	.global	main
_main:
main:
	pushq	%rbx
	pushq	%r12
	pushq	%r13
	pushq	%r14
	pushq	%r15
	pushq	%rbp
	movq	%rsp, %rbp
	xor	%rbx, %rbx
	movq	%rbp, _stack_base(%rip)
	movq	$134217728, %rax
	movq	%rax, _mem_size(%rip)
	call	_minit
	movq	%rax, %r12
	addq	$100663296, %rax
	movq	%rax, _mem_max(%rip)
	movq	$0, (%r12)
	movq	$17, 8(%r12)
	movq	$17, 16(%r12)
	lea	3(, %r12, 8), %r13
	addq	$24, %r12
	movq	$17, %r14
	call	_clear_regs
	.align	8
	.fill	3, 1, 0x90
	callq	_load_os
	.fill	3, 1, 0x90
	callq	_load_string
	.fill	3, 1, 0x90
	callq	_load_io
	.fill	3, 1, 0x90
	callq	_load_lua

# GENERATED CODE BEGINING
################################################################################

	movq	$17, -8(%rbp)
	movq	$17, -16(%rbp)
	movq	$17, -24(%rbp)
	movq	$17, -32(%rbp)
	subq	$32, %rsp
	call	_prep_gc
	movq	$17, -40(%rbp)
	movq	$17, -48(%rbp)
	movq	$17, -56(%rbp)
	movq	$17, -64(%rbp)
	subq	$32, %rsp
	call	_prep_gc
	leaq	_ST1(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_new	
	leaq	(%rax), %rdx
	movq	%rdx, -72(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -72(%rbp)
	leaq	_FN1(%rip), %rdx
	movq	%rdx, (%r12)
	movq	%r14, 8(%r12)
	leaq	7(, %r12, 8), %rdx
	addq	$16, %r12
	movq	%rdx, -80(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	$-9, %rax
	movq	$-1, %rbx
	call	_transfer
	leaq	_ST2(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	addq	$16, %rsp
	call	_new	
	leaq	(%rax), %rdx
	movq	%rdx, -72(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -72(%rbp)
	leaq	_FN2(%rip), %rdx
	movq	%rdx, (%r12)
	movq	%r14, 8(%r12)
	leaq	7(, %r12, 8), %rdx
	addq	$16, %r12
	movq	%rdx, -80(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	$-9, %rax
	movq	$-1, %rbx
	call	_transfer
	leaq	_ST3(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	addq	$16, %rsp
	call	_new	
	leaq	(%rax), %rdx
	movq	%rdx, -72(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -72(%rbp)
	leaq	_FN3(%rip), %rdx
	movq	%rdx, (%r12)
	movq	%r14, 8(%r12)
	leaq	7(, %r12, 8), %rdx
	addq	$16, %r12
	movq	%rdx, -80(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	$-9, %rax
	movq	$-1, %rbx
	call	_transfer
	leaq	_ST4(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	addq	$16, %rsp
	call	_new	
	leaq	(%rax), %rdx
	movq	%rdx, -72(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -72(%rbp)
	leaq	_FN4(%rip), %rdx
	movq	%rdx, (%r12)
	movq	%r14, 8(%r12)
	leaq	7(, %r12, 8), %rdx
	addq	$16, %r12
	movq	%rdx, -80(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	$-9, %rax
	movq	$-1, %rbx
	call	_transfer
	addq	$16, %rsp
	movq	-32(%rbp), %rbx
	leaq	_ST5(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_encl
	movq	-48(%rbp), %rbx
	leaq	_ST6(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_encl
	movq	-8(%rbp), %rbx
	leaq	_ST7(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_encl
	movq	-16(%rbp), %rbx
	leaq	_ST8(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_encl
	movq	-24(%rbp), %rbx
	leaq	_ST9(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_encl
	leaq	_ST10(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_new	
	leaq	(%rax), %rdx
	movq	%rdx, -72(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -72(%rbp)
	leaq	_FN5(%rip), %rdx
	movq	%rdx, (%r12)
	movq	%r14, 8(%r12)
	leaq	7(, %r12, 8), %rdx
	addq	$16, %r12
	movq	%rdx, -80(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	$-9, %rax
	movq	$-1, %rbx
	call	_transfer
	leaq	_ST11(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	addq	$16, %rsp
	call	_new	
	leaq	(%rax), %rdx
	movq	%rdx, -72(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -72(%rbp)
	leaq	_FN6(%rip), %rdx
	movq	%rdx, (%r12)
	movq	%r14, 8(%r12)
	leaq	7(, %r12, 8), %rdx
	addq	$16, %r12
	movq	%rdx, -80(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	$-9, %rax
	movq	$-1, %rbx
	call	_transfer
	leaq	-40(%rbp), %rdx
	movq	%rdx, -72(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -72(%rbp)
	leaq	_ST1(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	addq	$8, %rsp
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -80(%rbp)
	leaq	-80(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$0, %r15
	movq	-80(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-88(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-72(%rbp), %rsp
	movq	%rax, -80(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	$-9, %rax
	movq	$-1, %rbx
	call	_transfer
	addq	$16, %rsp
	leaq	_ST7(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	%rax, -72(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -72(%rbp)
	subq	$8, %rsp
	movq	-40(%rbp), %rax
	sarq	$3, %rax
	cmpq	$-1, (%rax)
	jnz	_LU12
	call	_check
_LU12:	cvtsi2sd (%rax), %xmm0
	movsd	%xmm0, %xmm4
	xorq	%rbx, %rbx
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -80(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	$-9, %rax
	movq	$-1, %rbx
	call	_transfer
	addq	$16, %rsp
	leaq	_ST8(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	%rax, -72(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -72(%rbp)
	movsd	_DB13(%rip), %xmm4
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -80(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	$-9, %rax
	movq	$-1, %rbx
	call	_transfer
	addq	$16, %rsp
	leaq	_ST9(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	%rax, -72(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -72(%rbp)
	movsd	_DB13(%rip), %xmm4
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -80(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	$-9, %rax
	movq	$-1, %rbx
	call	_transfer
	addq	$16, %rsp
	leaq	_ST5(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	%rax, -72(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -72(%rbp)
	movsd	_DB13(%rip), %xmm4
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -80(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	$-9, %rax
	movq	$-1, %rbx
	call	_transfer
	addq	$16, %rsp
	leaq	_ST6(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	%rax, -72(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -72(%rbp)
	leaq	_ST3(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	subq	$8, %rsp
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -80(%rbp)
	leaq	-80(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$0, %r15
	movq	-80(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-88(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-72(%rbp), %rsp
	movq	%rax, -80(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	$-9, %rax
	movq	$-1, %rbx
	call	_transfer
	leaq	-56(%rbp), %rdx
	movq	%rdx, -72(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -72(%rbp)
	movq	$-33, (%r12)
	movq	$17, 8(%r12)
	leaq	-80(%rbp), %rax
	movq	%rax, 16(%r12)
	leaq	3(, %r12, 8), %rdx
	addq	$24, %r12
	addq	$8, %rsp
	pushq	$33
	call	_prep_gc
	movq	%rdx, %rax
	call	_array_copy
	leaq	-72(%rbp), %rsp
	movq	%rdx, -80(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	$-9, %rax
	movq	$-1, %rbx
	call	_transfer
	leaq	-64(%rbp), %rdx
	movq	%rdx, -72(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -72(%rbp)
	movsd	_DB13(%rip), %xmm4
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -80(%rbp)
	call	_prep_gc
	movq	$-9, %rax
	movq	$-1, %rbx
	call	_transfer
	leaq	_ST10(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	addq	$16, %rsp
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -72(%rbp)
	leaq	-72(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$0, %r15
	movq	-72(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-80(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-64(%rbp), %rsp
	movsd	_DB14(%rip), %xmm4
	movq	$129, -72(%rbp)
	movsd	%xmm4, %xmm0
	movsd	%xmm0, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -80(%rbp)
	movq	%xmm0, -88(%rbp)
	subq	$24, %rsp
	movq	-40(%rbp), %rax
	sarq	$3, %rax
	cmpq	$-1, (%rax)
	jnz	_LU15
	call	_check
_LU15:	cvtsi2sd (%rax), %xmm0
	movsd	%xmm0, %xmm4
	movsd	%xmm4, -96(%rbp)
	movsd	_DB14(%rip), %xmm4
	movsd	%xmm4, -104(%rbp)
	movsd	-88(%rbp), %xmm0
_FRC5:
	leaq	-104(%rbp), %rsp
	xorpd	%xmm1, %xmm1
	cmpsd	$6, -104(%rbp), %xmm1
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_FRN5
	movsd	%xmm0, %xmm1
	cmpsd	$6, -96(%rbp), %xmm1
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_FRE5
	jmp	_FRS5
_FRN5:	movsd	%xmm0, %xmm1
	cmpsd	$1, -96(%rbp), %xmm1
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_FRE5
_FRS5:
	call	_prep_gc
	movq	-40(%rbp), %rdx
	movq	-80(%rbp), %rax
	movq	%rdx, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -112(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	leaq	_ST16(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %rdx
	leaq	_ST17(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -120(%rbp)
	leaq	_ST18(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	movq	-112(%rbp), %rsi
	leaq	_ST19(%rip), %rax
	leaq	2(, %rax, 8), %rdx
	movq	%rdx, %rax
	movq	%rsi, %rbx
	subq	$8, %rsp
	call	_concat
	movq	%rdi, %rbx
	call	_concat
	xorq	%rbx, %rbx
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	%rax, %rdi
	movq	$1, %r15
	movq	-120(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-128(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-112(%rbp), %rsp
	leaq	_ST2(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -120(%rbp)
	leaq	-120(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$0, %r15
	movq	-120(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-128(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-112(%rbp), %rsp
	movq	%rax, -120(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	-112(%rbp), %rdx
	leaq	_ST20(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	pushq	%rbx
	call	_index	
	popq	%rdx
	movq	(%rax), %r15
	movq	%r15, -128(%rbp)
	movq	%rdx, %rdi
	movsd	_DB14(%rip), %xmm4
	subq	$8, %rsp
	movq	-112(%rbp), %rax
	sarq	$3, %rax
	cmpq	$-1, (%rax)
	jnz	_LU21
	call	_check
_LU21:	cvtsi2sd (%rax), %xmm0
	movsd	%xmm0, %xmm5
	movsd	_DB22(%rip), %xmm6
	subsd	%xmm6, %xmm5
	xorq	%rbx, %rbx
	xorq	%rbx, %rbx
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movsd	%xmm5, (%r12)
	leaq	6(, %r12, 8), %rdx
	addq	$8, %r12
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %rsi
	addq	$8, %r12
	movq	$3, %r15
	movq	-128(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-136(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-120(%rbp), %rsp
	movq	%rax, %rdx
	leaq	_ST23(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_concat
	xorq	%rbx, %rbx
	movq	%rax, -128(%rbp)
	movq	$1, -136(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movsd	_DB14(%rip), %xmm4
	movq	$129, -144(%rbp)
	movsd	%xmm4, %xmm0
	movsd	%xmm0, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -152(%rbp)
	movq	%xmm0, -160(%rbp)
	subq	$24, %rsp
	movq	-120(%rbp), %rax
	sarq	$3, %rax
	cmpq	$-1, (%rax)
	jnz	_LU24
	call	_check
_LU24:	cvtsi2sd (%rax), %xmm0
	movsd	%xmm0, %xmm4
	movsd	%xmm4, -168(%rbp)
	movsd	_DB14(%rip), %xmm4
	movsd	%xmm4, -176(%rbp)
	movsd	-160(%rbp), %xmm0
_FRC6:
	leaq	-176(%rbp), %rsp
	xorpd	%xmm1, %xmm1
	cmpsd	$6, -176(%rbp), %xmm1
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_FRN6
	movsd	%xmm0, %xmm1
	cmpsd	$6, -168(%rbp), %xmm1
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_FRE6
	jmp	_FRS6
_FRN6:	movsd	%xmm0, %xmm1
	cmpsd	$1, -168(%rbp), %xmm1
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_FRE6
_FRS6:
	call	_prep_gc
_IF8:
	movq	-120(%rbp), %rdx
	movq	-152(%rbp), %rax
	movq	%rdx, %rbx
	call	_index	
	movq	(%rax), %rdx
	movq	-128(%rbp), %rax
	movq	%rdx, %rbx
	call	_compare
	xorq	%rbx, %rbx
_TH8:
	cmpq	$1, %rax
	jz	_FI8
	cmpq	$17, %rax
	jz	_FI8
	leaq	-136(%rbp), %rdx
	movq	%rdx, -184(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -184(%rbp)
	movq	$9, -192(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	$-23, %rax
	movq	$-1, %rbx
	call	_transfer
_FI8:
	leaq	-176(%rbp), %rsp
	movsd	-176(%rbp), %xmm1
	movsd	-160(%rbp), %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -160(%rbp)
	movq	-152(%rbp), %rax
	sarq	$3, %rax
	movsd	%xmm0, (%rax)
	jmp	_FRC6
_FRE6:
	leaq	-136(%rbp), %rsp
_IF9:
_TH9:
	cmpq	$1, -136(%rbp)
	jz	_EL9
	cmpq	$17, -136(%rbp)
	jz	_EL9
	leaq	_ST25(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %rdx
	leaq	_ST26(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -144(%rbp)
	leaq	-144(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	-128(%rbp), %rdi
	movq	$1, %r15
	movq	-144(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-152(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-136(%rbp), %rsp
	movq	%rax, -144(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	-144(%rbp), %rdx
	leaq	_ST27(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	pushq	%rbx
	call	_index	
	popq	%rdx
	movq	(%rax), %r15
	movq	%r15, -152(%rbp)
	movq	%rdx, %rdi
	leaq	_ST28(%rip), %rax
	leaq	2(, %rax, 8), %rsi
	leaq	-152(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$2, %r15
	movq	-152(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-160(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-144(%rbp), %rsp
	movq	%rax, -152(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	-144(%rbp), %rdx
	leaq	_ST29(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	pushq	%rbx
	call	_index	
	popq	%rdx
	movq	(%rax), %r15
	movq	%r15, -160(%rbp)
	movq	%rdx, %rdi
	leaq	-160(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$1, %r15
	movq	-160(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-168(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-152(%rbp), %rsp
	leaq	_ST11(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -160(%rbp)
	leaq	-160(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	-112(%rbp), %rdi
	movq	$1, %r15
	movq	-160(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-168(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-152(%rbp), %rsp
	movq	%rax, -160(%rbp)
	subq	$8, %rsp
	call	_prep_gc
_IF10:
	movq	-152(%rbp), %rdx
	movq	-160(%rbp), %rax
	movq	%rdx, %rbx
	call	_compare
	xorq	%rbx, %rbx
_TH10:
	cmpq	$1, %rax
	jz	_EL10
	cmpq	$17, %rax
	jz	_EL10
	leaq	_ST8(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	%rax, -168(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -168(%rbp)
	subq	$8, %rsp
	leaq	_ST8(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	(%rax), %rdx
	movsd	_DB14(%rip), %xmm4
	movsd	%xmm4, %xmm0
	movq	%rdx, %rbx
	sarq	$3, %rbx
	movsd	(%rbx), %xmm4
	addsd	%xmm0, %xmm4
	xorq	%rbx, %rbx
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -176(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	$-21, %rax
	movq	$-1, %rbx
	call	_transfer
	jmp	_FI10
_EL10:
	leaq	_ST9(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	%rax, -168(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -168(%rbp)
	subq	$8, %rsp
	leaq	_ST9(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	(%rax), %rdx
	movsd	_DB14(%rip), %xmm4
	movsd	%xmm4, %xmm0
	movq	%rdx, %rbx
	sarq	$3, %rbx
	movsd	(%rbx), %xmm4
	addsd	%xmm0, %xmm4
	xorq	%rbx, %rbx
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -176(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	$-21, %rax
	movq	$-1, %rbx
	call	_transfer
	leaq	-64(%rbp), %rdx
	movq	%rdx, -168(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -168(%rbp)
	movq	-64(%rbp), %rdx
	movsd	_DB14(%rip), %xmm4
	movsd	%xmm4, %xmm0
	movq	%rdx, %rbx
	sarq	$3, %rbx
	movsd	(%rbx), %xmm4
	addsd	%xmm0, %xmm4
	xorq	%rbx, %rbx
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -176(%rbp)
	call	_prep_gc
	movq	$-21, %rax
	movq	$-1, %rbx
	call	_transfer
	movq	-56(%rbp), %rdx
	movq	-64(%rbp), %rax
	movq	%rdx, %rbx
	addq	$16, %rsp
	call	_new	
	movq	%rax, -168(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -168(%rbp)
	movq	-128(%rbp), %r15
	movq	%r15, -176(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	$-21, %rax
	movq	$-1, %rbx
	call	_transfer
_FI10:
	leaq	-160(%rbp), %rsp
	jmp	_FI9
_EL9:
	leaq	_ST5(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	%rax, -144(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -144(%rbp)
	subq	$8, %rsp
	leaq	_ST5(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	(%rax), %rdx
	movsd	_DB14(%rip), %xmm4
	movsd	%xmm4, %xmm0
	movq	%rdx, %rbx
	sarq	$3, %rbx
	movsd	(%rbx), %xmm4
	addsd	%xmm0, %xmm4
	xorq	%rbx, %rbx
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -152(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	$-18, %rax
	movq	$-1, %rbx
	call	_transfer
	leaq	-64(%rbp), %rdx
	movq	%rdx, -144(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -144(%rbp)
	movq	-64(%rbp), %rdx
	movsd	_DB14(%rip), %xmm4
	movsd	%xmm4, %xmm0
	movq	%rdx, %rbx
	sarq	$3, %rbx
	movsd	(%rbx), %xmm4
	addsd	%xmm0, %xmm4
	xorq	%rbx, %rbx
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -152(%rbp)
	call	_prep_gc
	movq	$-18, %rax
	movq	$-1, %rbx
	call	_transfer
	movq	-56(%rbp), %rdx
	movq	-64(%rbp), %rax
	movq	%rdx, %rbx
	addq	$16, %rsp
	call	_new	
	movq	%rax, -144(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -144(%rbp)
	movq	-112(%rbp), %r15
	movq	%r15, -152(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	$-18, %rax
	movq	$-1, %rbx
	call	_transfer
_FI9:
	leaq	-136(%rbp), %rsp
	leaq	_ST10(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -144(%rbp)
	leaq	-144(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$0, %r15
	movq	-144(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-152(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-136(%rbp), %rsp
	movsd	-104(%rbp), %xmm1
	movsd	-88(%rbp), %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -88(%rbp)
	movq	-80(%rbp), %rax
	sarq	$3, %rax
	movsd	%xmm0, (%rax)
	jmp	_FRC5
_FRE5:
	leaq	-64(%rbp), %rsp
	leaq	_ST25(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %rdx
	leaq	_ST30(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -72(%rbp)
	leaq	_ST31(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	leaq	-72(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$1, %r15
	movq	-72(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-80(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-64(%rbp), %rsp
	leaq	_ST32(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -72(%rbp)
	leaq	-72(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$0, %r15
	movq	-72(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-80(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-64(%rbp), %rsp
_IF11:
	leaq	_ST8(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	(%rax), %rdx
	leaq	_ST7(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	(%rax), %rax
	movq	%rdx, %rbx
	call	_compare
	xorq	%rbx, %rbx
_TH11:
	cmpq	$1, %rax
	jz	_EL11
	cmpq	$17, %rax
	jz	_EL11
	leaq	_ST32(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -72(%rbp)
	leaq	_ST33(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	leaq	-72(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$1, %r15
	movq	-72(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-80(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-64(%rbp), %rsp
	jmp	_FI11
_EL11:
	leaq	_ST32(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -72(%rbp)
	leaq	_ST34(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	subq	$8, %rsp
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -80(%rbp)
	leaq	_ST35(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	subq	$8, %rsp
	call	_index	
	movq	(%rax), %rdi
	leaq	_ST36(%rip), %rax
	leaq	2(, %rax, 8), %rsi
	movq	%rsi, %rax
	movq	%rdi, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -88(%rbp)
	leaq	_ST37(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	subq	$8, %rsp
	leaq	_ST9(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	(%rax), %rsi
	leaq	_ST5(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	(%rax), %rax
	sarq	$3, %rax
	movq	%rsi, %rbx
	sarq	$3, %rbx
	movsd	(%rbx), %xmm4
	addsd	(%rax), %xmm4
	leaq	_ST7(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	(%rax), %rax
	sarq	$3, %rax
	divsd	(%rax), %xmm4
	xorq	%rbx, %rbx
	movsd	_DB38(%rip), %xmm5
	mulsd	%xmm5, %xmm4
	xorq	%rbx, %rbx
	xorq	%rbx, %rbx
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %rsi
	addq	$8, %r12
	movq	$2, %r15
	movq	-88(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-96(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-80(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	%rax, %rdi
	movq	$1, %r15
# Comparison routine
	cmpq	$33, %rax
	jnz	_DN42
	dec	%r15
	jmp	_DE40
_DN42:	cmpq	$0, %rbx
	jz	_DE40
_DM39:	cmpq	$33, (%rbx)
	jz	_DE40
	cmpq	$1, %r15
	jz	_DV43
	cmpq	$2, %r15
	jz	_DV44
	cmpq	$3, %r15
	jz	_DV45
	cmpq	$4, %r15
	jz	_DV46
	cmpq	$5, %r15
	jz	_DV47
	jmp	_DV48
_DV43:	movq	(%rbx), %rsi
	jmp	_DA41
_DV44:	movq	(%rbx), %rdx
	jmp	_DA41
_DV45:	movq	(%rbx), %rcx
	jmp	_DA41
_DV46:	movq	(%rbx), %r8
	jmp	_DA41
_DV47:	movq	(%rbx), %r9
	jmp	_DA41
_DV48:	pushq	(%rbx)
_DA41:	subq	$8, %rbx
	inc	%r15
	jmp	_DM39
_DE40:	movq	-80(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-88(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-72(%rbp), %rsp
	movq	%rax, %rdi
	leaq	_ST49(%rip), %rax
	leaq	2(, %rax, 8), %rsi
	movq	%rsi, %rax
	movq	%rdi, %rbx
	call	_concat
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	%rax, %rdi
	movq	$1, %r15
	movq	-72(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-80(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-64(%rbp), %rsp
	movsd	_DB14(%rip), %xmm4
	movq	$129, -72(%rbp)
	movsd	%xmm4, %xmm0
	movsd	%xmm0, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -80(%rbp)
	movq	%xmm0, -88(%rbp)
	movq	-64(%rbp), %rax
	sarq	$3, %rax
	movq	(%rax), %r15
	movq	%r15, -96(%rbp)
	movsd	_DB14(%rip), %xmm4
	movsd	%xmm4, -104(%rbp)
	movsd	-88(%rbp), %xmm0
_FRC7:
	leaq	-104(%rbp), %rsp
	xorpd	%xmm1, %xmm1
	cmpsd	$6, -104(%rbp), %xmm1
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_FRN7
	movsd	%xmm0, %xmm1
	cmpsd	$6, -96(%rbp), %xmm1
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_FRE7
	jmp	_FRS7
_FRN7:	movsd	%xmm0, %xmm1
	cmpsd	$1, -96(%rbp), %xmm1
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_FRE7
_FRS7:
	call	_prep_gc
	leaq	_ST32(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -112(%rbp)
	leaq	_ST50(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	movq	-56(%rbp), %rsi
	movq	-80(%rbp), %rax
	movq	%rsi, %rbx
	subq	$8, %rsp
	call	_index	
	movq	(%rax), %rax
	movq	%rdi, %rbx
	call	_concat
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	%rax, %rdi
	movq	$1, %r15
	movq	-112(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-120(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-104(%rbp), %rsp
	movsd	-104(%rbp), %xmm1
	movsd	-88(%rbp), %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -88(%rbp)
	movq	-80(%rbp), %rax
	sarq	$3, %rax
	movsd	%xmm0, (%rax)
	jmp	_FRC7
_FRE7:
	leaq	-64(%rbp), %rsp
_FI11:
	leaq	-64(%rbp), %rsp
	leave
	popq	%r15
	popq	%r14
	popq	%r13
	popq	%r12
	popq	%rbx
	movq	$0, %rax
	ret

# FUNCTIONS
################################################################################

	.align	8
_FN1:
	movq	$0, %rax
	call	_nil_fill
	call	_prep_gc
listlua:
	pushq	%rbp
	movq	%rsp, %rbp
	leaq	_ST25(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %rdx
	leaq	_ST26(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -8(%rbp)
	leaq	_ST51(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	leaq	-8(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$1, %r15
	movq	-8(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-16(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	(%rbp), %rsp
	movq	%rax, -8(%rbp)
	movq	$-33, (%r12)
	movq	$17, 8(%r12)
	leaq	-16(%rbp), %rax
	movq	%rax, 16(%r12)
	leaq	3(, %r12, 8), %rdx
	addq	$24, %r12
	subq	$8, %rsp
	pushq	$33
	call	_prep_gc
	movq	%rdx, %rax
	call	_array_copy
	leaq	-8(%rbp), %rsp
	movq	%rdx, -16(%rbp)
	movsd	_DB13(%rip), %xmm4
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -24(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	-8(%rbp), %rdx
	leaq	_ST55(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	pushq	%rbx
	call	_index	
	popq	%rdx
	movq	(%rax), %r15
	movq	%r15, -32(%rbp)
	movq	%rdx, %rdi
	leaq	-32(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$1, %r15
	movq	-32(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-40(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-24(%rbp), %rsp
	movq	%rax, -32(%rbp)
	subq	$8, %rsp
	leaq	-8(%rsp), %r15
	movq	$17, -40(%rbp)
	movq	$17, -48(%rbp)
	subq	$16, %rsp
	call	_fill
	call	_prep_gc
_FIC1:
	leaq	-48(%rbp), %rsp
	call	_prep_gc
	movq	-32(%rbp), %rax
	sarq	$3, %rax
	pushq	%r14
	movq	-40(%rbp), %rdi
	movq	-48(%rbp), %rsi
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	call	*(%rax)
	popq	%r14
	cmpq	$17, %rax
	jz	_FIE1
	movq	%rax, -48(%rbp)
	cmpq	$33, %rax
	jz	_LU52
	pushq	%rax
	leaq	0(%rsp), %r15
	cmp	$0, %rbx
	jz	_LU52
_LU53:	cmpq	$33, (%rbx)
	jz	_LU52
	pushq	(%rbx)
	subq	$8, %rbx
	jmp	_LU53
_LU52:	cmpq	%rsp, %r15
	jge	_LU54
	pushq	$17
	jmp	_LU52
_LU54:	movq	%r15, %rsp
_IF1:
	movq	-56(%rbp), %rdx
	leaq	_ST56(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	pushq	%rbx
	call	_index	
	popq	%rdx
	movq	(%rax), %r15
	movq	%r15, -64(%rbp)
	movq	%rdx, %rdi
	leaq	_ST57(%rip), %rax
	leaq	2(, %rax, 8), %rsi
	leaq	-64(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$2, %r15
	movq	-64(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-72(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-56(%rbp), %rsp
	movq	%rax, %rdx
	movq	%rdx, %rax
	orq	$17, %rdx
	cmpq	$17, %rdx
	jz	_CH1
	movq	-56(%rbp), %rdx
	leaq	_ST56(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	pushq	%rbx
	call	_index	
	popq	%rdx
	movq	(%rax), %r15
	movq	%r15, -64(%rbp)
	movq	%rdx, %rdi
	leaq	_ST58(%rip), %rax
	leaq	2(, %rax, 8), %rsi
	leaq	-64(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$2, %r15
	movq	-64(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-72(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-56(%rbp), %rsp
	movq	%rax, %rax
	call	_not
	movq	%rax, %rdx
	movq	%rdx, %rax
_CH1:	leaq	-56(%rbp), %rsp
	xorq	%rbx, %rbx
	movq	%rax, %rdx
	movq	%rdx, %rax
	orq	$17, %rdx
	cmpq	$17, %rdx
	jz	_CH2
	movq	-56(%rbp), %rdx
	leaq	_ST56(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	pushq	%rbx
	call	_index	
	popq	%rdx
	movq	(%rax), %r15
	movq	%r15, -64(%rbp)
	movq	%rdx, %rdi
	leaq	_ST59(%rip), %rax
	leaq	2(, %rax, 8), %rsi
	leaq	-64(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$2, %r15
	movq	-64(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-72(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-56(%rbp), %rsp
	movq	%rax, %rax
	call	_not
	movq	%rax, %rdx
	movq	%rdx, %rax
_CH2:	leaq	-56(%rbp), %rsp
	xorq	%rbx, %rbx
	xorq	%rbx, %rbx
_TH1:
	cmpq	$1, %rax
	jz	_FI1
	cmpq	$17, %rax
	jz	_FI1
	leaq	-24(%rbp), %rdx
	movq	%rdx, -64(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -64(%rbp)
	movq	-24(%rbp), %rdx
	movsd	_DB14(%rip), %xmm4
	movsd	%xmm4, %xmm0
	movq	%rdx, %rbx
	sarq	$3, %rbx
	movsd	(%rbx), %xmm4
	addsd	%xmm0, %xmm4
	xorq	%rbx, %rbx
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -72(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	$-8, %rax
	movq	$-1, %rbx
	call	_transfer
	movq	-16(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rbx
	addq	$16, %rsp
	call	_new	
	movq	%rax, -64(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -64(%rbp)
	leaq	_ST60(%rip), %rax
	leaq	2(, %rax, 8), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rbx
	subq	$8, %rsp
	call	_concat
	xorq	%rbx, %rbx
	movq	%rax, -72(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	$-8, %rax
	movq	$-1, %rbx
	call	_transfer
_FI1:
	leaq	-56(%rbp), %rsp
	jmp	_FIC1
_FIE1:
	leaq	-24(%rbp), %rsp
	movq	-8(%rbp), %rdx
	leaq	_ST29(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	pushq	%rbx
	call	_index	
	popq	%rdx
	movq	(%rax), %r15
	movq	%r15, -32(%rbp)
	movq	%rdx, %rdi
	leaq	-32(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$1, %r15
	movq	-32(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-40(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-24(%rbp), %rsp
	xorq	%rbx, %rbx
	movq	-16(%rbp), %rax
	leave
	ret
	.byte	0x0F, 0x90
_FE1:

	.align	8
_FN2:
	movq	$0, %rax
	call	_nil_fill
	call	_prep_gc
listexe:
	pushq	%rbp
	movq	%rsp, %rbp
	leaq	_ST25(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %rdx
	leaq	_ST26(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -8(%rbp)
	leaq	_ST51(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	leaq	-8(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$1, %r15
	movq	-8(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-16(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	(%rbp), %rsp
	movq	%rax, -8(%rbp)
	movq	$-33, (%r12)
	movq	$17, 8(%r12)
	leaq	-16(%rbp), %rax
	movq	%rax, 16(%r12)
	leaq	3(, %r12, 8), %rdx
	addq	$24, %r12
	subq	$8, %rsp
	pushq	$33
	call	_prep_gc
	movq	%rdx, %rax
	call	_array_copy
	leaq	-8(%rbp), %rsp
	movq	%rdx, -16(%rbp)
	movsd	_DB13(%rip), %xmm4
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -24(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	-8(%rbp), %rdx
	leaq	_ST55(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	pushq	%rbx
	call	_index	
	popq	%rdx
	movq	(%rax), %r15
	movq	%r15, -32(%rbp)
	movq	%rdx, %rdi
	leaq	-32(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$1, %r15
	movq	-32(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-40(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-24(%rbp), %rsp
	movq	%rax, -32(%rbp)
	subq	$8, %rsp
	leaq	-8(%rsp), %r15
	movq	$17, -40(%rbp)
	movq	$17, -48(%rbp)
	subq	$16, %rsp
	call	_fill
	call	_prep_gc
_FIC2:
	leaq	-48(%rbp), %rsp
	call	_prep_gc
	movq	-32(%rbp), %rax
	sarq	$3, %rax
	pushq	%r14
	movq	-40(%rbp), %rdi
	movq	-48(%rbp), %rsi
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	call	*(%rax)
	popq	%r14
	cmpq	$17, %rax
	jz	_FIE2
	movq	%rax, -48(%rbp)
	cmpq	$33, %rax
	jz	_LU61
	pushq	%rax
	leaq	0(%rsp), %r15
	cmp	$0, %rbx
	jz	_LU61
_LU62:	cmpq	$33, (%rbx)
	jz	_LU61
	pushq	(%rbx)
	subq	$8, %rbx
	jmp	_LU62
_LU61:	cmpq	%rsp, %r15
	jge	_LU63
	pushq	$17
	jmp	_LU61
_LU63:	movq	%r15, %rsp
_IF2:
	movq	-56(%rbp), %rdx
	leaq	_ST56(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	pushq	%rbx
	call	_index	
	popq	%rdx
	movq	(%rax), %r15
	movq	%r15, -64(%rbp)
	movq	%rdx, %rdi
	leaq	_ST23(%rip), %rax
	leaq	2(, %rax, 8), %rsi
	leaq	-64(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$2, %r15
	movq	-64(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-72(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-56(%rbp), %rsp
_TH2:
	cmpq	$1, %rax
	jz	_FI2
	cmpq	$17, %rax
	jz	_FI2
	leaq	-24(%rbp), %rdx
	movq	%rdx, -64(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -64(%rbp)
	movq	-24(%rbp), %rdx
	movsd	_DB14(%rip), %xmm4
	movsd	%xmm4, %xmm0
	movq	%rdx, %rbx
	sarq	$3, %rbx
	movsd	(%rbx), %xmm4
	addsd	%xmm0, %xmm4
	xorq	%rbx, %rbx
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -72(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	$-8, %rax
	movq	$-1, %rbx
	call	_transfer
	movq	-16(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, %rbx
	addq	$16, %rsp
	call	_new	
	movq	%rax, -64(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -64(%rbp)
	leaq	_ST60(%rip), %rax
	leaq	2(, %rax, 8), %rdx
	movq	-56(%rbp), %rax
	movq	%rdx, %rbx
	subq	$8, %rsp
	call	_concat
	xorq	%rbx, %rbx
	movq	%rax, -72(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	$-8, %rax
	movq	$-1, %rbx
	call	_transfer
_FI2:
	leaq	-56(%rbp), %rsp
	jmp	_FIC2
_FIE2:
	leaq	-24(%rbp), %rsp
	movq	-8(%rbp), %rdx
	leaq	_ST29(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	pushq	%rbx
	call	_index	
	popq	%rdx
	movq	(%rax), %r15
	movq	%r15, -32(%rbp)
	movq	%rdx, %rdi
	leaq	-32(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$1, %r15
	movq	-32(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-40(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-24(%rbp), %rsp
	xorq	%rbx, %rbx
	movq	-16(%rbp), %rax
	leave
	ret
	.byte	0x0F, 0x90
_FE2:

	.align	8
_FN3:
	movq	$0, %rax
	call	_nil_fill
	call	_prep_gc
gettime:
	pushq	%rbp
	movq	%rsp, %rbp
	leaq	_ST25(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %rdx
	leaq	_ST26(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -8(%rbp)
	leaq	_ST64(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	leaq	-8(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$1, %r15
	movq	-8(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-16(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	(%rbp), %rsp
	movq	%rax, -8(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	leaq	_ST65(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -16(%rbp)
	movq	-8(%rbp), %rdi
	leaq	_ST27(%rip), %rax
	leaq	2(, %rax, 8), %rsi
	movq	%rsi, %rax
	movq	%rdi, %rbx
	subq	$8, %rsp
	pushq	%rbx
	call	_index	
	popq	%rdi
	movq	(%rax), %r15
	movq	%r15, -24(%rbp)
	leaq	_ST28(%rip), %rax
	leaq	2(, %rax, 8), %rsi
	leaq	-24(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$2, %r15
	movq	-24(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-32(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-16(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	%rax, %rdi
	movq	$1, %r15
# Comparison routine
	cmpq	$33, %rax
	jnz	_DN69
	dec	%r15
	jmp	_DE67
_DN69:	cmpq	$0, %rbx
	jz	_DE67
_DM66:	cmpq	$33, (%rbx)
	jz	_DE67
	cmpq	$1, %r15
	jz	_DV70
	cmpq	$2, %r15
	jz	_DV71
	cmpq	$3, %r15
	jz	_DV72
	cmpq	$4, %r15
	jz	_DV73
	cmpq	$5, %r15
	jz	_DV74
	jmp	_DV75
_DV70:	movq	(%rbx), %rsi
	jmp	_DA68
_DV71:	movq	(%rbx), %rdx
	jmp	_DA68
_DV72:	movq	(%rbx), %rcx
	jmp	_DA68
_DV73:	movq	(%rbx), %r8
	jmp	_DA68
_DV74:	movq	(%rbx), %r9
	jmp	_DA68
_DV75:	pushq	(%rbx)
_DA68:	subq	$8, %rbx
	inc	%r15
	jmp	_DM66
_DE67:	movq	-16(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-24(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-8(%rbp), %rsp
	movq	%rax, -16(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	-8(%rbp), %rdx
	leaq	_ST29(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	pushq	%rbx
	call	_index	
	popq	%rdx
	movq	(%rax), %r15
	movq	%r15, -24(%rbp)
	movq	%rdx, %rdi
	leaq	-24(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$1, %r15
	movq	-24(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-32(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-16(%rbp), %rsp
	xorq	%rbx, %rbx
	movq	-16(%rbp), %rax
	leave
	ret
	.byte	0x0F, 0x90
_FE3:

	.align	8
_FN4:
	movq	$0, %rax
	call	_nil_fill
	call	_prep_gc
getwidth:
	pushq	%rbp
	movq	%rsp, %rbp
	leaq	_ST25(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %rdx
	leaq	_ST26(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -8(%rbp)
	leaq	_ST76(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	leaq	-8(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$1, %r15
	movq	-8(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-16(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	(%rbp), %rsp
	movq	%rax, -8(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	leaq	_ST65(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -16(%rbp)
	movq	-8(%rbp), %rdi
	leaq	_ST27(%rip), %rax
	leaq	2(, %rax, 8), %rsi
	movq	%rsi, %rax
	movq	%rdi, %rbx
	subq	$8, %rsp
	pushq	%rbx
	call	_index	
	popq	%rdi
	movq	(%rax), %r15
	movq	%r15, -24(%rbp)
	leaq	_ST28(%rip), %rax
	leaq	2(, %rax, 8), %rsi
	leaq	-24(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$2, %r15
	movq	-24(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-32(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-16(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	%rax, %rdi
	movq	$1, %r15
# Comparison routine
	cmpq	$33, %rax
	jnz	_DN80
	dec	%r15
	jmp	_DE78
_DN80:	cmpq	$0, %rbx
	jz	_DE78
_DM77:	cmpq	$33, (%rbx)
	jz	_DE78
	cmpq	$1, %r15
	jz	_DV81
	cmpq	$2, %r15
	jz	_DV82
	cmpq	$3, %r15
	jz	_DV83
	cmpq	$4, %r15
	jz	_DV84
	cmpq	$5, %r15
	jz	_DV85
	jmp	_DV86
_DV81:	movq	(%rbx), %rsi
	jmp	_DA79
_DV82:	movq	(%rbx), %rdx
	jmp	_DA79
_DV83:	movq	(%rbx), %rcx
	jmp	_DA79
_DV84:	movq	(%rbx), %r8
	jmp	_DA79
_DV85:	movq	(%rbx), %r9
	jmp	_DA79
_DV86:	pushq	(%rbx)
_DA79:	subq	$8, %rbx
	inc	%r15
	jmp	_DM77
_DE78:	movq	-16(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-24(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-8(%rbp), %rsp
	movq	%rax, -16(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	-8(%rbp), %rdx
	leaq	_ST29(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	pushq	%rbx
	call	_index	
	popq	%rdx
	movq	(%rax), %r15
	movq	%r15, -24(%rbp)
	movq	%rdx, %rdi
	leaq	-24(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$1, %r15
	movq	-24(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-32(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-16(%rbp), %rsp
	xorq	%rbx, %rbx
	movq	-16(%rbp), %rax
	leave
	ret
	.byte	0x0F, 0x90
_FE4:

	.align	8
_FN5:
	movq	$0, %rax
	call	_nil_fill
	call	_prep_gc
progress:
	pushq	%rbp
	movq	%rsp, %rbp
	leaq	_ST8(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	(%rax), %rdx
	leaq	_ST9(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	(%rax), %rax
	sarq	$3, %rax
	movq	%rdx, %rbx
	sarq	$3, %rbx
	movsd	(%rbx), %xmm4
	addsd	(%rax), %xmm4
	leaq	_ST5(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	(%rax), %rax
	sarq	$3, %rax
	addsd	(%rax), %xmm4
	xorq	%rbx, %rbx
	xorq	%rbx, %rbx
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -8(%rbp)
	movq	$17, -16(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	leaq	_ST4(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -24(%rbp)
	leaq	-24(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$0, %r15
	movq	-24(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-32(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-16(%rbp), %rsp
	movq	%rax, %rdx
	movsd	_DB87(%rip), %xmm4
	movsd	%xmm4, %xmm0
	movq	%rdx, %rbx
	sarq	$3, %rbx
	movsd	(%rbx), %xmm4
	subsd	%xmm0, %xmm4
	xorq	%rbx, %rbx
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -24(%rbp)
	leaq	_ST88(%rip), %rax
	leaq	2(, %rax, 8), %rdx
	movq	%rdx, -32(%rbp)
	subq	$16, %rsp
	call	_prep_gc
_IF3:
	movq	-24(%rbp), %rdx
	movsd	_DB13(%rip), %xmm4
	movsd	%xmm4, (%r12)
	movq	%rdx, %rbx
	leaq	6(, %r12, 8), %rax
	addq	$8, %r12
	call	_lt
	xorq	%rbx, %rbx
_TH3:
	cmpq	$1, %rax
	jz	_FI3
	cmpq	$17, %rax
	jz	_FI3
	leaq	-24(%rbp), %rdx
	movq	%rdx, -40(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -40(%rbp)
	movsd	_DB13(%rip), %xmm4
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -48(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	$-5, %rax
	movq	$-1, %rbx
	call	_transfer
_FI3:
	leaq	-32(%rbp), %rsp
	movsd	_DB14(%rip), %xmm4
	movq	$129, -40(%rbp)
	movsd	%xmm4, %xmm0
	movsd	%xmm0, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -48(%rbp)
	movq	%xmm0, -56(%rbp)
	movq	-24(%rbp), %rax
	sarq	$3, %rax
	movq	(%rax), %r15
	movq	%r15, -64(%rbp)
	movsd	_DB14(%rip), %xmm4
	movsd	%xmm4, -72(%rbp)
	movsd	-56(%rbp), %xmm0
_FRC3:
	leaq	-72(%rbp), %rsp
	xorpd	%xmm1, %xmm1
	cmpsd	$6, -72(%rbp), %xmm1
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_FRN3
	movsd	%xmm0, %xmm1
	cmpsd	$6, -64(%rbp), %xmm1
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_FRE3
	jmp	_FRS3
_FRN3:	movsd	%xmm0, %xmm1
	cmpsd	$1, -64(%rbp), %xmm1
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_FRE3
_FRS3:
	call	_prep_gc
	leaq	-32(%rbp), %rdx
	movq	%rdx, -80(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -80(%rbp)
	movq	-32(%rbp), %rdx
	leaq	_ST89(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	subq	$8, %rsp
	call	_concat
	xorq	%rbx, %rbx
	movq	%rax, -88(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	$-10, %rax
	movq	$-1, %rbx
	call	_transfer
	movsd	-72(%rbp), %xmm1
	movsd	-56(%rbp), %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -56(%rbp)
	movq	-48(%rbp), %rax
	sarq	$3, %rax
	movsd	%xmm0, (%rax)
	jmp	_FRC3
_FRE3:
	leaq	-32(%rbp), %rsp
	leaq	_ST25(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %rdx
	leaq	_ST30(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -40(%rbp)
	leaq	_ST90(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	leaq	_ST35(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	subq	$8, %rsp
	call	_index	
	movq	-32(%rbp), %rsi
	movq	(%rax), %rdx
	leaq	_ST36(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -48(%rbp)
	movq	%rsi, -56(%rbp)
	movq	%rdi, -64(%rbp)
	leaq	_ST91(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	leaq	-64(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	-8(%rbp), %rsi
	movq	$2, %r15
	movq	-48(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-72(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	movq	-64(%rbp), %rdi
	movq	-56(%rbp), %rsi
	leaq	-40(%rbp), %rsp
	movq	%rax, %rdx
	leaq	_ST92(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	leaq	_ST35(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %r8
	leaq	_ST36(%rip), %rax
	leaq	2(, %rax, 8), %r9
	movq	%r9, %rax
	movq	%r8, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -48(%rbp)
	movq	%rcx, -56(%rbp)
	movq	%rdx, -64(%rbp)
	movq	%rsi, -72(%rbp)
	movq	%rdi, -80(%rbp)
	leaq	_ST91(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	subq	$40, %rsp
	leaq	_ST7(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	(%rax), %rsi
	movq	$2, %r15
	movq	-48(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-88(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	movq	-80(%rbp), %rdi
	movq	-72(%rbp), %rsi
	movq	-64(%rbp), %rdx
	movq	-56(%rbp), %rcx
	leaq	-40(%rbp), %rsp
	movq	%rax, %r8
	leaq	_ST93(%rip), %rax
	leaq	2(, %rax, 8), %r9
	movq	%r9, %rax
	movq	%r8, %rbx
	call	_concat
	movq	%rcx, %rbx
	call	_concat
	xorq	%rbx, %rbx
	movq	%rdx, %rbx
	call	_concat
	xorq	%rbx, %rbx
	movq	%rsi, %rbx
	call	_concat
	xorq	%rbx, %rbx
	movq	%rdi, %rbx
	call	_concat
	xorq	%rbx, %rbx
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	%rax, %rdi
	movq	$1, %r15
	movq	-40(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-48(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-32(%rbp), %rsp
	leaq	_ST25(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %rdx
	leaq	_ST30(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -40(%rbp)
	leaq	_ST94(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	leaq	_ST35(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	subq	$8, %rsp
	call	_index	
	movq	(%rax), %rsi
	leaq	_ST36(%rip), %rax
	leaq	2(, %rax, 8), %rdx
	movq	%rdx, %rax
	movq	%rsi, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -48(%rbp)
	movq	%rdi, -56(%rbp)
	leaq	_ST95(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	subq	$16, %rsp
	leaq	_ST8(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	(%rax), %rsi
	movq	$2, %r15
	movq	-48(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-64(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	movq	-56(%rbp), %rdi
	leaq	-40(%rbp), %rsp
	movq	%rax, %rsi
	leaq	_ST96(%rip), %rax
	leaq	2(, %rax, 8), %rdx
	leaq	_ST35(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %rcx
	leaq	_ST36(%rip), %rax
	leaq	2(, %rax, 8), %r8
	movq	%r8, %rax
	movq	%rcx, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%rdi, -72(%rbp)
	leaq	_ST95(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	subq	$32, %rsp
	leaq	_ST9(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	(%rax), %rsi
	movq	$2, %r15
	movq	-48(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-80(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	movq	-72(%rbp), %rdi
	movq	-64(%rbp), %rsi
	movq	-56(%rbp), %rdx
	leaq	-40(%rbp), %rsp
	movq	%rax, %rcx
	leaq	_ST97(%rip), %rax
	leaq	2(, %rax, 8), %r8
	leaq	_ST35(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %r9
	leaq	_ST36(%rip), %rax
	leaq	2(, %rax, 8), %r10
	movq	%r10, %rax
	movq	%r9, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -48(%rbp)
	movq	%r8, -56(%rbp)
	movq	%rcx, -64(%rbp)
	movq	%rdx, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	%rdi, -88(%rbp)
	leaq	_ST95(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	subq	$48, %rsp
	leaq	_ST5(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	(%rax), %rsi
	movq	$2, %r15
	movq	-48(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-96(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	movq	-88(%rbp), %rdi
	movq	-80(%rbp), %rsi
	movq	-72(%rbp), %rdx
	movq	-64(%rbp), %rcx
	movq	-56(%rbp), %r8
	leaq	-40(%rbp), %rsp
	movq	%rax, %r9
	leaq	_ST98(%rip), %rax
	leaq	2(, %rax, 8), %r10
	movq	%r10, %rax
	movq	%r9, %rbx
	call	_concat
	movq	%r8, %rbx
	call	_concat
	xorq	%rbx, %rbx
	movq	%rcx, %rbx
	call	_concat
	xorq	%rbx, %rbx
	movq	%rdx, %rbx
	call	_concat
	xorq	%rbx, %rbx
	movq	%rsi, %rbx
	call	_concat
	xorq	%rbx, %rbx
	movq	%rdi, %rbx
	call	_concat
	xorq	%rbx, %rbx
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	%rax, %rdi
	movq	$1, %r15
	movq	-40(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-48(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-32(%rbp), %rsp
	leaq	-16(%rbp), %rdx
	movq	%rdx, -40(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -40(%rbp)
	subq	$8, %rsp
	movq	-8(%rbp), %rdx
	leaq	_ST7(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	(%rax), %rax
	sarq	$3, %rax
	movq	%rdx, %rbx
	sarq	$3, %rbx
	movsd	(%rbx), %xmm4
	divsd	(%rax), %xmm4
	movsd	_DB99(%rip), %xmm5
	movq	-24(%rbp), %rax
	sarq	$3, %rax
	addsd	(%rax), %xmm5
	mulsd	%xmm5, %xmm4
	xorq	%rbx, %rbx
	xorq	%rbx, %rbx
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -48(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	$-5, %rax
	movq	$-1, %rbx
	call	_transfer
	movsd	_DB14(%rip), %xmm4
	movq	$129, -40(%rbp)
	movsd	%xmm4, %xmm0
	movsd	%xmm0, (%r12)
	leaq	6(, %r12, 8), %r15
	addq	$8, %r12
	movq	%r15, -48(%rbp)
	movq	%xmm0, -56(%rbp)
	movsd	_DB99(%rip), %xmm4
	movq	-24(%rbp), %rax
	sarq	$3, %rax
	addsd	(%rax), %xmm4
	movsd	%xmm4, -64(%rbp)
	movsd	_DB14(%rip), %xmm4
	movsd	%xmm4, -72(%rbp)
	movsd	-56(%rbp), %xmm0
_FRC4:
	leaq	-72(%rbp), %rsp
	xorpd	%xmm1, %xmm1
	cmpsd	$6, -72(%rbp), %xmm1
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_FRN4
	movsd	%xmm0, %xmm1
	cmpsd	$6, -64(%rbp), %xmm1
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_FRE4
	jmp	_FRS4
_FRN4:	movsd	%xmm0, %xmm1
	cmpsd	$1, -64(%rbp), %xmm1
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_FRE4
_FRS4:
	call	_prep_gc
_IF4:
	movq	-48(%rbp), %rdx
	movq	-16(%rbp), %rax
	movq	%rdx, %rbx
	call	_lte
	xorq	%rbx, %rbx
_TH4:
	cmpq	$1, %rax
	jz	_EL4
	cmpq	$17, %rax
	jz	_EL4
	leaq	_ST25(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %rdx
	leaq	_ST30(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -80(%rbp)
	leaq	_ST100(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	leaq	-80(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$1, %r15
	movq	-80(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-88(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-72(%rbp), %rsp
	jmp	_FI4
_EL4:
	leaq	_ST25(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %rdx
	leaq	_ST30(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -80(%rbp)
	leaq	_ST101(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	leaq	-80(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$1, %r15
	movq	-80(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-88(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-72(%rbp), %rsp
_FI4:
	leaq	-72(%rbp), %rsp
	movsd	-72(%rbp), %xmm1
	movsd	-56(%rbp), %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -56(%rbp)
	movq	-48(%rbp), %rax
	sarq	$3, %rax
	movsd	%xmm0, (%rax)
	jmp	_FRC4
_FRE4:
	leaq	-32(%rbp), %rsp
	leaq	_ST25(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %rdx
	leaq	_ST30(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -40(%rbp)
	leaq	_ST102(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	leaq	_ST35(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	subq	$8, %rsp
	call	_index	
	movq	(%rax), %rsi
	leaq	_ST36(%rip), %rax
	leaq	2(, %rax, 8), %rdx
	movq	%rdx, %rax
	movq	%rsi, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -48(%rbp)
	movq	%rdi, -56(%rbp)
	leaq	_ST103(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	movq	-16(%rbp), %rsi
	movsd	_DB99(%rip), %xmm4
	movq	-24(%rbp), %rax
	sarq	$3, %rax
	addsd	(%rax), %xmm4
	movsd	%xmm4, %xmm0
	movq	%rsi, %rbx
	sarq	$3, %rbx
	movsd	(%rbx), %xmm4
	divsd	%xmm0, %xmm4
	xorq	%rbx, %rbx
	movsd	_DB38(%rip), %xmm5
	mulsd	%xmm5, %xmm4
	xorq	%rbx, %rbx
	xorq	%rbx, %rbx
	leaq	-56(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %rsi
	addq	$8, %r12
	movq	$2, %r15
	movq	-48(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-64(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	movq	-56(%rbp), %rdi
	leaq	-40(%rbp), %rsp
	movq	%rax, %rsi
	leaq	_ST104(%rip), %rax
	leaq	2(, %rax, 8), %rdx
	leaq	_ST35(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %rcx
	leaq	_ST36(%rip), %rax
	leaq	2(, %rax, 8), %r8
	movq	%r8, %rax
	movq	%rcx, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%rdi, -72(%rbp)
	leaq	_ST105(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	leaq	_ST3(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	subq	$32, %rsp
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -80(%rbp)
	movq	%rdi, -88(%rbp)
	leaq	-88(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$0, %r15
	movq	-80(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-96(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	movq	-88(%rbp), %rdi
	leaq	-72(%rbp), %rsp
	movq	%rax, %rsi
	leaq	_ST6(%rip), %rax
	leaq	2(, %rax, 8), %rax
	call	_clo_ref
	movq	(%rax), %rax
	sarq	$3, %rax
	movq	%rsi, %rbx
	sarq	$3, %rbx
	movsd	(%rbx), %xmm4
	subsd	(%rax), %xmm4
	movsd	_DB106(%rip), %xmm5
	divsd	%xmm5, %xmm4
	xorq	%rbx, %rbx
	xorq	%rbx, %rbx
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %rsi
	addq	$8, %r12
	movq	$2, %r15
	movq	-48(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-80(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	movq	-72(%rbp), %rdi
	movq	-64(%rbp), %rsi
	movq	-56(%rbp), %rdx
	leaq	-40(%rbp), %rsp
	movq	%rdx, %rbx
	call	_concat
	movq	%rsi, %rbx
	call	_concat
	xorq	%rbx, %rbx
	movq	%rdi, %rbx
	call	_concat
	xorq	%rbx, %rbx
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	%rax, %rdi
	movq	$1, %r15
	movq	-40(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-48(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-32(%rbp), %rsp
	leaq	_ST25(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	call	_index	
	movq	(%rax), %rdx
	leaq	_ST30(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -40(%rbp)
	leaq	_ST107(%rip), %rax
	leaq	2(, %rax, 8), %rdi
	leaq	-40(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$1, %r15
	movq	-40(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-48(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-32(%rbp), %rsp
	movq	$17, %rax
	leave
	ret
	.byte	0x0F, 0x90
_FE5:

	.align	8
_FN6:
	movq	$1, %rax
	call	_nil_fill
	call	_prep_gc
getexpresult:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, -8(%rbp)
	leaq	_ST25(%rip), %rax
	leaq	2(, %rax, 8), %rax
	movq	%r13, %rbx
	subq	$8, %rsp
	call	_index	
	movq	(%rax), %rdx
	leaq	_ST108(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_index	
	movq	(%rax), %r15
	movq	%r15, -16(%rbp)
	movq	-8(%rbp), %rdi
	leaq	_ST109(%rip), %rax
	leaq	2(, %rax, 8), %rsi
	leaq	-16(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$2, %r15
	movq	-16(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-24(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-8(%rbp), %rsp
	movq	%rax, -16(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	-16(%rbp), %rdx
	leaq	_ST27(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	pushq	%rbx
	call	_index	
	popq	%rdx
	movq	(%rax), %r15
	movq	%r15, -24(%rbp)
	movq	%rdx, %rdi
	leaq	_ST110(%rip), %rax
	leaq	2(, %rax, 8), %rsi
	leaq	-24(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$2, %r15
	movq	-24(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-32(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-16(%rbp), %rsp
	movq	%rax, -24(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	leaq	_ST88(%rip), %rax
	leaq	2(, %rax, 8), %rdx
	movq	%rdx, -32(%rbp)
	subq	$8, %rsp
	call	_prep_gc
_WH1:
	leaq	-32(%rbp), %rsp
	call	_prep_gc
	movq	-24(%rbp), %rdx
	movq	$17, %rax
	movq	%rdx, %rbx
	call	_neq
	xorq	%rbx, %rbx
_WD1:
	cmpq	$1, %rax
	jz	_WE1
	cmpq	$17, %rax
	jz	_WE1
_IF5:
	movq	-24(%rbp), %rdx
	leaq	_ST20(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	pushq	%rbx
	call	_index	
	popq	%rdx
	movq	(%rax), %r15
	movq	%r15, -40(%rbp)
	movq	%rdx, %rdi
	movsd	_DB14(%rip), %xmm4
	movsd	_DB111(%rip), %xmm5
	leaq	-40(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movsd	%xmm5, (%r12)
	leaq	6(, %r12, 8), %rdx
	addq	$8, %r12
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %rsi
	addq	$8, %r12
	movq	$3, %r15
	movq	-40(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-48(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-32(%rbp), %rsp
	movq	%rax, %rdx
	leaq	_ST112(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_compare
	xorq	%rbx, %rbx
_TH5:
	cmpq	$1, %rax
	jz	_EL5
	cmpq	$17, %rax
	jz	_EL5
	leaq	-32(%rbp), %rdx
	movq	%rdx, -40(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -40(%rbp)
	movq	-32(%rbp), %rdx
	movq	-24(%rbp), %rcx
	leaq	_ST20(%rip), %rax
	leaq	2(, %rax, 8), %r8
	movq	%r8, %rax
	movq	%rcx, %rbx
	subq	$8, %rsp
	pushq	%rbx
	call	_index	
	popq	%rcx
	movq	(%rax), %r15
	movq	%r15, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movq	%rcx, %rdi
	movsd	_DB113(%rip), %xmm4
	subq	$16, %rsp
	movq	-24(%rbp), %rax
	sarq	$3, %rax
	cmpq	$-1, (%rax)
	jnz	_LU114
	call	_check
_LU114:	cvtsi2sd (%rax), %xmm0
	movsd	%xmm0, %xmm5
	xorq	%rbx, %rbx
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movsd	%xmm5, (%r12)
	leaq	6(, %r12, 8), %rdx
	addq	$8, %r12
	movsd	%xmm4, (%r12)
	leaq	6(, %r12, 8), %rsi
	addq	$8, %r12
	movq	$3, %r15
	movq	-48(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-64(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	movq	-56(%rbp), %rdx
	leaq	-40(%rbp), %rsp
	movq	%rdx, %rbx
	call	_concat
	xorq	%rbx, %rbx
	movq	%rax, -48(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	$-5, %rax
	movq	$-1, %rbx
	call	_transfer
	leaq	-24(%rbp), %rdx
	movq	%rdx, -40(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -40(%rbp)
	movq	-16(%rbp), %rdx
	leaq	_ST27(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	addq	$8, %rsp
	pushq	%rbx
	call	_index	
	popq	%rdx
	movq	(%rax), %r15
	movq	%r15, -48(%rbp)
	movq	%rdx, %rdi
	leaq	_ST110(%rip), %rax
	leaq	2(, %rax, 8), %rsi
	leaq	-48(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$2, %r15
	movq	-48(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-56(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-40(%rbp), %rsp
	movq	%rax, -48(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	$-5, %rax
	movq	$-1, %rbx
	call	_transfer
_IF6:
	movq	-24(%rbp), %rdx
	movq	$17, %rax
	movq	%rdx, %rbx
	addq	$16, %rsp
	call	_neq
	xorq	%rbx, %rbx
_TH6:
	cmpq	$1, %rax
	jz	_FI6
	cmpq	$17, %rax
	jz	_FI6
	leaq	-32(%rbp), %rdx
	movq	%rdx, -40(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -40(%rbp)
	movq	-32(%rbp), %rdx
	leaq	_ST115(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	subq	$8, %rsp
	call	_concat
	xorq	%rbx, %rbx
	movq	%rax, -48(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	$-5, %rax
	movq	$-1, %rbx
	call	_transfer
_FI6:
	leaq	-32(%rbp), %rsp
	jmp	_FI5
_EL5:
_IF7:
	movq	-24(%rbp), %rdx
	leaq	_ST88(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	call	_neq
	xorq	%rbx, %rbx
_TH7:
	cmpq	$1, %rax
	jz	_EL7
	cmpq	$17, %rax
	jz	_EL7
	leaq	-32(%rbp), %rdx
	movq	%rdx, -40(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -40(%rbp)
	leaq	_ST88(%rip), %rax
	leaq	2(, %rax, 8), %rdx
	movq	%rdx, -48(%rbp)
	subq	$16, %rsp
	call	_prep_gc
	movq	$-5, %rax
	movq	$-1, %rbx
	call	_transfer
	leaq	-24(%rbp), %rdx
	movq	%rdx, -40(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -40(%rbp)
	movq	-16(%rbp), %rdx
	leaq	_ST27(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	addq	$8, %rsp
	pushq	%rbx
	call	_index	
	popq	%rdx
	movq	(%rax), %r15
	movq	%r15, -48(%rbp)
	movq	%rdx, %rdi
	leaq	_ST110(%rip), %rax
	leaq	2(, %rax, 8), %rsi
	leaq	-48(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$2, %r15
	movq	-48(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-56(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-40(%rbp), %rsp
	movq	%rax, -48(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	$-5, %rax
	movq	$-1, %rbx
	call	_transfer
	jmp	_FI7
_EL7:
	leaq	-24(%rbp), %rdx
	movq	%rdx, -40(%rbp)
	movq	_trf_mask(%rip), %rax
	xorq	%rax, -40(%rbp)
	movq	-16(%rbp), %rdx
	leaq	_ST27(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	subq	$8, %rsp
	pushq	%rbx
	call	_index	
	popq	%rdx
	movq	(%rax), %r15
	movq	%r15, -48(%rbp)
	movq	%rdx, %rdi
	leaq	_ST110(%rip), %rax
	leaq	2(, %rax, 8), %rsi
	leaq	-48(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$2, %r15
	movq	-48(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-56(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-40(%rbp), %rsp
	movq	%rax, -48(%rbp)
	subq	$8, %rsp
	call	_prep_gc
	movq	$-5, %rax
	movq	$-1, %rbx
	call	_transfer
_FI7:
	leaq	-32(%rbp), %rsp
_FI5:
	leaq	-32(%rbp), %rsp
	jmp	_WH1
_WE1:
	leaq	-32(%rbp), %rsp
	movq	-16(%rbp), %rdx
	leaq	_ST29(%rip), %rax
	leaq	2(, %rax, 8), %rcx
	movq	%rcx, %rax
	movq	%rdx, %rbx
	pushq	%rbx
	call	_index	
	popq	%rdx
	movq	(%rax), %r15
	movq	%r15, -40(%rbp)
	movq	%rdx, %rdi
	leaq	-40(%rbp), %rsp
	leaq	4(, %r14, 8), %r14
	pushq	%r14
	movq	$1, %r15
	movq	-40(%rbp), %rax
	sarq	$3, %rax
	movq	8(%rax), %r14
	.align	8
	.fill	6, 1, 0x90
	callq	*(%rax)
	movq	-48(%rbp), %r14
	sarq	$3, %r14
	call	_clear_regs
	leaq	-32(%rbp), %rsp
	xorq	%rbx, %rbx
	movq	-32(%rbp), %rax
	leave
	ret
	.byte	0x0F, 0x90
_FE6:


# DATA
################################################################################

	.data

_ST1:
	.quad	7
	.asciz	"listlua"
_ST2:
	.quad	7
	.asciz	"listexe"
_ST3:
	.quad	7
	.asciz	"gettime"
_ST4:
	.quad	8
	.asciz	"getwidth"
_ST5:
	.quad	4
	.asciz	"unkn"
_ST6:
	.quad	4
	.asciz	"time"
_ST7:
	.quad	5
	.asciz	"total"
_ST8:
	.quad	4
	.asciz	"pass"
_ST9:
	.quad	4
	.asciz	"fail"
_ST10:
	.quad	8
	.asciz	"progress"
_ST11:
	.quad	12
	.asciz	"getexpresult"
_DB13:
	.double	0
_DB14:
	.double	1
_ST16:
	.quad	2
	.asciz	"os"
_ST17:
	.quad	7
	.asciz	"execute"
_ST18:
	.quad	10
	.asciz	"./luna -s "
_ST19:
	.quad	13
	.asciz	" &> /dev/null"
_ST20:
	.quad	3
	.asciz	"sub"
_DB22:
	.double	4
_ST23:
	.quad	4
	.asciz	".exe"
_ST25:
	.quad	2
	.asciz	"io"
_ST26:
	.quad	5
	.asciz	"popen"
_ST27:
	.quad	4
	.asciz	"read"
_ST28:
	.quad	3
	.asciz	"all"
_ST29:
	.quad	5
	.asciz	"close"
_ST30:
	.quad	5
	.asciz	"write"
_ST31:
	.quad	8
	.asciz	"\27[2B\r"
_ST32:
	.quad	5
	.asciz	"print"
_ST33:
	.quad	21
	.asciz	"ALL UNIT TESTS PASSED"
_ST34:
	.quad	8
	.asciz	"tostring"
_ST35:
	.quad	6
	.asciz	"string"
_ST36:
	.quad	6
	.asciz	"format"
_ST37:
	.quad	4
	.asciz	"%.1f"
_DB38:
	.double	100
_ST49:
	.quad	23
	.asciz	"% OF UNIT TESTS FAILED:"
_ST50:
	.quad	4
	.asciz	"\t- "
_ST51:
	.quad	15
	.asciz	"ls ./unit-tests"
_ST55:
	.quad	5
	.asciz	"lines"
_ST56:
	.quad	4
	.asciz	"find"
_ST57:
	.quad	4
	.asciz	".lua"
_ST58:
	.quad	7
	.asciz	".pp.lua"
_ST59:
	.quad	5
	.asciz	".lua~"
_ST60:
	.quad	11
	.asciz	"unit-tests/"
_ST64:
	.quad	10
	.asciz	"date +%s%N"
_ST65:
	.quad	8
	.asciz	"tonumber"
_ST76:
	.quad	9
	.asciz	"tput cols"
_DB87:
	.double	66
_ST88:
	.quad	0
	.asciz	""
_ST89:
	.quad	1
	.asciz	" "
_ST90:
	.quad	34
	.asciz	"  Pass   Fail   Unkn     Progress "
_ST91:
	.quad	3
	.asciz	"%3d"
_ST92:
	.quad	3
	.asciz	" / "
_ST93:
	.quad	22
	.asciz	"     Prct       Time\n"
_ST94:
	.quad	16
	.asciz	"[ \27[1;38;5;47m"
_ST95:
	.quad	3
	.asciz	"%4d"
_ST96:
	.quad	24
	.asciz	"\27[0m | \27[1;38;5;203m"
_ST97:
	.quad	23
	.asciz	"\27[0m | \27[1;38;5;98m"
_ST98:
	.quad	11
	.asciz	"\27[0m ]  ["
_DB99:
	.double	18
_ST100:
	.quad	1
	.asciz	"#"
_ST101:
	.quad	1
	.asciz	"-"
_ST102:
	.quad	5
	.asciz	"]  [ "
_ST103:
	.quad	5
	.asciz	"%3.0f"
_ST104:
	.quad	7
	.asciz	"% ]  [ "
_ST105:
	.quad	10
	.asciz	"%5.1fs ]\n"
_DB106:
	.double	1000000000
_ST107:
	.quad	15
	.asciz	"\27[2A\27[90D\r"
_ST108:
	.quad	4
	.asciz	"open"
_ST109:
	.quad	1
	.asciz	"r"
_ST110:
	.quad	4
	.asciz	"line"
_DB111:
	.double	2
_ST112:
	.quad	2
	.asciz	"--"
_DB113:
	.double	3
_ST115:
	.quad	2
	.asciz	"\n"
