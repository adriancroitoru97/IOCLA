section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b
cmmmc:
	; enter
	push 	ebp
	push 	esp
	pop 	ebp

	; eax holds int a
	; ebx holds int b
	push 	dword [ebp + 8]
	pop 	eax
	push 	dword [ebp + 12]
	pop 	ebx

	; while (a != b)
	find_cmmmc:
		cmp 	eax, ebx
		je 		done
		jl 		add_eax
		jg 		add_ebx

		add_eax:
			add 	eax, [ebp + 8]
			jmp 	find_cmmmc

		add_ebx:
			add 	ebx, [ebp + 12]
			jmp 	find_cmmmc
	done:

	; leave
	push 	ebp
	pop 	esp
	pop 	ebp

	ret
