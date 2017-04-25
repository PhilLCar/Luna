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
	movq	$17, (%r11)
	mov	%r10, %rsi
	sar	$3, %rsi
	movq	$0, (%rsi)
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
	push	$24
	mov	%r10, %rsp
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
	push	(%rsi)
	call	print_lua
	call	print_ret
	add	$8, %rsp
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
