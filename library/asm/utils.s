	.text
# Fonctions utiles à la compilation, pour alléger le compilateur
	.global	compare
compare:
	push	%rdx
	mov	%rax, %rdx
	and	$7, %rdx
	cmp	$2, %rdx
	jz	comp_string
	cmp	%rax, %rcx
	jz	res_t
	mov	$1, %rax
	pop	%rdx
	ret
res_t:	mov	$9, %rax
	pop	%rdx
	ret

comp_string:
	mov	%rcx, %rdx
	and	$7, %rdx
	cmp	$2, %rdx
	jnz	cp_f
	sar	$3, %rax
	sar	$3, %rcx
	mov	(%rax), %rdx
	cmp	%rdx, (%rcx)
	jnz	cp_f
	add	$8, %rax
	add	$8, %rcx
cp_lp:	xor	%rdx, %rdx
	mov	(%rcx), %dl
	cmp	(%rax), %dl
	jnz	cp_f
	cmp	$0, %dl
	jz	cp_t
	cmpl	$0, (%rax)
	jz	cp_f
	inc	%rax
	inc	%rcx
	jmp	cp_lp
cp_f:	mov	$1, %rax
	pop	%rdx
	ret
cp_t:	mov	$9, %rax
	pop	%rdx
	ret

	.global	index
index:
	push	%rdx
	sar	$3, %rcx
	mov	8(%rcx), %rdx
ix_lp:	cmp	$17, %rdx
	jz	ix_nl
	sar	$3, %rdx
	mov	(%rdx), %rcx
	push	%rax
	call	compare
	lea	8(%rdx), %rcx
	mov	8(%rcx), %rdx
	cmp	$9, %rax
	jz	ix_ad
	pop	%rax
	jmp	ix_lp
ix_ad:	pop	%rax
	lea	(%rcx), %rax
	pop	%rdx
	ret
ix_nl:	lea	8(%rcx), %rax
	pop	%rdx
	ret

	.global new
new:
	push	%rax
	call	index
	cmp	$17, (%rax)
	jnz	nw_rt
	lea	4(, %rbp, 8), %rcx
	mov	%rcx, (%rax)
	mov	(%rsp), %rax
	mov	%rax, (%rbp)
	lea	8(%rbp), %rax
	movq	$17, 16(%rbp)
	add	$24, %rbp
nw_rt:	add	$8, %rsp
	ret

	.global check
check:
	push	%rax
	push	%rbx
	push	%rcx
	push	%rdx
	sar	$3, %rax
	lea	8(%rax), %rdx
	xor	%rcx, %rcx
ck_lp:	cmp	$17, (%rdx)
	jz	ck_en
	inc	%rcx
	mov	(%rdx), %rax
	sar	$3, %rax
	cmp	$17, 8(%rax)
	jnz	ck_rm
	dec	%rcx
	mov	16(%rax), %rbx
	mov	%rbx, (%rdx)
ck_rm:	lea	16(%rax), %rdx
	jmp	ck_lp
ck_en:	sal	$3, %rcx
	mov	24(%rsp), %rax
	sar	$3, %rax
	mov	%rcx, (%rax)
	pop	%rdx
	pop	%rcx
	pop	%rbx
	pop	%rax
	ret

	.global var
var:
	push	%rcx
	mov	%rbx, %rcx
	call	new
	mov	%rax, %rcx
	mov	%rbx, %rax
	call	check
	mov	%rcx, %rax
	pop	%rcx
	ret

	.global stack
stack:
	pop	%rdx
st_lp:	cmp	$0, %rcx
	jz	st_dn
	dec	%rcx
	cmp	$17, %rax
	jz	st_em
	sar	$3, %rax
	push	8(%rax)
	mov	16(%rax), %rax
	jmp	st_lp
st_em:	push	%rax
	jmp	st_lp
st_dn:	jmp	*%rdx

	.global place
place:
	pop	%rsi
	lea	(%rsp, %rcx, 8), %rdx
pl_lp:	cmp	$0, %rcx
	jz	pl_dn
	dec	%rcx
	mov	(%rsp, %rcx, 8), %rdi
	cmp	$17, %rax
	jz	pl_em
	sar	$3, %rax
	mov	8(%rax), %rax
	mov	%rax, (%rdi)
	add	$8, %rax
	jmp	pl_lp
pl_em:	mov	%rax, (%rdi)
	jmp	pl_lp
pl_dn:	mov	%rdx, %rsp
	jmp	*%rsi

	.global not
not:
	cmp	$1, %rax
	jz	nt_t
	cmp	$17, %rax
	jz	nt_t
	mov	$1, %rax
	ret
nt_t:	mov	$9, %rax
	ret

	.global expand
expand:
	push	%r10
	push	%r11
	push	%r12
	push	%r13
	push	%r14
	push	%r15
	mov	$1, %r14
	mov	%rbp, %r15
	mov	%r14, (%r15)
	mov	$17, 8(%r15)
	mov	$17, 16(%r15)
	lea	16(%r15), %r13
	add	$24, %rbp
	mov	%rsi, %r11
	and	$7, %r11
	cmp	$4, %r11
	jnz	ex_n1
	cmp	$0, %rax
	jmp	ex_en
	
