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
	mov	$1, %r10
	mov	%rsp, %r11
	lea	%r11, %rsi
	push	%rsi
	push	$24
	mov	8(%rsp), %rsp
	mov	-8(%rsp), %rdi
	mov	-16(%rsp), %rsi
	mov	%rsi, (%rdi)
	mov	$0, %rax
	ret
