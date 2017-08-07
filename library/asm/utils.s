	.text
# Internal procedures to reduce compiled file size

#MEMORY PROCEDURES
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
	addq	$8, %rbx
	subq	$8, %r15
	jmp	_f_lp
_f_en:	ret

	.global	_varargs
	# %rax: final nargs, %r15: starting nargs
_varargs:
	pushq	%rax
	pushq	%r14
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
_va_g:	movq	24(%rsp, %rbx, 8), %r14
	movq	%r14, (%r12)
	inc	%rbx
_va_cm:	addq	$8, %r12
	inc	%rax
	jmp	_va_lp
_va_en:	popq	%r14
	popq	%rax
	movq	$33, (%r12)
	addq	$8, %r12
	subq	%rax, %r15
	xorq	$-1, %r15
	leaq	-8(%r12, %r15, 8), %r15
	leaq	5(, %r15, 8), %r15
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

#BOOLEAN PROCEDURES
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

#ARRAY PROCEDURES
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
	leaq	(, %r15, 8), %rbx
	movq	%rbx, (%rax)
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
	
	.global _new
	# %rax: key, %rbx: table
_new:
	sarq	$3, %rbx
	movq	%rax, %r15
	andq	$7, %r15
	jz	_i_new
	pushq	%rax
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
	addq	$8, %rbx
	jmp	_ch_lp
_ch_en:	popq	%rax
	movq	%rbx, (%rax)
	ret
	

######################################### WOW
	.global expand
expand:
	pop	%r12
	mov	%rax, %r14
	movq	$17, 8(%rbp)
	movq	$17, 16(%rbp)
	lea	4(,%rbp, 8), %r15
	add	$24, %rbp
rg_0:	mov	%rdi, %r10
	jmp	rg_fl
rg_1:	mov	%rsi, %r10
	jmp	rg_fl	
rg_2:	mov	%rdx, %r10
	jmp	rg_fl
rg_3:	mov	%rcx, %r10
	jmp	rg_fl
rg_4:	mov	%r8, %r10
	jmp	rg_fl
rg_5:	mov	%r9, %r10
	jmp	rg_fl
rg_st:	pop	%r10
rg_fl:	cmp	$0, %r14
	jz	ex_en
	dec	%r14
	mov	%r10, %r11
	and	$7, %r11
	cmp	$4, %r11
	jnz	ex_n
	mov	%r10, (%r13)
	sar	$3, %r10
	mov	(%r10), %r13
	jmp	ex_f
ex_n:	mov	%r10, 8(%rbp)
	mov	%r15, 16(%rbp)
	lea	4(, %rbp, 8), %r15
	add	$24, %rbp
ex_f:	mov	%rax, %r11
	sub	%r14, %r11
	cmp	$1, %r11
	jz	rg_1
	cmp	$2, %r11
	jz	rg_2
	cmp	$3, %r11
	jz	rg_3
	cmp	$4, %r11
	jz	rg_4
	cmp	$5, %r11
	jz	rg_5
	jmp	rg_st
ex_en:	sar	$3, %r15
	jmp	*%r12

		.global	distribute
distribute:
	mov	%r15, %rdi
	pop	(%rbp)
	lea	(%rdi), %rsi
	xor	%rdi, %rdi
	xor	%r9, %rdi
	jmp	ds_fl
ds_0:	push	%r10
dn_0:	mov	%r8, %r10
	jmp	ds_fl
ds_1:	push	%r11
dn_1:	mov	%r8, %r11
	jmp	ds_fl
ds_2:	push	%r12	
dn_2:	mov	%r8, %r12
	jmp	ds_fl
ds_3:	push	%r13
dn_3:	mov	%r8, %r13
	jmp	ds_fl
ds_4:	push	%r14
dn_4:	mov	%r8, %r14
	jmp	ds_fl
ds_5:	push	%r15
dn_5:	mov	%r8, %r15
ds_fl:	cmp	$0, %r9
	jz	ds_ar
	cmp	$0, %r9
	js	ds_en
	cmpq	$17, 8(%rsi)
	jz	ds_em
	dec	%r9
	mov	8(%rsi), %r8
	mov	16(%rsi), %rsi
	sar	$3, %rsi
ds_f:	mov	%rdi, %rax
	sub	%r9, %rax
	cmp	$6, %rax
	jg	dn_f
	cmp	$1, %rax
	jz	dn_0
	cmp	$2, %rax
	jz	dn_1
	cmp	$3, %rax
	jz	dn_2
	cmp	$4, %rax
	jz	dn_3
	cmp	$5, %rax
	jz	dn_4
	cmp	$6, %rax
	jz	dn_5	
dn_f:	xor	%rdx, %rdx
	mov	$6, %rcx
	idiv	%rax
	cmp	$1, %rdx
	jz	ds_0
	cmp	$2, %rdx
	jz	ds_1
	cmp	$3, %rdx
	jz	ds_2
	cmp	$4, %rdx
	jz	ds_3
	cmp	$5, %rdx
	jz	ds_4
	cmp	$0, %rdx
	jz	ds_5
ds_em:	mov	$17, %r8
	jmp	ds_f
ds_ar:	lea	131(, %rbp, 8), %r8
	mov	%r8, 8(%rbp)
	dec	%r9
	jmp	ds_f
ds_en:	mov	%rdi, %rax
	mov	(%rbp), %rdx
	lea	8(, %rax, 8), %rcx
	mov	%rcx, (%rbp)
	add	$16, %rbp
	lea	_string_n(%rip), %rdi
	lea	2(, %rax, 8), %rdi
	mov	%rdi, (%rbp)
	mov	%rax, 8(%rbp)
	lea	4(, %rsi, 8), %rax
	mov	%rax, 16(%rbp)
	add	$24, %rbp
ds_fn:	jmp	*%rdx
	
	.data
	
_string_n:
	.quad	8
	.asciz	"n"
