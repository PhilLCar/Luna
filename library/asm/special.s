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

	# %rdi: file, %rsi: what
_o_write:
	sarq	$3, %rdi
	movq	%rdi, %r15
	movq	8(%rdi), %rdi
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$15, %rsp
	andq	$-16, %rsp
	call	_f_write
	leave
	xorq	%rbx, %rbx
	movq	$33, %rax
	ret

	# %rdi: file
_o_seek:
	movq	$2, %rax
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
	movq	$33, %rax
	ret

	.global	_ol_tp
	# %rdi: file
_o_lines:
	pushq	%rbp
	movq	%rsp, %rbp
	sarq	$3, %rdi
	movq	8(%rdi), %rdi
_ol_tp:	movq	$33, (%r12)
	movq	$17, 8(%r12)
	movq	%rsp, 16(%r12)
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
	ret
	
	
# DATA
################################################################################
	#.data
	
	# String array names
_sa_sub:
	.asciz	"sub"
	
_string_array:
	.quad	_sa_sub
	.quad	_s_sub
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
