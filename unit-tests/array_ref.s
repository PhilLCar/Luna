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
	lea	3(, %rbp, 8), %r10
	add	$16, %rbp
	lea	-8(%rbp), %r11
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r11)
	movq	$8, (%rbp)
	movq	$24, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r11
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r11)
	movq	$16, (%rbp)
	movq	$32, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r11
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r11)
	movq	$24, (%rbp)
	movq	$8, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r11
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r11)
	movq	$32, (%rbp)
	movq	$40, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r11
	movq	$17, (%r11)
	mov	%r10, %rsi
	sar	$3, %rsi
	movq	$32, (%rsi)
	push	%r10
	mov	(%rsp), %r10
	mov	$24, %r8
	mov	%r10, %r9
	call	index
	push	(%rsi)
	call	print_lua
	call	print_ret
	add	$8, %rsp
	mov	$0, %rax
	ret
