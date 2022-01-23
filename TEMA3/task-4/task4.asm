section .text

global expression
global term
global factor

; `factor(char *p, int *i)`
;       Evaluates "(expression)" or "number" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
factor:
        push    ebp
        mov     ebp, esp

        ; ecx = *i
        mov     ebx, [ebp + 8]
        mov     ecx, [ebp + 12]
        mov     ecx, [ecx]

        ; if (p[*i] == '(')
        cmp     [ebx + ecx], byte 40
        jne     convert_number
                ; *i = *i + 1
                mov     eax, [ebp + 12]
                add     [eax], dword 1

                ; eax = expression(p, i)
                push    dword [ebp + 12]
                push    dword [ebp + 8]
                call    expression
                add     esp, 8

                ; *i = *i + 1
                mov     ebx, [ebp + 12]
                add     [ebx], dword 1
                jmp     done_factor

        ; else - converts a number from string to int
        convert_number:
                xor     eax, eax
                loop_string:
                        ; ecx = *i;
                        mov     ecx, [ebp + 12]
                        mov     ecx, [ecx]

                        ; if (p[*i] is a digit)
                        cmp     [ebx + ecx], byte 48
                        jl      done_factor
                        cmp     [ebx + ecx], byte 57
                        jg      done_factor
                                ; multiply the current number with 10
                                mov     edx, 10
                                mul     edx

                                ; push the current number
                                push    eax

                                ; eax = current digit
                                xor     eax, eax
                                mov     al, [ebx + ecx]
                                sub     eax, 48

                                ; ebx = current number * 10
                                pop     ebx

                                ; eax = current number * 10 + new_digit
                                add     ebx, eax
                                mov     eax, ebx
                                mov     ebx, [ebp + 8]
                                
                                ; *i = *i + 1
                                mov     ecx, [ebp + 12]
                                add     [ecx], dword 1
                                jmp     loop_string
        done_factor:

        leave
        ret

; `term(char *p, int *i)`
;       Evaluates "factor" * "factor" or "factor" / "factor" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
term:
        push    ebp
        mov     ebp, esp

        ; eax = factor (p, i)
        push    dword [ebp + 12]
        push    dword [ebp + 8]
        call    factor
        add     esp, 8

        ; while (p[*i] == '*')
        mul_loop:
                ; ecx = *i
                ; ebx = p;
                mov     ebx, [ebp + 8]
                mov     ecx, [ebp + 12]
                mov     ecx, [ecx]

                ; if (p[*i] == '*')
                cmp     [ebx + ecx], byte 42
                jne     mul_loop_done
                        ; *i = *i + 1
                        mov     ecx, [ebp + 12]
                        add     [ecx], dword 1

                        ; push current result
                        push    eax
                        
                        ; eax = factor(p, i)
                        push    dword [ebp + 12]
                        push    dword [ebp + 8]
                        call    factor
                        add     esp, 8
                        
                        ; eax - current result
                        ; ebx - new result
                        mov     ebx, eax
                        pop     eax

                        ; eax = eax * ebx;
                        mov     eax, eax
                        mov     ebx, ebx
                        imul    ebx

                        jmp     mul_loop
        mul_loop_done:

        ; while (p[*i] == '/')
        div_loop:
                ; ecx = *i
                ; ebx = p;
                mov     ebx, [ebp + 8]
                mov     ecx, [ebp + 12]
                mov     ecx, [ecx]

                ; if (p[*i] == '/')
                cmp     [ebx + ecx], byte 47
                jne     div_loop_done
                        ; *i = *i + 1
                        mov     ecx, [ebp + 12]
                        add     [ecx], dword 1

                        ; push current result
                        push    eax

                        ; eax = factor(p, i)
                        push    dword [ebp + 12]
                        push    dword [ebp + 8]
                        call    factor
                        add     esp, 8

                        ; eax - current result
                        ; ebx - new result
                        mov     ebx, eax
                        pop     eax

                        ; eax = eax / ebx
                        mov     eax, eax
                        mov     ebx, ebx
                        cdq
                        idiv    ebx
                        
                        jmp     div_loop
        div_loop_done:

        ; if (p[*i] == '*')
        cmp     [ebx + ecx], byte 42
        je      mul_loop

        done_term:

        leave
        ret

; `expression(char *p, int *i)`
;       Evaluates "term" + "term" or "term" - "term" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
expression:
        push    ebp
        mov     ebp, esp

        ; eax = term(p, i)
        push    dword [ebp + 12]
        push    dword [ebp + 8]
        call    term
        add     esp, 8

        ; while (p[*i] == '+')
        plus_loop:
                ; ecx = *i
                ; ebx = p;
                mov     ebx, [ebp + 8]
                mov     ecx, [ebp + 12]
                mov     ecx, [ecx]

                ; if (p[*i] == '+')
                cmp     [ebx + ecx], byte 43
                jne     plus_loop_done
                        ; *i = *i + 1
                        mov     ecx, [ebp + 12]
                        add     [ecx], dword 1

                        ; push current result
                        push    eax

                        ; eax = term(p, i);
                        push    dword [ebp + 12]
                        push    dword [ebp + 8]
                        call    term
                        add     esp, 8
                        
                        ; eax - current result
                        ; ebx - new result
                        mov     ebx, eax
                        pop     eax

                        ; eax = eax + ebx;
                        add     eax, ebx
                
                        jmp     plus_loop
        plus_loop_done:
        
        ; while (p[*i] == '-')
        minus_loop:
                ; ecx = *i
                ; ebx = p;
                mov     ebx, [ebp + 8]
                mov     ecx, [ebp + 12]
                mov     ecx, [ecx]

                ; if (p[*i] == '-')
                cmp     [ebx + ecx], byte 45
                jne     minus_loop_done
                        ; *i = *i + 1
                        mov     ecx, [ebp + 12]
                        add     [ecx], dword 1

                        ; push current result
                        push    eax

                        ; eax = term(p, i)
                        push    dword [ebp + 12]
                        push    dword [ebp + 8]
                        call    term
                        add     esp, 8

                        ; eax - current result
                        ; ebx - new result
                        mov     ebx, eax
                        pop     eax

                        ; eax = eax - ebx;
                        sub     eax, ebx
                        
                        jmp     minus_loop
        minus_loop_done:

        ; if (p[*i] == '+')
        cmp     [ebx + ecx], byte 43
        je      plus_loop

        done_expression:

        leave
        ret
