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
	mov	$0, %r8
	call	var
	lea	(%rsi), %rsi
	push	%rsi
	push	$17
	mov	%rsp, %r10
	lea	3(, %rbp, 8), %r11
	add	$16, %rbp
	lea	-8(%rbp), %r12
	movq	$17, (%r12)
	mov	%r11, %rsi
	sar	$3, %rsi
	movq	$0, (%rsi)
	movq	$4, (%rbp)
	movq	%r11, 8(%rbp)
	movq	$17, 16(%rbp)
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r10)
	lea	16(%rbp), %r10
	add	$24, %rbp
	pop	%rsi
	mov	$1, %rdi
	call	place
	mov	$0, %r8
	call	var
	mov	(%rsi), %r10
	lea	string1(%rip), %r11
	lea	2(, %r11, 8), %r11
	mov	%r11, %r8
	mov	%r10, %r9
	call	new
	lea	(%rsi), %rsi
	push	%rsi
	push	$17
	mov	%rsp, %r10
	movq	$4, (%rbp)
	movq	$16, 8(%rbp)
	movq	$17, 16(%rbp)
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r10)
	lea	16(%rbp), %r10
	add	$24, %rbp
	pop	%rsi
	mov	$1, %rdi
	call	place
	mov	$0, %r8
	call	var
	mov	(%rsi), %rsi
	call	check
	mov	$0, %r8
	call	var
	mov	(%rsi), %r10
	lea	string2(%rip), %r11
	lea	2(, %r11, 8), %r11
	mov	%r11, %r8
	mov	%r10, %r9
	call	new
	lea	(%rsi), %rsi
	push	%rsi
	push	$17
	mov	%rsp, %r10
	movq	$4, (%rbp)
	movq	$32, 8(%rbp)
	movq	$17, 16(%rbp)
	lea	4(, %rbp, 8), %rsi
	mov	%rsi, (%r10)
	lea	16(%rbp), %r10
	add	$24, %rbp
	pop	%rsi
	mov	$1, %rdi
	call	place
	mov	$0, %r8
	call	var
	mov	(%rsi), %rsi
	call	check
	mov	$0, %r8
	call	var
	mov	(%rsi), %r10
	lea	string3(%rip), %r11
	lea	2(, %r11, 8), %r11
	mov	%r11, %r8
	mov	%r10, %r9
	call	index
	mov	(%rsi), %r10
	mov	$0, %r8
	call	var
	mov	(%rsi), %r11
	lea	string4(%rip), %r12
	lea	2(, %r12, 8), %r12
	mov	%r12, %r8
	mov	%r11, %r9
	call	index
	imul	(%rsi), %r10
	sar	$3, %r10
	push	%r10
	call	print_lua
	call	print_ret
	mov	$0, %rax
	ret


################################################################################
.data

string1:
	.quad	8
	.asciz	"x"
string2:
	.quad	8
	.asciz	"y"
string3:
	.quad	8
	.asciz	"y"
string4:
	.quad	8
	.asciz	"x"
