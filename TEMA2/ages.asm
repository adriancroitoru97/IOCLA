; This is your structure
struc  my_date
    .day: resw 1
    .month: resw 1
    .year: resd 1
endstruc

section .text
    global ages

; void ages(int len, struct my_date* present, struct my_date* dates, int* all_ages);
ages:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; present
    mov     edi, [ebp + 16] ; dates
    mov     ecx, [ebp + 20] ; all_ages
    ;; DO NOT MODIFY

    ;; TODO: Implement ages
    ;; FREESTYLE STARTS HERE

    loop_dates:
        sub edx, 1

        xor eax, eax
        mov ax, word [esi + my_date.year] ; current year

        xor ebx, ebx
        mov bx, word [edi + edx * 8 + my_date.year] ; current person's year

        cmp ax, bx
        jle age_is_zero
        jg positive_age
        
        age_is_zero:
            xor eax, eax
            jmp person_age_found
        positive_age:
            sub ax, bx ; current year - current person's year

            xor ebx, ebx
            mov bx, word [esi + my_date.month] ; current month

            cmp bx, [edi + edx * 8 + my_date.month] ; check if celebrated - month
            jl not_celebrated_yet
            je check_days
            jmp person_age_found

            check_days:
                xor ebx, ebx
                mov bx, word [esi + my_date.day] ; current day

                cmp bx, [edi + edx * 8 + my_date.day] ; check if celebrated - day
                jl not_celebrated_yet
                jmp person_age_found

            not_celebrated_yet:
                sub ax, 1

            jmp person_age_found

    person_age_found:
        mov [ecx + edx * 4], eax ; current person's age added to all_eges array
        cmp edx, 0
        jne loop_dates

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
