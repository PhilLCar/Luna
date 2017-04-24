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
	mov	$8, %r10
	mov	$16, %rsi
	cmp	$1, %rsi
	jz	else1
	mov	$8, %r11
	mov	$16, %rsi
	mov	%r11, %rdi
	call	compare
	mov	%rsi, %r11
	push	%r11
	push	(%rsp)
	call	print_lua
	call	print_ret
	add	$8, %rsp
iend1:
	mov	$0, %rax
	ret
