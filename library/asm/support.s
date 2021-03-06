.text
	
# LUA SUPPORT
################################################################################

	.global _type
	# %rdi: arg1
_type:
	movq	%rdi, %rax
	andq	$7, %rax
	cmpq	$4, %rax
	jz	_t_obj
_t_ret:	cvtsi2sd %rax, %xmm0
	movsd	%xmm0, (%r12)
	leaq	6(, %r12, 8), %rax
	addq	$8, %r12
	ret
_t_obj:	sarq	$3, %rdi
	movq	(%rdi), %rax
	andq	$7, %rax
	sarq	$3, %rax
	jmp	_t_ret

	.global _line_iter2
	# %rdi : file
_line_iter2:	
	pushq	%rdi
	call	_line_iter
	cmpq	$17, %rax
	popq	%rdi
	jnz	_li_r
	call	_io_close
_li_r:	ret

	.global _line_iter
	# %rdi: file
_line_iter:
	sarq	$3, %rdi
	movq	8(%rdi), %rdi
	movq	%r12, %rsi
	leaq	_l_str(%rip), %rdx
	movq	_mem_max(%rip), %rcx
	sub	%r12, %rcx
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$15, %rsp
	andq	$-16, %rsp
	call	_f_read
	leave
	cmpq	$-1, %rax
	jz	_return_error
	addq	%r12, %rax
	xchgq	%rax, %r12
	leaq	2(, %rax, 8), %rax
	addq	$7, %r12
	andq	$-8, %r12
	xorq	%rbx, %rbx
	ret

	.global _next
	# %rdi: table, %rsi: index
_next:	
	cmpq	$17, %rsi
	jz	_next_nil
	movq	%rsi, %rax
	andq	$7, %rax
	cmpq	$2, %rax
	jz	_next_str
	movq	%rsi, %rax
	sarq	$3, %rax
	movq	(%rax), %xmm0
	cvtsd2si %xmm0, %rbx
	cvtsi2sd %rbx, %xmm0
	movq	%xmm0, %rdx
	cmpq	(%rax), %rdx
	jnz	_next_str
	movq	%rbx, %rsi
_next_nil:
	sarq	$3, %rdi
	movq	16(%rdi), %rax	
	movq	(%rax), %rdx # MAX CAP
	leaq	16(%rax, %rdx, ), %rdx # LIMIT
	movq	8(%rax), %rcx # OFFSET
	cmpq	$17, %rsi
	jnz	_next_gsi
	leaq	8(%rax), %r8 # ITERATOR
	jmp	_next_lp
_next_gsi:	
	leaq	(%rcx, %rsi, 8), %r8
	addq	%rax, %r8
_next_lp:
	addq	$8, %r8
	cmpq	%rdx, %r8
	jge	_next_fstr
	cmpq	$17, (%r8)
	jz	_next_lp
	movq	$33, 8(%r12)
	movq	(%r8), %rbx
	movq	%rbx, 16(%r12)
	subq	%rax, %r8
	subq	%rcx, %r8
	sarq	$3, %r8
	cvtsi2sd %r8, %xmm0
	movsd	%xmm0, (%r12)
	leaq	6(, %r12, 8), %rax
	addq	$8, %r12
	leaq	8(%r12), %rbx
	ret
_next_str:
	cmpq	$17, %rsi
	jnz	_next_gsd
	sarq	$3, %rdi
_next_fstr:	
	movq	8(%rdi), %rax
	cmpq	$17, %rax
	jnz	_next_s_ret
_next_ret:	
	xorq	%rbx, %rbx
	ret
_next_gsd:
	movq	%rdi, %rbx
	movq	%rsi, %rax
	call	_index
	cmpq	$17, %rax
	jz	_next_ret
_next_gsd_lp:	
	movq	8(%rax), %rax
	cmpq	$17, %rax
	jz	_next_ret
	addq	$8, %rax
	cmpq	$17, (%rax)
	jz	_next_gsd_lp
	leaq	-8(%rax), %rax
_next_s_ret:	
	movq	$33, (%r12)
	movq	8(%rax), %rbx
	movq	%rbx, 8(%r12)
	movq	(%rax), %rax
	leaq	8(%r12), %rbx
	ret

	.global _inext
	# %rdi: table, %rsi: index
_inext:	
	movq	%rsi, %rax
	andq	$7, %rax
	cmpq	$6, %rax
	jnz	_inext_nil
	movq	%rsi, %rax
	sarq	$3, %rax
	movq	(%rax), %xmm0
	cvtsd2si %xmm0, %rbx
	cvtsi2sd %rbx, %xmm0
	movq	%xmm0, %rdx
	cmpq	(%rax), %rdx
	jnz	_inext_nil
	leaq	8(, %rbx, 8), %rax
	sarq	$3, %rdi
	movq	%rdi, %rbx
	call	_i_index
	cmpq	$17, (%rax)
	jz	_inext_nil
	movq	(%rax), %rbx
	movq	%rbx, 16(%r12)
	movq	$33, 8(%r12)
	leaq	16(%r12), %rbx
	addsd	_db1(%rip), %xmm0
	movsd	%xmm0, (%r12)
	leaq	6(, %r12, 8), %rax
	addq	$8, %r12
	ret
_inext_nil:
	xorq	%rbx, %rbx
	movq	$17, %rax
	ret

	.global _format_c
	# %rdi: spec, %rsi: val
_format_c:
	sarq	$3, %rdi
	addq	$8, %rdi	
	movq	%rsi, %rdx
	movq	%rdi, %rsi
	movq	%r12, %rdi
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$15, %rsp
	andq	$-16, %rsp
	call	_format
	leave
	addq	%r12, %rax
	xchgq	%rax, %r12
	addq	$7, %r12
	andq	$-8, %r12
	leaq	2(, %rax, 8), %rax
	xorq	%rbx, %rbx
	ret

	.global _scan_c
	# %rdi: scan string
_scan_c:
	sarq	$3, %rdi
	addq	$8, %rdi
	movq	%r12, %rsi
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$15, %rsp
	andq	$-16, %rsp
	call	_scan
	leave
	cmpq	$0, %rax
	jz	_return_error
	movq	%r12, %rax
	addq	$8, %r12
	leaq	6(, %rax, 8), %rax
	xorq	%rbx, %rbx
	ret

	.global _unpack
	# %rdi: table
_unpack:
	sarq	$3, %rdi
	movq	16(%rdi), %rax
	cmpq	$17, %rax
	jz	_u_void
	movq	(%rax), %rdx # capacity
	movq	8(%rax), %rcx # offset
	leaq	16(%rdx, %rax, ), %rdx # max
	leaq	8(%rcx, %rax, ), %rcx #start
	movq	%rsp, %rax
_u_lp:	cmpq	%rcx, %rdx
	jz	_u_fill
	cmpq	$17, (%rcx)
	jz	_u_fill
	pushq	(%rcx)
	addq	$8, %rcx
	jmp	_u_lp
_u_fill:	
	cmpq	%rax, %rsp
	jz	_u_void
	pushq	$33
	movq	%rax, %rsp
	leaq	-16(%rax), %rbx
	movq	-8(%rax), %rax
	ret
_u_void:
	xorq	%rbx, %rbx
	movq	$17, %rax
	ret

	.global _set_nargs
_set_nargs:
	sarq	$3, %rdi
	cvtsd2si (%rdi), %r15
	ret

########### IO Functions ##########
_return_error:
	xorq	%rbx, %rbx
	movq	$17, %rax
	ret
	
	.global _io_open
	# %rdi: filename, %rsi: mode
_io_open:
	sarq	$3, %rdi
	addq	$8, %rdi
	sarq	$3, %rsi
	addq	$8, %rsi
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$15, %rsp
	and	$-16, %rsp
	call	_f_open
	leave
	cmpq	$-1, %rax
	jz	_return_error
	movq	$1, (%r12)
	movq	%rax, 8(%r12)
	leaq	4(, %r12, 8), %rax
	addq	$16, %r12
	xorq	%rbx, %rbx
	ret

	.global _io_popen
	# %rdi: filename
_io_popen:
	sarq	$3, %rdi
	addq	$8, %rdi
	sarq	$3, %rsi
	addq	$8, %rsi
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$15, %rsp
	and	$-16, %rsp
	call	_p_open
	leave
	cmpq	$-1, %rax
	jz	_return_error
	movq	$1, (%r12)
	movq	%rax, 8(%r12)
	leaq	4(, %r12, 8), %rax
	addq	$16, %r12
	xorq	%rbx, %rbx
	ret

	.global _io_read
	# %rdi: file, %rsi: mem, %rdx: mode, %rcx: max
_io_read:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%r15, (%r12)
	movq	$2, %rax
	call	_nil_fill
	cmpq	$1, (%r12)
	jnz	_orc
	incq	(%r12)
_orc:	call	_varargs
	cmpq	$17, %rdi
	jz	_o_in
	sarq	$3, %rdi
	movq	8(%rdi), %rdi
_o_in:	movq	%rsp, %rbx
	sarq	$3, %r15
	movq	(%r15), %rdx
_o_lp:	movq	%r12, %rsi
	movq	%rdx, %rax
	andq	$7, %rax
	cmpq	$6, %rax
	jz	_o_db
	cmpq	$2, %rax
	jnz	_o_mx
	sarq	$3, %rdx
	addq	$8, %rdx
	jmp	_o_mx
_o_db:	sarq	$3, %rdx
	movq	(%rdx), %xmm0
	cvtsd2si %xmm0, %rcx
	movq	$33, %rdx
	jmp	_o_dt
_o_mx:	movq	_mem_max(%rip), %rcx
	subq	%r12, %rcx
_o_dt:	pushq	%rdi
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$15, %rsp
	andq	$-16, %rsp
	call	_f_read
	leave
	popq	%rdi
	cmpq	$-1, %rax
	jz	_o_err
	jns	_o_str
	leaq	6(, %r12, 8), %rax
	addq	$8, %r12
	pushq	%rax
	jmp	_o_cmp
_o_str:	addq	%r12, %rax
	xchgq	%rax, %r12
	leaq	2(, %rax, 8), %rax
	addq	$7, %r12
	andq	$-8, %r12
	pushq	%rax
_o_cmp:	subq	$8, %r15
	movq	(%r15), %rdx
	cmpq	$33, %rdx
	jnz	_o_lp
_o_en:	movq	-8(%rbx), %rax
	movq	$33, -8(%rsp)
	subq	$16, %rbx
	cmpq	%rbx, %rsp
	leaq	16(%rbx), %rsp
	jg	_o_no
	leave
	ret
_o_no:	xorq	%rbx, %rbx
	leave
	ret
_o_err:	leave
	jmp	_return_error

	.global	_io_close
	# %rdi: file
_io_close:
	cmpq	$17, %rdi
	jz	_close
	sarq	$3, %rdi
	movq	%rdi, %r15
	movq	8(%rdi), %rdi
	movq	$17, 8(%r15)
_close:	pushq	%rbp
	movq	%rsp, %rbp
	subq	$15, %rsp
	andq	$-16, %rsp
	call	_f_close
	leave
	movq	$17, %rax
	xorq	%rbx, %rbx
	ret

	.global	_io_flush
	# %rdi: file
_io_flush:
	cmpq	$17, %rdi
	jz	_flush
	sarq	$3, %rdi
	movq	%rdi, %r15
	movq	8(%rdi), %rdi
	movq	$17, 8(%r15)
_flush:	pushq	%rbp
	movq	%rsp, %rbp
	subq	$15, %rsp
	andq	$-16, %rsp
	call	_f_flush
	leave
	movq	$17, %rax
	xorq	%rbx, %rbx
	ret

	.global _io_type
	# %rdi: file
_io_type:
	movq	%rdi, %rax
	andq	$7, %rax
	cmpq	$4, %rax
	jnz	_return_error
	sarq	$3, %rdi
	cmpq	$1, (%rdi)
	jnz	_return_error
	cmpq	$17, 8(%rdi)
	jz	_t_c
	leaq	_ftype(%rip), %rax
	leaq	2(, %rax, 8), %rax
	xorq	%rbx, %rbx
	ret
_t_c:	leaq	_ctype(%rip), %rax
	leaq	2(, %rax, 8), %rax
	xorq	%rbx, %rbx
	ret

	.global _io_lines
	# %rdi: filename
_io_lines:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$15, %rsp
	andq	$-16, %rsp
	sarq	$3, %rdi
	addq	$8, %rdi
	leaq	_r_str(%rip), %rsi
	call	_f_open
	movq	%rax, 8(%r12)
	movq	$1, (%r12)
	leaq	4(, %r12, 8), %rdi
	addq	$16, %r12
	leaq	_line_iter2(%rip), %rax
	movq	%rax, (%r12)
	movq	$17, 8(%r12)
	leaq	7(, %r12, 8), %rax
	addq	$16, %r12
	movq	%rdi, 8(%r12)
	movq	$33, (%r12)
	leaq	8(%r12), %rbx
	leave
	ret	
	
	/*.global _io_lines
	# %rdi: file
_io_lines:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$15, %rsp
	andq	$-16, %rsp
	sarq	$3, %rdi
	addq	$8, %rdi
	leaq	_r_str(%rip), %rsi
	call	_f_open
	movq	%rax, %rdi
	subq	$8, %rsp
	pushq	%rdi
	call	_ol_tp
	xchg	%rax, (%rsp)
	movq	%rax, %rdi
	call	_f_close
	popq	%rax
	leave
	ret*/

	.global _io_output
	# %rdi: file
_io_output:
	cmpq	$17, %rdi
	jz	_i_out
	sarq	$3, %rdi
	movq	8(%rdi), %rdi
_i_out:	pushq	%rbp
	movq	%rsp, %rbp
	subq	$15, %rsp
	andq	$-16, %rsp
	call	_output
	movq	%rax, 8(%r12)
	movq	$1, (%r12)
	leaq	4(, %r12, 8), %rax
	addq	$16, %r12
	xorq	%rbx, %rbx
	leave
	ret

	.global _io_input
	# %rdi: file
_io_input:
	cmpq	$17, %rdi
	jz	_i_in
	sarq	$3, %rdi
	movq	8(%rdi), %rdi
_i_in:	pushq	%rbp
	movq	%rsp, %rbp
	subq	$15, %rsp
	andq	$-16, %rsp
	call	_input
	movq	%rax, 8(%r12)
	movq	$1, (%r12)
	leaq	4(, %r12, 8), %rax
	addq	$16, %r12
	xorq	%rbx, %rbx
	leave
	ret

	.global _get_stderr
_get_stderr:
	movq	%r12, %rdi
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$15, %rsp
	andq	$-16, %rsp
	call	_err
	leave
	leaq	4(, %r12, 8), %rax
	addq	$16, %r12
	xorq	%rbx, %rbx
	ret

############## OS Functions ###############

	.global _os_exec
_os_exec:
	cmpq	$17, %rdi
	jz	_exec_call
	sarq	$3, %rdi
	addq	$8, %rdi
_exec_call:
	subq	$8, %rsp #stack alignment
	call	_o_exec
	addq	$8, %rsp
	cvtsi2sd %rax, %xmm0
	movsd	%xmm0, (%r12)
	leaq	6(, %r12, 8), %rax
	addq	$8, %r12
	xorq	%rbx, %rbx
	ret

	.global _fill_args
_fill_args:
	movq	(%rbp), %rax
	movq	8(%rax), %rcx  # argv
	movq	16(%rax), %rdx # argc
	sarq	$3, %rdi
	xorq	%r8, %r8
_fl_lp:	cmpq	%r8, %rdx
	jz	_fl_en
	movq	(%rcx), %rax
	movq	$-1, %rbx
_new_string:
	incq	%rbx
	movb	(%rbx, %rax, ), %sil
	movb	%sil, 8(%rbx, %r12, )
	cmpb	$0, %sil
	jnz	_new_string
	movq	%rbx, (%r12)
	leaq	2(, %r12, 8), %r9
	leaq	9(%rbx, %r12, ), %r12
	addq	$7, %r12
	andq	$-8, %r12
	leaq	(, %r8, 8), %rax
	movq	%rdi, %rbx
	call	_i_new
	movq	%r9, (%rax)
	dec	%rdx
	jmp	_fl_lp
_fl_en:	ret

# DATA
################################################################################
	#.data

_db1:
	.double	1

_r_str:
	.asciz	"r"

_l_str:
	.asciz	"l"
	
_ftype:
	.quad	4
	.asciz	"file"
_ctype:
	.quad	11
	.asciz	"closed file"
