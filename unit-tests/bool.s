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
	push	$1
	mov	%rsp, %r10
	lea	(%rsp), %rsi
	push	%rsi
	mov	8(%rsp), %r11
	cmp	$1, %r11
	jz	not1
	mov	$1, %r11
	jmp	nt1
not1:	mov	$9, %r11
nt1:	push	%r11
	mov	8(%rsp), %rsp
	mov	-8(%rsp), %rdi
	mov	-16(%rsp), %rsi
	mov	%rsi, (%rdi)
	push	(%rsp)
	call	print_lua
	call	print_ret
	add	$8, %rsp
	mov	$0, %rax
	ret
