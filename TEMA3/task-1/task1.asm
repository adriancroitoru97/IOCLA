section .text
	global sort

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
	enter 0, 0
	
	; int n					[ebp + 8]
	; struct node* node 	[ebp + 12]

	; Loop from 1 to n. Then loop the array of nodes.
	; When the node with the value of the outter loop is found, it's marked
	; as the previous node next and it's pushed on the stack.
	mov 	ecx, 1
	loop_all_numbers:
		cmp 	ecx, [ebp + 8]
		jg 		done

		mov 	edx, 0
		loop_array:
			cmp 	edx, [ebp + 8]
			je 		done_loop_array

			; current node val is compared with the searched value in
			; the outter loop
			mov 	ebx, [ebx + edx * 8]	
			cmp 	ebx, ecx
			jne 	done_loop_array_iteration

			; check if the current found node is the root
			cmp 	ecx, 1
			jne 	normal_case

			; root node case - the root node is added on stack
			mov 	ebx, [ebp + 12]
			lea 	ebx, [ebx + edx * 8]
			push 	ebx

			; all nodes excepting the root
			normal_case:
				pop 	eax						; previous node
				add 	eax, byte 4				; previous node->next

				mov 	ebx, [ebp + 12]

				push 	ecx						; TEMPORARY REGISTER STORAGE
				
				lea 	ecx, [ebx + edx * 8]	; current node address
				mov 	[eax], ecx				; previous_node->next = current_node

				pop 	ecx						; TEMPORARY REGISTER STORAGE done

				sub 	eax, 4
				push 	eax						; repush the previous node
				push 	dword [eax + 4]			; push the new found node
			done_loop_array_iteration:
			mov 	ebx, [ebp + 12]
			add 	edx, 1
			jmp 	loop_array	
		done_loop_array:
		add 	ecx, 1
		jmp 	loop_all_numbers
	done:
		; the stack is freed, excepting the last element, the root,
		; which will be popped in eax - the return of the function
		mov 	eax, [ebp + 8]
		mov 	ebx, 4
		mul		ebx
		sub 	eax, 4

		add 	esp, eax
		pop 	eax

	leave
	ret
