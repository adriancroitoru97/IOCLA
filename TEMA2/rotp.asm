section .text
    global rotp

;; void rotp(char *ciphertext, char *plaintext, char *key, int len);
rotp:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; ciphertext
    mov     esi, [ebp + 12] ; plaintext
    mov     edi, [ebp + 16] ; key
    mov     ecx, [ebp + 20] ; len
    ;; DO NOT MODIFY

    ;; TODO: Implment rotp
    ;; FREESTYLE STARTS HERE

    xor eax, eax
    add eax, ecx ; eax stores len, as the original ecx it will be decremented during loop

    string_loop:
        sub ecx, 1

        sub eax, ecx
        
        mov bl, byte [esi + ecx] ; bl contains plaintext[i]
        xor bl, byte [edi + eax - 1] ; plaintext[i] ^ key[len - i - 1];
        mov [edx + ecx], bl ; ciphertext[i] = plaintext[i] ^ key[len - i - 1];

        add eax, ecx
        
        cmp ecx, 0
        jne string_loop
    
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
    