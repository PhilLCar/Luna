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
	push	$24
	push	$17
	mov	%rsp, %r10
	lea	(%rsp), %rsi
	push	%rsi
	mov	$24, %r11
	add	$32, %r11
	add	$40, %r11
	add	16(%rsp), %r11
	push	%r11
	mov	8(%rsp), %rsp
	mov	-8(%rsp), %rdi
	mov	-16(%rsp), %rsi
	mov	%rsi, (%rdi)
	push	(%rsp)
	call	print_lua
	call	print_ret
	add	$16, %rsp
	mov	$0, %rax
	ret
