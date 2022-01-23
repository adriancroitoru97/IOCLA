global get_words
global compare_func
global sort

section .text
    extern qsort
    extern strlen
    extern strcmp
    extern strtok

section .data
    delimiters DB " ,.", 10, 0

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter   0, 0

    push    compare_func
    push    dword [ebp + 16]
    push    dword [ebp + 12]
    push    dword [ebp + 8]
    call    qsort
    add     esp, 16

    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter   0, 0

    ; ebx holds the initial string - s
    mov     ebx, [ebp + 8]

    ; strtok function is used to break the string into words
    push    dword delimiters
    push    ebx
    call    strtok
    add     esp, 8

    xor     ebx, ebx
    strtok_loop:
        cmp     eax, 0
        je      done_get_words

        mov     edx, [ebp + 12]
        mov     [edx + ebx * 4], eax

        push    dword delimiters
        push    0
        call    strtok
        add     esp, 8

        add     ebx, 1
        jmp     strtok_loop
    done_get_words:

    leave
    ret

;; compare function used by qsort. strlen and strcmp involved
compare_func:
    enter   0, 0

    ; sir1 - [ebp + 8]
    ; sir2 - [ebp + 12]

    ; ebx = strlen(sir1)
    mov     eax, [ebp + 8]
    push    dword [eax]
    call    strlen
    add     esp, 4
    mov     ebx, eax    

    ; eax = strlen(sir2)
    mov     eax, [ebp + 12]
    push    dword [eax]
    call    strlen
    add     esp, 4

    ; compare string lengths
    cmp     ebx, eax
    jl      lower
    je      equal
    jg      greater

    lower:
        ; return -1
        mov     eax, -1
        jmp     done_compare
    greater:
        ; return 1
        mov     eax, 1
        jmp     done_compare
    equal:
        ; return strcmp(sir1, sir2)
        mov     eax, [ebp + 12]
        mov     ebx, [ebp + 8]
        push    dword [eax]
        push    dword [ebx]
        call    strcmp
        add     esp, 8
    done_compare:

    leave
    ret
