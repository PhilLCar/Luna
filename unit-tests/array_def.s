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
	lea	3(, %rbp, 8), %r10
	add	$16, %rbp
	lea	-8(%rbp), %r11
	movq	$17, (%r11)
	mov	%r10, %rsi
	sar	$3, %rsi
	movq	$0, (%rsi)
	push	%r10
	mov	%rsp, %r10
	mov	(%rsp), %r11
	mov	$8, %r8
	mov	%r11, %r9
	call	new
	lea	(%rsi), %rsi
	push	%rsi
	push	$24
	mov	8(%rsp), %rsp
	mov	-8(%rsp), %rdi
	mov	-16(%rsp), %rsi
	mov	%rsi, (%rdi)
	mov	(%rsp), %rsi
	call	check
	mov	(%rsp), %r10
	mov	$8, %r8
	mov	%r10, %r9
	call	index
	add	$8, %rsp
	mov	$0, %rax
	ret
