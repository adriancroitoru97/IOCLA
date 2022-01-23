section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	; enter
	push 	ebp
	push 	esp
	pop 	ebp

	; edx used for counting the number of opened and not closed yet brackets
	xor 	edx, edx
	xor 	ecx, ecx
	loop_string:
		cmp 	ecx, [ebp + 8]
		je 		true

		; eax holds char* str
		push 	dword [ebp + 12]
		pop 	eax

		; cmp the current character with '('
		cmp 	[eax + ecx], byte 40
		jne 	closed_bracket

		; add '(' on stack
		push 	byte 40		
		add 	edx, 1
		jmp 	end_loop_string_iteration

		; current character is ')'
		closed_bracket:
			cmp 	edx, 0
			jle 	false
			pop 	ebx
			sub 	edx, 1

		end_loop_string_iteration:
		add 	ecx, 1
		jmp 	loop_string

	true: 
		push 	dword 1
		pop 	eax
		jmp 	done

	false:
		push 	dword 0
		pop 	eax

	done:

	; leave
	push 	ebp
	pop 	esp
	pop 	ebp

	ret
