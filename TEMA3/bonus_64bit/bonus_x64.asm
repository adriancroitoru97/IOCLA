section .text
	global intertwine

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	enter 	0, 0

	; rdi - v1 ; rsi - n1
	; rdx - v2 ; rcx - n2
	; r8  - v

	; rax used for the loop of both arrays in the same time
	; rbx used for iterator of the newly created array v
	xor 	rax, rax
	xor 	rbx, rbx
	loop_both:
		; if (rax == n1)
		cmp 	rax, rsi
		je 		done_first_array
		; if (rax == n2)
		cmp 	rax, rcx
		je 		done_second_array

			; v[rbx++] = v1[rax]
			mov 	r9, [rdi + rax * 4]
			mov 	[r8 + rbx * 4], r9
			add 	rbx, 1

			; v[rbx++] = v2[rax]
			mov 	r9, [rdx + rax * 4]
			mov 	[r8 + rbx * 4], r9
			add 	rbx, 1

			add 	rax, 1
			jmp 	loop_both

	done_first_array:
		; if (rax == n2)
		cmp 	rax, rcx
		je 		done_all
		; v[rbx++] = v2[rax]
			mov 	r9, [rdx + rax * 4]
			mov 	[r8 + rbx * 4], r9
			add 	rbx, 1

			add 	rax, 1
			jmp 	done_first_array

	done_second_array:
		; if (rax == n1)
		cmp 	rax, rsi
		je 		done_all
		; v[rbx++] = v1[rax]
			mov 	r9, [rdi + rax * 4]
			mov 	[r8 + rbx * 4], r9
			add 	rbx, 1

			add 	rax, 1
			jmp 	done_second_array

	done_all:

	leave
	ret
