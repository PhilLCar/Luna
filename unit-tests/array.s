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
	mov	$8, %r12
	add	$16, %r12
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r11)
	movq	$8, (%rbp)
	movq	%r12, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r11
	lea	3(, %rbp, 8), %r12
	add	$16, %rbp
	lea	-8(%rbp), %r13
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r13)
	movq	$8, (%rbp)
	movq	$16, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r13
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r13)
	movq	$16, (%rbp)
	movq	$16, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r13
	movq	$17, (%r13)
	mov	%r12, %rsi
	sar	$3, %rsi
	movq	$16, (%rsi)
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r11)
	movq	$16, (%rbp)
	movq	%r12, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r11
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r11)
	movq	$24, (%rbp)
	movq	$24, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r11
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r11)
	movq	$32, (%rbp)
	movq	$32, 8(%rbp)
	add	$24, %rbp
	lea	-8(%rbp), %r11
	movq	$17, (%r11)
	mov	%r10, %rsi
	sar	$3, %rsi
	movq	$32, (%rsi)
	push	%r10
	mov	%rsp, %r10
	mov	(%rsp), %r11
	lea	string1(%rip), %r12
	lea	2(, %r12, 8), %r12
	mov	%r12, %r8
	mov	%r11, %r9
	call	new
	lea	(%rsi), %rsi
	push	%rsi
	push	8(%rsp)
	mov	8(%rsp), %rsp
	mov	-8(%rsp), %rdi
	mov	-16(%rsp), %rsi
	mov	%rsi, (%rdi)
	mov	(%rsp), %rsi
	call	check
	mov	(%rsp), %r10
	lea	string2(%rip), %r11
	lea	2(, %r11, 8), %r11
	mov	%r11, %r8
	mov	%r10, %r9
	call	index
	mov	(%rsi), %rsi
	sar	$3, %rsi
	mov	(%rsi), %rsi
	push	%rsi
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
	.asciz	"test"
string2:
	.quad	32
	.asciz	"test"
