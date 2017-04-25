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
	mov	%rsp, %r10
	mov	$0, %r8
	call	var
	lea	(%rsi), %rsi
	push	%rsi
	push	$40
	mov	%r10, %rsp
	mov	-8(%rsp), %rdi
	mov	-16(%rsp), %rsi
	mov	%rsi, (%rdi)
	mov	$0, %r8
	call	var
	push	(%rsi)
	call	print_lua
	call	print_ret
	mov	$0, %rax
	ret
