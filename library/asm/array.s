	.text
	
# ARRAY ROUTINES
################################################################################
	
	.global _array_copy
	# %rax: table
_array_copy:
	sarq	$3, %rax
	movq	16(%rax), %rbx
	movq	%r12, 16(%rax)
	movq	%rax, (%r12)
	xorq	%r15, %r15
_ac_lp:	cmpq	$33, (%rbx)
	jz	_ac_en
	movq	(%rbx), %rax
	movq	%rax, 16(%r12, %r15, 8)
	inc	%r15
	subq	$8, %rbx
	jmp	_ac_lp
_ac_en:	movq	(%r12), %rax
	movq	%r15, (%rax)
	movq	$1, %rbx
_lg_lp:	cmpq	%rbx, %r15
	jb	_lg_en
	salq	$1, %rbx
	jmp	_lg_lp
_lg_en: cmpq	%rbx, %r15
	jz	_lg_fn
	movq	$17, 16(%r12, %r15, 8)
	inc	%r15
	jmp	_lg_en
_lg_fn:	leaq	(, %rbx, 8), %rax
	movq	%rax, (%r12)
	movq	$8, 8(%r12)
	leaq	16(%r12, %rbx, 8), %r12
	ret

	
	.global	_index
	.global	_i_index
	# %rax: key, %rbx: table
_index:
	movq	%rbx, %r15
	andq	$7, %r15
	cmpq	$3, %r15
	jnz	_special
	sarq	$3, %rbx
	movq	%rax, %r15
	andq	$7, %r15
	jz	_i_index
	cmpq	$6, %r15
	jz	_i_rev
_ix_s:	movq	8(%rbx), %r15
_ix_lp:	cmpq	$17, %r15
	jz	_ix_nl
	movq	(%r15), %rbx
	pushq	%rax
	pushq	%r15
	call	_compare
	popq	%r15
	leaq	8(%r15), %rbx
	movq	8(%rbx), %r15
	cmpq	$9, %rax
	popq	%rax
	jz	_ix_ad
	jmp	_ix_lp
_ix_nl:	leaq	8(%rbx), %rax
	ret
_ix_ad:	leaq	(%rbx), %rax
	ret
_i_index:
	pushq	%rbx
	pushq	%rdi
	pushq	%rsi
	movq	16(%rbx), %rbx
	movq	(%rbx), %rdi  	
	movq	8(%rbx), %rsi 
	leaq	-8(%rax, %rsi, ), %r15
	cmpq	$8, %r15
	jl	_i_miss
	cmpq	%r15, %rdi
	jl	_i_miss
_i_rt:	leaq	8(%r15, %rbx, ), %rax
	popq	%rsi
	popq	%rdi
	popq	%rbx
	ret
_i_miss:	
	movq	$17, (%r12)
	movq	%r12, %rax
	addq	$8, %r12
	popq	%rsi
	popq	%rdi
	popq	%rbx
	ret
_i_rev:
	pushq	%rdi
	sarq	$3, %rax
	cvtsd2si (%rax), %rdi
	cvtsi2sd %rdi, %xmm3
	movq	%xmm3, %rdi
	cmpq	(%rax), %rdi
	popq	%rdi
	jz	_iv_rt
	salq	$3, %rax
	orq	%r15, %rax
	jmp	_ix_s
_iv_rt:	cvtsd2si (%rax), %rax
	salq	$3, %rax
	jmp	_i_index
	
	.global _new
	# %rax: key, %rbx: table
_new:
	sarq	$3, %rbx
	movq	%rax, %r15
	andq	$7, %r15
	jz	_i_new
	cmpq	$6, %r15
	jz	_n_rev
_nw_s:	pushq	%rax
	call	_ix_s
	cmpq	$17, (%rax)
	jnz	_nw_rt
	cmpq	%rax, %rbx
	jz	_nw_rt
	movq	%r12, (%rax)
	popq	(%r12)
	leaq	8(%r12), %rax
	movq	$17, 8(%r12)
	movq	$17, 16(%r12)
	addq	$24, %r12
	ret
_nw_rt:	addq	$8, %rsp
	ret
_i_new:
	push	%rbx
	pushq	%rdi
	pushq	%rsi
	movq	$-1, (%rbx)
	movq	16(%rbx), %rbx
	movq	(%rbx), %rdi
	movq	8(%rbx), %rsi	
	leaq	-8(%rax, %rsi, ), %r15
	cmpq	$8, %r15
	jl	_n_underflow
	cmpq	%r15, %rdi
	jl	_n_overflow
_n_rt:	leaq	8(%r15, %rbx, ), %rax
	popq	%rsi
	popq	%rdi
	popq	%rbx
	ret
_n_underflow:
	pushq	%rdx
	pushq	%rcx
	movq	%rdi, %rdx
	movq	%rsi, %rcx
_os_lp:	salq	$1, %rcx
	leaq	-8(%rax, %rcx, ), %r15
	cmpq	$8, %r15
	jl	_os_lp
	leaq	-8(%rcx, %rdi, ), %r15
	jmp	_ca_lp
_n_overflow:
	pushq	%rdx
	pushq	%rcx
	movq	%rdi, %rdx # CAPACITY
	movq	%rsi, %rcx # OFFSET
_ca_lp:	salq	$1, %rdx
	cmpq	%r15, %rdx
	jb	_ca_lp
	# nil fil up start
	pushq	%rax
	movq	%rcx, %r15
	subq	%rsi, %r15
	leaq	8(%rdx), %rax         # Upper limit of new area
	leaq	8(%rdi, %r15, ), %r15 # Position of last copied element
_over_nil_fil:
	movq	$17, (%r12, %rax, )
	subq	$8, %rax
	cmpq	%rax, %r15
	jnz	_over_nil_fil
	# nil fil down start
	movq	%rcx, %r15
	subq	%rsi, %r15
	movq	$8, %rax       # Lower limit of new area (- 1)
	leaq	8(%r15), %r15  # Position of first copied element (- 1)
_under_nil_fil:
	cmpq	%rax, %r15
	jz	_mem_copy
	movq	$17, (%r12, %r15, )
	subq	$8, %r15
	jmp	_under_nil_fil
_mem_copy:
	popq	%rax
	pushq	%r8
	movq	%rdx, (%r12)
	movq	%rcx, 8(%r12)
	leaq	8(%r12, %rcx, ), %r8
	subq	%rsi, %r8
_mm_lp:	cmpq	$0, %rdi
	jz	_mm_en
	movq	8(%rdi, %rbx, ), %r15 # LAST OF OLD
	movq	%r15, (%rdi, %r8)
	subq	$8, %rdi
	jmp	_mm_lp
_mm_en:	movq	40(%rsp), %r8
	movq	%r12, 16(%r8)
	movq	%r12, %rbx
	leaq	16(%rdx, %r12, ), %r12
	leaq	-8(%rax, %rcx, ), %r15
	popq	%r8
	popq	%rcx
	popq	%rdx
	jmp	_n_rt

_n_rev:
	pushq	%rdi
	sarq	$3, %rax
	cvtsd2si (%rax), %rdi
	cvtsi2sd %rdi, %xmm3
	movq	%xmm3, %rdi
	cmpq	(%rax), %rdi
	popq	%rdi
	jz	_nv_rt
	salq	$3, %rax
	orq	%r15, %rax
	jmp	_nw_s
_nv_rt:	cvtsd2si %xmm3, %rax
	salq	$3, %rax
	jmp	_i_new

	.global _check
	# %rax: table
_check:	
	pushq	%rax
	movq	16(%rax), %rax
	xorq	%rbx, %rbx
	movq	(%rax), %r15
	leaq	16(%r15, %rax, ), %r15
	addq	8(%rax), %rax
	addq	$8, %rax
_ch_lp:	cmpq	$17, (%rax)
	jz	_ch_en
	cmpq	%rax, %r15
	jz	_ch_en
	addq	$8, %rax
	inc	%rbx
	jmp	_ch_lp
_ch_en:	popq	%rax
	movq	%rbx, (%rax)
	ret

	.global _set_size
	# %rax: size (int), %rbx: table
_set_size: 
	sarq	$3, %rbx
	pushq	%rbx
	pushq	%rax
	salq	$3, %rax
	call	_i_new
	popq	%rax
	popq	%rbx
	movq	%rax, (%rbx)
	ret

	.global _append
	# %rax: value, %rbx:table
_append:
	pushq	%rax
	sarq	$3, %rbx
	cmpq	$-1, (%rbx)
	jnz	_append_elem
	movq	%rbx, %rax
	call	_check
	movq	%rax, %rbx
_append_elem:	
	movq	(%rbx), %rax
	incq	%rax
	pushq	%rax
	pushq	%rbx
	salq	$3, %rax
	call	_i_new
	popq	%rbx
	popq	%r15
	movq	%r15, (%rbx)
	popq	%rbx
	movq	%rbx, (%rax)
	ret
	
# CLOSURE ROUTINES
################################################################################

	.global _encl
	# %rax: key, %rbx: value0
_encl:
	movq	$0, (%r12)
	movq	%rax, 8(%r12)
	movq	%rbx, 16(%r12)
	movq	%r14, 24(%r12)
	movq	%r12, %r14
	addq	$32, %r12
	ret

	.global _clo_ref
	# %rax: key
_clo_ref:
	pushq	%r14
	pushq	%rdi
	movq	%rax, %rdi
_cr_lp:	movq	%rdi, %rax
	movq	8(%r14), %rbx
	call	_compare
	cmpq	$9, %rax
	jz	_cr_en
	movq	24(%r14), %r14
	cmpq	$17, %r14
	jz	_cr_en
	jmp	_cr_lp
_cr_en:	leaq	16(%r14), %rax
	popq	%rdi
	popq	%r14
	ret
/**************************************
#	.global _open
#	# %rax: size
#	# NB: Open will not be used in the code, freeing will be done by the GC
#_open:
#	cmpq	$0, %rax
#	jz	_op_en
#	dec	%rax
#	movq	24(%r14), %r14
#	jmp	_open
#_op_en:	ret
****************************************/
