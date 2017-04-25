	.text
	.global	_main
	.global	main
_main:
main:
	xor	%rbx, %rbx
	mov	$134217728, %rax
	push	%rax
	call	mmap
	mov	%rax, %rbp
	mov	%rbp, %rbx
	add	$16, %rbp
	movq	$0, (%rbx)
	movq	$17, 8(%rbx)
	lea	3(, %rbx, 8), %rbx
	lea	string1(%rip), %r10
	lea	2(, %r10, 8), %r10
	push	%r10
	push	$17
	mov	%rsp, %r10
	lea	(%rsp), %rsi
	push	%rsi
	mov	16(%rsp), %rsi
	sar	$3, %rsi
	mov	(%rsi), %rsi
	push	%rsi
	mov	%r10, %rsp
	mov	-8(%rsp), %rdi
	mov	-16(%rsp), %rsi
	mov	%rsi, (%rdi)
	push	(%rsp)
	call	print_lua
	call	print_ret
	add	$16, %rsp
	mov	$0, %rax
	ret


################################################################################
.data

string1:
	.quad	32
	.asciz	"allo"
