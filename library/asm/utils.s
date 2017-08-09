	.text
# Internal routines to reduce compiled file size

#MEMORY ROUTINES
	.global _transfer
	# %rax: frame size, %rbx: transfer size
_transfer:
	movq	%rdi, -8(%rsp)
_tf_lp:	movq	(%rbp, %rax, 8), %rdi
	leaq	(%rax, %rbx, ), %r15
	leaq	(%rbp, %r15, 8), %r15
	cmp	%r15, %rsp
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
	pushq	%r12
	pushq	%rax
	pushq	%r14
	subq	%r15, %rax
	negq	%rax
	leaq	8(%r12, %rax, 8), %r12
	movq	8(%rsp), %rax
	movq	%r12, 16(%rsp)
	leaq	-6(%rax), %rbx
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
_rs_lp:	cmp	$0, %rbx
	jz	_rs_dn
	movq	(%rsp), %r15
	movq	%r15, (%rsp, %rax, 8)
	dec	%rbx
	addq	$8, %rsp
	jmp	_rs_lp
_rs_dn:	movq	%rdi, %rsp
_rs_fn:	pop	%r15
	pop	%rdi
	pop	%rax
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

#BOOLEAN ROUTINES
	.global	_compare
	# %rax: arg1, %rbx: arg2
_compare:
	movq	%rax, %r15
	andq	$7, %r15
	cmpq	$2, %r15
	jz	_comp_string
	cmpq	%rax, %rbx
	jz	_res_t
	movq	$1, %rax
	ret
_res_t:	movq	$9, %rax
	ret

_comp_string:
	movq	%rbx, %r15
	andq	$7, %r15
	cmpq	$2, %r15
	jnz	_cp_f
	sarq	$3, %rax
	sarq	$3, %rbx
	movq	(%rax), %r15
	cmpq	%r15, (%rbx)
	jnz	_cp_f
	addq	$8, %rax
	addq	$8, %rbx
_cp_lp:	xorq	%r15, %r15
	mov	(%rbx), %r15b
	cmp	(%rax), %r15b
	jnz	_cp_f
	cmp	$0, %r15b
	jz	_cp_t
	cmpl	$0, (%rax)
	jz	_cp_f
	inc	%rax
	inc	%rbx
	jmp	_cp_lp
_cp_f:	movq	$1, %rax
	ret
_cp_t:	movq	$9, %rax
	ret

	.global	_gt
	# %rax: arg1, %rbx: arg2
_gt:
	movq	%rax, %r15
	andq	$7, %r15
	cmpq	$2, %r15
	jz	_comp_s_g
	cmpq	%rax, %rbx
	jb	_rs_gt
	movq	$1, %rax
	ret
_rs_gt:	movq	$9, %rax
	ret

_comp_s_g:	
	movq	%rbx, %r15
	andq	$7, %r15
	cmpq	$2, %r15
	jnz	_gt_f
	sarq	$3, %rax
	sarq	$3, %rbx
	movq	(%rax), %r15
	cmpq	%r15, (%rbx)
	jnz	_gt_f
	addq	$8, %rax
	addq	$8, %rbx
_gt_lp:	xorq	%r15, %r15
	mov	(%rbx), %r15b
	cmp	(%rax), %r15b
	jge	_gt_f
	cmp	$0, %r15b
	jz	_gt_t
	cmpl	$0, (%rax)
	jz	_gt_f
	inc	%rax
	inc	%rbx
	jmp	_gt_lp
_gt_f:	movq	$1, %rax
	ret
_gt_t:	movq	$9, %rax
	ret

	
	.global	_lt
	# %rax: arg1, %rbx: arg2
_lt:
	movq	%rax, %r15
	andq	$7, %r15
	cmpq	$2, %r15
	jz	_comp_s_l
	cmpq	%rax, %rbx
	jg	_rs_lt
	movq	$1, %rax
	ret
_rs_lt:	movq	$9, %rax
	ret

_comp_s_l:	
	movq	%rbx, %r15
	andq	$7, %r15
	cmpq	$2, %r15
	jnz	_lt_f
	sarq	$3, %rax
	sarq	$3, %rbx
	movq	(%rax), %r15
	cmpq	%r15, (%rbx)
	jnz	_lt_f
	addq	$8, %rax
	addq	$8, %rbx
_lt_lp:	xorq	%r15, %r15
	mov	(%rbx), %r15b
	cmp	(%rax), %r15b
	jge	_lt_f
	cmp	$0, %r15b
	jz	_lt_t
	cmpl	$0, (%rax)
	jz	_lt_f
	inc	%rax
	inc	%rbx
	jmp	_lt_lp
_lt_f:	movq	$1, %rax
	ret
_lt_t:	movq	$9, %rax
	ret

	.global _not
_not:
	cmpq	$1, %rax
	jz	_nt_t
	cmpq	$17, %rax
	jz	_nt_t
	movq	$1, %rax
	ret
_nt_t:	movq	$9, %rax
	ret

#ARRAY ROUTINES
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
	# %rax: key, %rbx: table
_index:
	sarq	$3, %rbx
	movq	%rax, %r15
	andq	$7, %r15
	jz	_i_index
	cmpq	$6, %r15
	jz	_i_rev
_ix_s:	movq	8(%rbx), %r15
_ix_lp:	cmpq	$17, %r15
	jz	_ix_nl
	sarq	$3, %r15
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
_ix_nl:	addq	$8, %rbx
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
	jb	_i_miss
	cmpq	%r15, %rdi
	jb	_i_miss
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
	roundsd	$0, (%rax), %xmm3
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
	leaq	4(, %r12, 8), %rbx
	movq	%rbx, (%rax)
	popq	(%r12)
	leaq	8(%r12), %rax
	movq	$17, 8(%r12)
	movq	$17, 16(%r12)
	addq	$24, %r12
	ret
_nw_rt:	add	$8, %rsp
	ret
_i_new:
	push	%rbx
	pushq	%rdi
	pushq	%rsi
	movq	$65, (%rbx)
	movq	16(%rbx), %rbx
	movq	(%rbx), %rdi
	movq	8(%rbx), %rsi	
	leaq	-8(%rax, %rsi, ), %r15
	cmpq	$8, %r15
	jb	_n_underflow
	cmpq	%r15, %rdi
	jb	_n_overflow
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
	jb	_os_lp
	leaq	(%rcx, %rdi, ), %r15
_ca_lp:	salq	$1, %rdx
	cmpq	%r15, %rdx
	jb	_ca_lp
	jmp	_mem_copy
_n_overflow:
	pushq	%rdx
	pushq	%rcx
	movq	%rdi, %rdx
	movq	%rsi, %rcx
	leaq	(%rcx, %rdi, ), %r15
	jmp	_ca_lp
_mem_copy:
	pushq	%r8
	movq	%rdx, (%r12)
	movq	%rcx, 8(%r12)
	leaq	16(%r12, %rcx, ), %r8
	subq	%rsi, %r8
_mm_lp:	cmpq	$0, %rdi
	jz	_mm_en
	movq	8(%rdi, %rbx, ), %r15
	movq	%r15, (%rdi, %r8)
	subq	$8, %rdi
	jmp	_mm_lp
_mm_en:	movq	48(%rsp), %r8
	movq	%r12, 16(%r8)
	movq	%r12, %rbx
	leaq	16(%rdx, %r12, ), %r12
	popq	%r8
	popq	%rcx
	popq	%rdx
	jmp	_n_rt

_n_rev:
	pushq	%rdi
	sarq	$3, %rax
	roundsd	$0, (%rax), %xmm3
	movq	%xmm3, %rdi
	cmpq	(%rax), %rdi
	popq	%rdi
	jz	_nv_rt
	salq	$3, %rax
	orq	%r15, %rax
	jmp	_nw_s
_nv_rt:	cvtsd2si (%rax), %rax
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
	
# CLOSURE ROUTINES
	.global _encl
	# %rax: key, %rbx: value
_encl:	
	movq	%rax, (%r12)
	movq	%rbx, 8(%r12)
	movq	%r14, 16(%r12)
	movq	%r12, %r14
	addq	$24, %r12
	ret

	.global _clo_ref
	# %rax: key
_clo_ref:
	pushq	%r14
	pushq	%rdi
	movq	%rax, %rdi
_cr_lp:	movq	%rdi, %rax
	movq	(%r14), %rbx
	call	_compare
	cmp	$9, %rax
	jz	_cr_en
	movq	16(%r14), %r14
	cmp	$17, %r14
	jz	_cr_en
	jmp	_cr_lp
_cr_en:	leaq	8(%r14), %rax
	popq	%rdi
	popq	%r14
	ret

	.global _open
	# %rax: size
_open:
	cmp	$0, %rax
	jz	_op_en
	dec	%rax
	movq	16(%r14), %r14
	jmp	_open
_op_en:	ret
