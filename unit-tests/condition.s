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
	push	$17
	mov	$1, %rsi
	cmp	$1, %rsi
	jz	else1
	cmp	$17, %rsi
	jz	else1
	mov	%rsp, %r10
	lea	(%rsp), %rsi
	push	%rsi
	push	$24
	mov	8(%rsp), %rsp
	mov	-8(%rsp), %rdi
	mov	-16(%rsp), %rsi
	mov	%rsi, (%rdi)
	jmp	iend1
else1:
	mov	%rsp, %r10
	lea	(%rsp), %rsi
	push	%rsi
	mov	$24, %rsi
	neg	%rsi
	push	%rsi
	mov	8(%rsp), %rsp
	mov	-8(%rsp), %rdi
	mov	-16(%rsp), %rsi
	mov	%rsi, (%rdi)
iend1:
	push	(%rsp)
	call	print_lua
	call	print_ret
	add	$8, %rsp
	mov	$0, %rax
	ret
