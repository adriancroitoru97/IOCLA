section .data
    extern len_cheie, len_haystack
    var1    DD 0    ;; general purpose global variable
    var2    DD 0    ;; general purpose global variable
    var3    DD 0    ;; general purpose global variable
    var4    DD 0    ;; general purpose global variable
    ciphertext_adress   DD 0
    nr_columns  DD 0

section .text
    global columnar_transposition

;; void columnar_transposition(int key[], char *haystack, char *ciphertext);
columnar_transposition:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha 

    mov edi, [ebp + 8]   ;key
    mov esi, [ebp + 12]  ;haystack
    mov ebx, [ebp + 16]  ;ciphertext
    ;; DO NOT MODIFY

    ;; TODO: Implment columnar_transposition
    ;; FREESTYLE STARTS HERE
    
    ; final_string[k++] = initial_string[j * len_cheie + key[i]]
    ; formula used for finding every element in the ciphered new string

    mov [var4], byte 0 ; contor for ciphertext string (k in the above formula)

    mov [ciphertext_adress], ebx

    ; finding the nr of columns of the columnar transposition matrix
    xor edx, edx
    mov eax, [len_haystack]
    mov ecx, [len_cheie]
    div ecx
    cmp edx, 0
    je nr_columns_found
    add eax, 1

    nr_columns_found:
        mov [nr_columns], eax

    sub [nr_columns], byte 1
    
    xor ecx, ecx
    column_loop:
        cmp ecx, [len_cheie]
        je done;

        xor edx, edx
        line_loop:
            ; the formula transposed to asm

            ; store 'edx * [len_cheie]' in var1
            xor eax, eax
            xor ebx, ebx
            mov al, dl
            mov bl, [len_cheie]
            mul bl
            mov [var1], eax
            
            ; store 'edi + ecx * 4' in var2
            mov ebx, [edi + ecx * 4]
            mov [var2], ebx
            

            mov ebx, [ciphertext_adress]
            add ebx, [var4] ; current item of ciphered string
            
            mov [var3], ecx ; temporar store

            ; esi - current item to be added in the ciphered string
            mov ecx, [var1]
            add ecx, [var2]
            add esi, ecx

            cmp ecx, [len_haystack]
            jge invalid_char
            
            mov eax, [esi]
            mov [ebx], al
            add [var4], byte 1

            invalid_char:
            sub esi, ecx

            mov ecx, [var3] ; temporar store done
        
            cmp edx, [nr_columns]
            je line_loop_done
            inc edx
            jmp line_loop

        line_loop_done:
            inc ecx
            jmp column_loop

    done:

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
