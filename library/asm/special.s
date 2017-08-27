	.text

# SPECIAL
################################################################################

	.global _special
_special:
	pushq	%rdi
	pushq	%rsi
	cmpq	$2, %r15
	jz	_special_string
	cmpq	$4, %r15
	jz	_special_object
_special_index:
	sarq	$3, %rax
	leaq	8(%rax), %rdi
	xorq	%r15, %r15
_special_lp:	
	movq	%rdi, %rax
	movq	(%rsi), %rbx
	call	_cp_lp
	cmpq	$9, %rax
	jz	_special_ret
	movq	24(%rsi), %rsi
	cmpq	$17, %rsi
	jnz	_special_lp
	movq	%rsi, %rax
	xorq	%rbx, %rbx
	popq	%rsi
	popq	%rdi
	ret
_special_ret:
	movq	8(%rsi), %rax
	leaq	71(, %rsi, 8), %rax
	movq	%rax, (%r12)
	movq	%r12, %rax
	xorq	%rbx, %rbx
	popq	%rsi
	popq	%rdi
	ret
_special_string:
	leaq	_string_array(%rip), %rsi
	jmp	_special_index
_special_object:
	leaq	_object_array(%rip), %rsi
	jmp	_special_index
	
	.global	_s_sub
	# %rdi: string, %rsi: start, %rdx: finish
_s_sub:	
	sarq	$3, %rdi
	movq	(%rdi), %r15
	addq	$8, %rdi
	sarq	$3, %rsi
	sarq	$3, %rdx
	cvtsd2si (%rsi), %rax
	cmpq	$0, %rax
	jns	_s_sub_1_p ##
	addq	%r15, %rax
	jmp	_s_sub_1_n
_s_sub_1_p:	
	decq	%rax
_s_sub_1_n:	
	jns	_s_sub_1
	xorq	%rax, %rax
_s_sub_1:
	xorq	%rsi, %rsi	
	cvtsd2si (%rdx), %rdx
	cmpq	$0, %rdx
	jns	_s_sub_2
	addq	%r15, %rdx
	incq	%rdx
	jmp	_s_sub_copy
_s_sub_2:	
	cmpq	%rdx, %r15
	jge	_s_sub_copy
	movq	%r15, %rdx
_s_sub_copy:
	cmpq	%rax, %rdx
	jbe	_s_sub_ret
	movb	(%rax, %rdi, ), %bl
	movb	%bl, 8(%rsi, %r12)
	incq	%rsi
	incq	%rax
	jmp	_s_sub_copy
_s_sub_ret:
	movq	%rsi, (%r12)
	movb	$0, 8(%rsi, %r12, )
	leaq	2(, %r12, 8), %rax
	leaq	9(%rsi, %r12, ), %r12
	addq	$7, %r12
	andq	$-8, %r12
	xorq	%rbx, %rbx
	ret

	.global	_s_find
	# %rdi: string, %rsi: match
_s_find:	
	sarq	$3, %rdi
	movq	(%rdi), %rdx
	addq	$8, %rdi
	sarq	$3, %rsi
	movq	(%rsi), %rcx
	addq	$8, %rsi
	#cvtsd2si %xmm0, %rdx
	#cvtsd2si %xmm1, %rcx
	movq	%rdi, %r8
	movq	%rdx, %r9
	subq	%rcx, %r9
	js	_sf_nl
_sf_lp:	movb	(%rdi, %rcx, ), %r10b
	movb	$0, (%rdi, %rcx, )
	movq	%rdi, %rax
	movq	%rsi, %rbx
	call	_cp_lp
	movb	%r10b, (%rdi, %rcx, )
	cmpq	$9, %rax
	jz	_sf_en
	inc	%rdi
	dec	%r9
	js	_sf_nl
	jmp	_sf_lp
_sf_en:	subq	%r8, %rdi
	addq	%rdi, %rcx
	incq	%rdi
	cvtsi2sd %rdi, %xmm0
	cvtsi2sd %rcx, %xmm1
	movsd	%xmm0, (%r12)
	movsd	%xmm1, 8(%r12)
	leaq	6(, %r12, 8), %rax
	addq	$8, %r12
	leaq	6(, %r12, 8), %rdx
	addq	$8, %r12
	movq	$33, (%r12)
	movq	%rdx, 8(%r12)
	leaq	8(%r12), %rbx
	ret
_sf_nl:	xorq	%rbx, %rbx
	movq	$17, %rax
	ret

	# %rdi: string
_s_lines:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	$33, (%r12)
	movq	$17, 8(%r12)
	leaq	-8(%rsp), %rax
	movq	%rax, 16(%r12)
	leaq	3(, %r12, 8), %rbx
	addq	$24, %r12	
	//---
	sarq	$3, %rdi
	addq	$8, %rdi
	xorq	%rdx, %rdx
	movb	(%rdi), %al
_sl_lp:	cmpb	$0, %al
	jz	_sl_en
	cmpb	$'\n', %al
	jz	_sl_nw
	movb	%al, 8(%rdx, %r12, )
	incq	%rdi
	incq	%rdx
	movb	(%rdi), %al
	jmp	_sl_lp
_sl_nw:	movq	%rdx, (%r12)
	movb	$0, 8(%rdx, %r12, )
	leaq	2(, %r12, 8), %rax
	pushq	%rax
	leaq	16(%rdx, %r12, ), %r12
	andq	$-8, %r12
	xorq	%rdx, %rdx
	incq	%rdi
	movb	(%rdi), %al
	jmp	_sl_lp
_sl_en:	movq	%rdx, (%r12)
	movq	$0, 8(%rdx, %r12, )
	leaq	2(, %r12, 8), %rax
	pushq	%rax
	leaq	16(%rdx, %r12, ), %r12
	andq	$-8, %r12
	//---
	pushq	$33
	pushq	%rbx
	movq	%rbx, %rax
	call	_array_copy
	leaq	_next(%rip), %rax
	movq	%rax, (%r12)
	movq	$17, 8(%r12)
	leaq	7(, %r12, 8), %rax
	addq	$16, %r12
	popq	16(%r12)
	movq	$17, 8(%r12)
	movq	$33, (%r12)
	leaq	16(%r12), %rbx
	leave
	ret


	# %rdi: file
_o_seek:
	sarq	$3, %rdi
	movq	8(%rdi), %rdi
	movq	$3, %rax
	call	_nil_fill
	cmpq	$17, %rsi
	jz	_seek
	sarq	$3, %rsi
	addq	$8, %rsi
	cmpq	$17, %rdx
	jz	_seek
	sarq	$3, %rdx
_seek:	pushq	%rbp
	movq	%rsp, %rbp
	subq	$15, %rsp
	andq	$-16, %rsp
	call	_f_seek
	leave
	xorq	%rbx, %rbx
	movq	$17, %rax
	ret

	# %rdi: file, %rsi: what
_o_write:
	movq	%r15, (%r12)
	movq	$2, %rax
	call	_nil_fill
	call	_varargs
	sarq	$3, %r15
	sarq	$3, %rdi
	movq	8(%rdi), %rdi
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$15, %rsp
	andq	$-16, %rsp
	subq	$8, %rsp
	pushq	%rdi
_wr_lp:	movq	(%r15), %rsi
	cmpq	$33, %rsi
	jz	_wr_en
	movq	(%rsp), %rdi
	call	_f_write
	subq	$8, %r15
	jmp	_wr_lp
_wr_en:	leave
	xorq	%rbx, %rbx
	movq	$17, %rax
	ret

	# %rdi: file
_o_lines:
	leaq	_line_iter(%rip), %rax
	movq	%rax, (%r12)
	movq	$17, 8(%r12)
	leaq	7(, %r12, 8), %rax
	addq	$16, %r12
	movq	%rdi, 8(%r12)
	movq	$33, (%r12)
	leaq	8(%r12), %rbx
	ret

/*	.global	_ol_tp
	# %rdi: file
_o_lines:
	pushq	%rbp
	movq	%rsp, %rbp
	sarq	$3, %rdi
	movq	8(%rdi), %rdi
_ol_tp:	movq	$33, (%r12)
	movq	$17, 8(%r12)
	leaq	-8(%rsp), %rax
	movq	%rax, 16(%r12)
	leaq	3(, %r12, 8), %rbx
	addq	$24, %r12
_ol_lp:	movq	%r12, %rsi
	leaq	_oa_lines(%rip), %rdx
	movq	_mem_max(%rip), %rcx
	subq	%r12, %rcx
	pushq	%rdi
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$15, %rsp
	andq	$-16, %rsp
	call	_f_read
	leave
	popq	%rdi
	cmpq	$-1, %rax
	jz	_ol_en
	addq	%r12, %rax
	xchgq	%rax, %r12
	leaq	2(, %rax, 8), %rax
	addq	$7, %r12
	andq	$-8, %r12
	pushq	%rax
	jmp	_ol_lp
_ol_en:	pushq	$33
	pushq	%rbx
	movq	%rbx, %rax
	call	_array_copy
	leaq	_next(%rip), %rax
	movq	%rax, (%r12)
	movq	$17, 8(%r12)
	leaq	7(, %r12, 8), %rax
	addq	$16, %r12
	popq	16(%r12)
	movq	$17, 8(%r12)
	movq	$33, (%r12)
	leaq	16(%r12), %rbx
	leave
	ret*/
	
	
# DATA
################################################################################
	#.data
	
	# String array names
_sa_sub:
	.asciz	"sub"
_sa_find:	
	.asciz	"find"
_sa_lines:
	.asciz	"lines"
	
_string_array:
	.quad	_sa_sub
	.quad	_s_sub
	.quad	17
	.quad	_sa2
_sa2:
	.quad	_sa_find
	.quad	_s_find
	.quad	17
	.quad	17
_sa3:
	.quad	_sa_lines
	.quad	_s_lines
	.quad	17
	.quad	17

	# File array names
_oa_read:
	.asciz	"read"
_oa_close:
	.asciz	"close"
_oa_write:	
	.asciz	"write"
_oa_flush:
	.asciz	"flush"
_oa_seek:
	.asciz	"seek"
_oa_lines:	
	.asciz	"lines"
	
_object_array:
	.quad	_oa_read
	.quad	_io_read
	.quad	17
	.quad	_oa2
_oa2:
	.quad	_oa_close
	.quad	_io_close
	.quad	17
	.quad	_oa3
_oa3:
	.quad	_oa_write
	.quad	_o_write
	.quad	17
	.quad	_oa4
_oa4:
	.quad	_oa_flush
	.quad	_io_flush
	.quad	17
	.quad	_oa5
_oa5:
	.quad	_oa_seek
	.quad	_o_seek
	.quad	17
	.quad	_oa6
_oa6:	
	.quad	_oa_lines
	.quad	_o_lines
	.quad	17
	.quad	17
