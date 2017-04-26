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
	mov	%rbx, %rcx
	call	new
	mov	%rax, %rcx
	mov	%rbx, %rax
	call	check
	mov	%rcx, %rax
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
	pop	%r12
	mov	%rax, %r14
	movq	$17, 8(%rbp)
	movq	$17, 16(%rbp)
	lea	4(,%rbp, 8), %r15
	add	$24, %rbp
rg_0:	mov	%rdi, %r10
	jmp	rg_fl
rg_1:	mov	%rsi, %r10
	jmp	rg_fl	
rg_2:	mov	%rdx, %r10
	jmp	rg_fl
rg_3:	mov	%rcx, %r10
	jmp	rg_fl
rg_4:	mov	%r8, %r10
	jmp	rg_fl
rg_5:	mov	%r9, %r10
	jmp	rg_fl
rg_st:	pop	%r10
rg_fl:	cmp	$0, %r14
	jz	ex_en
	dec	%r14
	mov	%r10, %r11
	and	$7, %r11
	cmp	$4, %r11
	jnz	ex_n
	mov	%r10, (%r13)
	sar	$3, %r10
	mov	(%r10), %r13
	jmp	ex_f
ex_n:	mov	%r10, 8(%rbp)
	mov	%r15, 16(%rbp)
	lea	4(, %rbp, 8), %r15
	add	$24, %rbp
ex_f:	mov	%rax, %r11
	sub	%r14, %r11
	cmp	$1, %r11
	jz	rg_1
	cmp	$2, %r11
	jz	rg_2
	cmp	$3, %r11
	jz	rg_3
	cmp	$4, %r11
	jz	rg_4
	cmp	$5, %r11
	jz	rg_5
	jmp	rg_st
ex_en:	sar	$3, %r15
	jmp	*%r12

		.global	distribute
distribute:
	mov	%r15, %rdi
	pop	(%rbp)
	lea	(%rdi), %rsi
	xor	%rdi, %rdi
	movq	%r9, %rdi
	jmp	ds_fl
ds_0:	push	%r10
dn_0:	mov	%r8, %r10
	jmp	ds_fl
ds_1:	push	%r11
dn_1:	mov	%r8, %r11
	jmp	ds_fl
ds_2:	push	%r12	
dn_2:	mov	%r8, %r12
	jmp	ds_fl
ds_3:	push	%r13
dn_3:	mov	%r8, %r13
	jmp	ds_fl
ds_4:	push	%r14
dn_4:	mov	%r8, %r14
	jmp	ds_fl
ds_5:	push	%r15
dn_5:	mov	%r8, %r15
ds_fl:	cmp	$0, %r9
	jz	ds_ar
	cmp	$0, %r9
	js	ds_en
	cmpq	$17, 8(%rsi)
	jz	ds_em
	dec	%r9
	mov	8(%rsi), %r8
	mov	16(%rsi), %rsi
	sar	$3, %rsi
ds_f:	mov	%rdi, %rax
	sub	%r9, %rax
	cmp	$6, %rax
	jg	dn_f
	cmp	$1, %rax
	jz	dn_0
	cmp	$2, %rax
	jz	dn_1
	cmp	$3, %rax
	jz	dn_2
	cmp	$4, %rax
	jz	dn_3
	cmp	$5, %rax
	jz	dn_4
	cmp	$6, %rax
	jz	dn_5	
dn_f:	xor	%rdx, %rdx
	mov	$6, %rcx
	idiv	%rax
	cmp	$1, %rdx
	jz	ds_0
	cmp	$2, %rdx
	jz	ds_1
	cmp	$3, %rdx
	jz	ds_2
	cmp	$4, %rdx
	jz	ds_3
	cmp	$5, %rdx
	jz	ds_4
	cmp	$0, %rdx
	jz	ds_5
ds_em:	mov	$17, %r8
	jmp	ds_f
ds_ar:	lea	131(, %rbp, 8), %r8
	mov	%r8, 8(%rbp)
	dec	%r9
	jmp	ds_f
ds_en:	mov	%rdi, %rax
	mov	(%rbp), %rdx
	lea	8(, %rax, 8), %rcx
	mov	%rcx, (%rbp)
	add	$16, %rbp
	lea	string_n(%rip), %rdi
	lea	2(, %rax, 8), %rdi
	mov	%rdi, (%rbp)
	mov	%rax, 8(%rbp)
	lea	4(, %rsi, 8), %rax
	mov	%rax, 16(%rbp)
	add	$24, %rbp
ds_fn:	jmp	*%rdx
	
	.data
	
string_n:
	.quad	8
	.asciz	"n"
