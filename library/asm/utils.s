	.text
# Internal routines to reduce compiled file size

# MEMORY ROUTINES
################################################################################
	
	.global _transfer
	# %rax: frame size, %rbx: transfer size
_transfer:
	movq	%rdi, -8(%rsp)
_tf_lp:	movq	(%rbp, %rax, 8), %rdi
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

# OPERATOR ROUTINES
################################################################################
	
	.global	_compare
	# %rax: arg1, %rbx: arg2
_compare:
	movq	%rax, %r15
	andq	$7, %r15
	cmpq	$2, %r15
	jz	_comp_string
	cmpq	$6, %r15
	jz	_comp_double
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
	xorq	%r15, %r15
_cp_lp:	movb	(%rbx), %r15b
	cmpb	(%rax), %r15b
	jnz	_cp_f
	cmpb	$0, %r15b
	jz	_cp_t
	cmpb	$0, (%rax)
	jz	_cp_f
	inc	%rax
	inc	%rbx
	jmp	_cp_lp
_cp_f:	movq	$1, %rax
	ret
_cp_t:	movq	$9, %rax
	ret

_comp_double:
	movq	%rbx, %r15
	andq	$7, %r15
	cmpq	$6, %r15
	jnz	_cp_f
	sarq	$3, %rax
	sarq	$3, %rbx
	movq	(%rax), %r15
	cmpq	%r15, (%rbx)
	jnz	_cp_f
	jmp	_cp_t

	.global	_gt
	# %rax: arg1, %rbx: arg2
_gt:
	movq	%rax, %r15
	andq	$7, %r15
	cmpq	$2, %r15
	jz	_comp_s_g
	cmpq	$6, %r15
	jz	_comp_d_g
	cmpq	%rax, %rbx
	jg	_rs_gt
	movq	$1, %rax
	ret
_rs_gt:	movq	$9, %rax
	ret

_comp_s_g:	
	movq	%rbx, %r15
	andq	$7, %r15
	cmpq	$2, %r15
	jnz	_cp_f
	sarq	$3, %rax
	sarq	$3, %rbx
	addq	$8, %rax
	addq	$8, %rbx
	xorq	%r15, %r15
_gt_lp:	movb	(%rbx), %r15b
	cmpb	(%rax), %r15b
	jg	_cp_t
	cmpb	$0, %r15b
	jz	_cp_f
	cmpb	$0, (%rax)
	jz	_cp_t
	inc	%rax
	inc	%rbx
	jmp	_gt_lp

_comp_d_g:
	movq	%rbx, %r15
	andq	$7, %r15
	cmpq	$6, %r15
	jnz	_cp_f
	sarq	$3, %rax
	sarq	$3, %rbx
	movsd	(%rax), %xmm1
	cmpsd	$1, (%rbx), %xmm1 #NLTE
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_cp_t
	jmp	_cp_f

	
	.global	_lt
	# %rax: arg1, %rbx: arg2
_lt:
	movq	%rax, %r15
	andq	$7, %r15
	cmpq	$2, %r15
	jz	_comp_s_l
	cmpq	$6, %r15
	jz	_comp_d_l
	cmpq	%rax, %rbx
	jb	_rs_lt
	movq	$1, %rax
	ret
_rs_lt:	movq	$9, %rax
	ret

_comp_s_l:	
	movq	%rbx, %r15
	andq	$7, %r15
	cmpq	$2, %r15
	jnz	_cp_f
	sarq	$3, %rax
	sarq	$3, %rbx
	addq	$8, %rax
	addq	$8, %rbx
	xorq	%r15, %r15
_lt_lp:	movb	(%rbx), %r15b
	cmpb	(%rax), %r15b
	jb	_cp_t
	cmpb	$0, (%rax)
	jz	_cp_f
	cmpb	$0, %r15b
	jz	_cp_t
	inc	%rax
	inc	%rbx
	jmp	_lt_lp

_comp_d_l:
	movq	%rbx, %r15
	andq	$7, %r15
	cmpq	$6, %r15
	jnz	_cp_f
	sarq	$3, %rax
	sarq	$3, %rbx
	movsd	(%rax), %xmm1
	cmpsd	$6, (%rbx), %xmm1 #LT
	movq	%xmm1, %rax
	cmpq	$-1, %rax
	jz	_cp_t
	jmp	_cp_f

	.global	_gte
	# %rax: arg1, %rbx: arg2
_gte:	
	pushq	%rax
	pushq	%rbx
	call	_gt
	cmpq	$1, %rax
	popq	%rbx
	popq	%rax
	jz	_compare
	movq	$9, %rax
	ret

	.global	_lte
	# %rax: arg1, %rbx: arg2
_lte:	
	pushq	%rax
	pushq	%rbx
	call	_lt
	cmpq	$1, %rax
	popq	%rbx
	popq	%rax
	jz	_compare
	movq	$9, %rax
	ret

	.global	_neq
	# %rax: arg1, %rbx: arg2
_neq:	
	call	_compare
	cmpq	$1, %rax
	jz	_cp_t
	jmp	_cp_f	

	.global _not
	# %rax: arg1
_not:
	cmpq	$1, %rax
	jz	_nt_t
	cmpq	$17, %rax
	jz	_nt_t
	movq	$1, %rax
	ret
_nt_t:	movq	$9, %rax
	ret

	.global _concat
	# %rax: str1, %rbx: str2
_concat:
	pushq	%rdi
	movq	%rax, %r15
	andq	$7, %r15
	cmpq	$2, %r15
	#call	_to_str_a
	movq	%rbx, %r15
	andq	$7, %r15
	cmpq	$2, %r15
	#call	_to_str_b
	sarq	$3, %rax
	sarq	$3, %rbx
	movq	(%rax), %r15
	addq	(%rbx), %r15
	movq	%r15, (%r12)
	xorq	%r15, %r15
	subq	(%rbx), %rax
_cn_b:	cmpq	%r15, (%rbx)
	jz	_cn_a
	movb	8(%rbx, %r15, ), %dil
	movb	%dil, 8(%r12, %r15, )
	inc	%r15
	jmp	_cn_b
_cn_a:	cmpq	%r15, (%r12)
	jz	_cn_en
	movb	8(%rax, %r15, ), %dil
	movb	%dil, 8(%r12, %r15, )
	inc	%r15
	jmp	_cn_a
_cn_en:	movb	$0, 8(%r12, %r15, )
	leaq	2(, %r12, 8), %rax
	leaq	9(%r12, %r15, ), %r12
	popq	%rdi
	ret

_to_str_a:
_to_str_b:
	nop
	ret

	// https://stackoverflow.com/questions/1375953/how-to-calculate-an-arbitrary-power-root
	.global _pow
	# %xmm0: base, %xmm1: power
_pow:
	pushq	%rcx
	pushq	%rdi
	movq	$1, 40(%r12) #sign
	movq	$1, 48(%r12) #numer/denom
	movq	%xmm0, %rax
	movq	%rax, %rbx
	sarq	$52, %rbx
	movq	%rbx, %r15
	andq	$0x800, %r15
	jz	_pos
	roundsd	$0, %xmm1, %xmm2
	cmpsd	$0, %xmm1, %xmm2
	movq	%xmm2, %r15
	cmpq	$-1, %r15
	jz	_neg
	popq	%rdi
	popq	%rcx
	movq	$0xFFF, %rax
	salq	$52, %rax
	orq	$1, %rax
	movq	%rax, %xmm0
	ret
_neg:	cvtsd2si %xmm1, %r15
	andq	$1, %r15
	jz	_pos
	movq	$0, 40(%r12)
_pos:	andq	$0x7FF, %rbx
	jz	_sb_n
	subq	$1023, %rbx # n = %rbx
	jmp	_nrm
_sb_n:	movq	$-1022, %rbx
_nrm:	#movq	%xmm1, %r15
	#sarq	$63, %r15
	#jz	_pw_ct
	#neg	%rbx
	#movq	$0, 48(%r12)
_pw_ct:	movq	%rax, %r15
	movq	$0x3FF, %rcx
	salq	$52, %rcx
	movq	$0xFFF, %rax
	salq	$52, %rax
	xorq	$-1, %rax
	andq	%rax, %r15
	jz	_find_u
	orq	%rcx, %r15 # %r15 = x/2^n
	movq	%r15, %xmm3
	xorq	%r15, %r15
	movq	$53, %rdi # %rdi = [m]
	
	// https://en.wikipedia.org/wiki/Binary_logarithm
_lg:	# Log recursion
	###################
	# check xmm0 for 1
	movsd	_db2(%rip), %xmm2
	mulsd	%xmm3, %xmm3
	dec	%rdi
	js	_lg_dn
	cmpsd	$5, %xmm3, %xmm2
	movq	%xmm2, %rax
	cmpq	$-1, %rax
	jz	_lg
	movq	$1, %rax
	movb	%dil, %cl
	salq	%cl, %rax
	orq	%rax, %r15
	movsd	_db2(%rip), %xmm2
	divsd	%xmm2, %xmm3
	jmp	_lg
_lg_dn:
	movq	$0x3FE, %rdi
_lg_l:	movq	$0xFFF, %rax
	salq	$52, %rax
	andq	%r15, %rax
	jnz	_trnct
	salq	$1, %r15
	dec	%rdi
	jmp	_lg_l
_trnct:	xorq	%rax, %r15
	salq	$52, %rdi
	orq	%rdi, %r15
_find_u:	
	movq	%r15, %xmm3
	cvtsi2sd %rbx, %xmm0
	addsd	%xmm3, %xmm0
	mulsd	%xmm1, %xmm0 # %xmm2 = u
	roundsd	$1, %xmm0, %xmm3 # %xmm3 = v
	subsd	%xmm3, %xmm0

	movsd	%xmm3,   (%r12)
	movsd	%xmm4,  8(%r12)
	movsd	%xmm5, 16(%r12)
	movsd	%xmm6, 24(%r12)
	movsd	%xmm7, 32(%r12)
	
_pow2:  # Taylor expansion
	####################%xmm0  # x
	movsd	_ln2(%rip), %xmm1  # ln2
	movsd	_db1(%rip), %xmm2  # cnt
	movsd	_db1(%rip), %xmm3  # x   accumulator
	movsd	_db1(%rip), %xmm4  # ln2 accumulator
	movsd	_db1(%rip), %xmm5  # cnt accumulator
	movsd	_db0(%rip), %xmm6  # total part
	movsd	_db1(%rip), %xmm7  # total
_p2_lp:	
	mulsd	%xmm0, %xmm3
	mulsd	%xmm1, %xmm4
	divsd	%xmm2, %xmm5

	movsd	_db0(%rip), %xmm6
	addsd	%xmm3, %xmm6
	mulsd	%xmm4, %xmm6
	mulsd	%xmm5, %xmm6

	cvtsd2si %xmm2, %rax
	cmpq	$52, %rax
	jz	_p2_en

	addsd	_db1(%rip), %xmm2
	addsd	%xmm6, %xmm7
	jmp	_p2_lp
_p2_en:	
	movsd	  (%r12), %xmm3
	
	cvtsd2si %xmm3, %rax
	addq	$1023, %rax
	salq	$52, %rax
	movq	%rax, %xmm0
	mulsd	%xmm7, %xmm0

	cmpq	$1, 40(%r12)
	jz	_pw_ret
	movsd	%xmm0, %xmm2
	movsd	_db0(%rip), %xmm0
	subsd	%xmm2, %xmm0
	
_pw_ret:	
	movsd	 8(%r12), %xmm4
	movsd	16(%r12), %xmm5
	movsd	24(%r12), %xmm6
	movsd	32(%r12), %xmm7

	popq	%rdi
	popq	%rcx
	ret

	.global _mod
	# %xmm0: number, %xmm1: mod
_mod:
	movsd	%xmm0, %xmm2
	divsd	%xmm1, %xmm2
	roundsd	$3, %xmm2, %xmm2
	mulsd	%xmm1, %xmm2
	subsd	%xmm2, %xmm0
	ret

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
	#sarq	$3, %r15
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
	#leaq	4(, %r12, 8), %rbx
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
	jmp	_ca_lp
_n_overflow:
	pushq	%rdx
	pushq	%rcx
	movq	%rdi, %rdx
	movq	%rsi, %rcx
	leaq	(%rcx, %rdi, ), %r15
_ca_lp:	salq	$1, %rdx
	cmpq	%r15, %rdx
	jb	_ca_lp
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
	
# CLOSURE ROUTINES
################################################################################

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
	cmpq	$9, %rax
	jz	_cr_en
	movq	16(%r14), %r14
	cmpq	$17, %r14
	jz	_cr_en
	jmp	_cr_lp
_cr_en:	leaq	8(%r14), %rax
	popq	%rdi
	popq	%r14
	ret

	.global _open
	# %rax: size
_open:
	cmpq	$0, %rax
	jz	_op_en
	dec	%rax
	movq	16(%r14), %r14
	jmp	_open
_op_en:	ret

# LUA SUPPORT
################################################################################
	.global _type
	# %rdi: arg1
_type:	
	movq	%rdi, %xmm0
	movq	%rdi, %rax
	and	$7, %rax
	cmp	$6, %rax
	jnz	_type_end
	cvtsd2si %xmm0, %rax
	cvtsi2sd %rax, %xmm1
	cmpsd	$4, %xmm1, %xmm0
	movq	%xmm0, %rax
	andq	$6, %rax
_type_end:
	ret

	.global _next
	# %rdi: table, %rsi: index
_next:	
	cmpq	$17, %rsi
	jz	_next_nil
	movq	%rsi, %rax
	andq	$7, %rax
	cmpq	$2, %rax
	jz	_next_str
	movq	%rsi, %rax
	sarq	$3, %rax
	movq	(%rax), %xmm0
	cvtsd2si %xmm0, %rbx
	cvtsi2sd %rbx, %xmm0
	movq	%xmm0, %rdx
	cmpq	(%rax), %rdx
	jnz	_next_str
	movq	%rbx, %rsi
_next_nil:
	sarq	$3, %rdi
	movq	16(%rdi), %rax	
	movq	(%rax), %rdx # MAX CAP
	leaq	16(%rax, %rdx, ), %rdx # LIMIT
	movq	8(%rax), %rcx # OFFSET
	cmpq	$17, %rsi
	jnz	_next_gsi
	leaq	8(%rax), %r8 # ITERATOR
	jmp	_next_lp
_next_gsi:	
	leaq	(%rcx, %rsi, 8), %r8
	addq	%rax, %r8
_next_lp:
	addq	$8, %r8
	cmpq	%rdx, %r8
	jge	_next_fstr
	cmpq	$17, (%r8)
	jz	_next_lp
	movq	$33, 8(%r12)
	movq	(%r8), %rbx
	movq	%rbx, 16(%r12)
	subq	%rax, %r8
	subq	%rcx, %r8
	sarq	$3, %r8
	cvtsi2sd %r8, %xmm0
	movsd	%xmm0, (%r12)
	leaq	6(, %r12, 8), %rax
	addq	$8, %r12
	leaq	8(%r12), %rbx
	ret
_next_str:
	cmpq	$17, %rsi
	jnz	_next_gsd
	sarq	$3, %rdi
_next_fstr:	
	movq	8(%rdi), %rax
	cmpq	$17, %rax
	jnz	_next_s_ret
_next_ret:	
	xorq	%rbx, %rbx
	ret
_next_gsd:
	movq	%rdi, %rbx
	movq	%rsi, %rax
	call	_index
	cmpq	$17, %rax
	jz	_next_ret
_next_gsd_lp:	
	movq	8(%rax), %rax
	cmpq	$17, %rax
	jz	_next_ret
	addq	$8, %rax
	cmpq	$17, (%rax)
	jz	_next_gsd_lp
	leaq	-8(%rax), %rax
_next_s_ret:	
	movq	$33, (%r12)
	movq	8(%rax), %rbx
	movq	%rbx, 8(%r12)
	movq	(%rax), %rax
	leaq	8(%r12), %rbx
	ret

	.global _inext
	# %rdi: table, %rsi: index
_inext:	
	cmpq	$17, %rsi
	jz	_inext_nil
	movq	%rsi, %rax
	andq	$7, %rax
	cmpq	$6, %rax
	jnz	_inext_nil
	movq	%rsi, %rax
	sarq	$3, %rax
	movq	(%rax), %xmm0
	cvtsd2si %xmm0, %rbx
	cvtsi2sd %rbx, %xmm0
	movq	%xmm0, %rdx
	cmpq	(%rax), %rdx
	jnz	_inext_nil
	leaq	(, %rbx, 8), %rax
	sarq	$3, %rdi
	movq	%rdi, %rbx
	jmp	_i_index
_inext_nil:
	xorq	%rbx, %rbx
	movq	$17, %rax
	ret
	
# DATA
################################################################################
	.data

_db4:
	.double	4
_db2:
	.double 2
_db1:
	.double 1
_db0:
	.double 0
_ln2:
	.double 0.69314718056
