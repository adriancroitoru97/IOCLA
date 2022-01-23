section .text
	global vectorial_ops

;; void vectorial_ops(int *s, int A[], int B[], int C[], int n, int D[])
;  
;  Compute the result of s * A + B .* C, and store it in D. n is the size of
;  A, B, C and D. n is a multiple of 16. The result of any multiplication will
;  fit in 32 bits. Use MMX, SSE or AVX instructions for this task.

vectorial_ops:
	push		rbp
	mov		rbp, rsp

	; rdi - s, rsi - A, rdx - B
	; rcx - C, r8 - n, r9 - D

	; ymm0 - [s, s, s, s, s, s, s, s]
	mov 	eax, edi
	shl 	rdi, 32
	or 		rdi, rax

	push 	rdi
	push 	rdi
	push 	rdi
	push 	rdi
	push 	rdi
	push 	rdi
	push 	rdi
	push 	rdi
	vmovdqu ymm0, [rsp]
	add 	rsp, 64

	xor 	rax, rax
	loop_full_array:
		cmp 	rax, r8
		je 		done_loop_full_array

		; ymm4 = s * A
		vmovups ymm1, [rsi + rax * 4]		; A
		vpmulld ymm1, ymm1, ymm0			; s * A
		vpxor 	ymm4, ymm4					; ymm4 = 0
		vaddpd 	ymm4, ymm4, ymm1			; ymm4 += s * A

		; ymm4 += B .* C
		vmovups ymm2, [rdx + rax * 4]		; B
		vmovups ymm3, [rcx + rax * 4]		; C
		vpmulld ymm1, ymm2, ymm3			; ymm1 = B .* C
		vaddpd 	ymm4, ymm4, ymm1			; ymm4 += B .* C
		vmovups [r9 + rax * 4], ymm4		; D = ymm4

		add 	rax, 8
		jmp 	loop_full_array
	done_loop_full_array:

	leave
	ret
