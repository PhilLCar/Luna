	.text
	
# OPERATOR ROUTINES
################################################################################
# Internal routines to reduce compiled file size
	
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
	
	.global _cp_lp
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
	addq	$7, %r12 ## mod
	andq	$-8, %r12
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
_nrm:	movq	%rax, %r15
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

# DATA
################################################################################
	#.data

_db4:
	.double	4
_db2:
	.double 2
_db1:
	.double 1
_db0:
	.double 0
_ln2:
	.double 0.69314718055994530941723212145817

