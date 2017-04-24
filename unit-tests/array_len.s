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
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r11)
	movq	$8, (%rbp)
	movq	$8, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r11
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r11)
	movq	$16, (%rbp)
	movq	$16, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r11
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r11)
	movq	$24, (%rbp)
	movq	$24, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r11
	movq	$17, (%r11)
	mov	%r10, %rsi
	sar	$3, %rsi
	movq	$24, (%rsi)
	push	%r10
	mov	(%rsp), %rsi
	sar	$3, %rsi
	mov	(%rsi), %rsi
	push	%rsi
	call	print_lua
	call	print_ret
	add	$8, %rsp
	mov	$0, %rax
	ret
