;; defining constants, you can use these as immediate values in your code
CACHE_LINES  EQU 100
CACHE_LINE_SIZE EQU 8
OFFSET_BITS  EQU 3
TAG_BITS EQU 29 ; 32 - OFSSET_BITS
FIRST_THREE_BITS EQU 7


section .text
    global load
    extern printf

section .data
    reg                     DD 0
    tags                    DD 0
    cache                   DD 0
    address                 DD 0
    address_tag             DD 0
    address_offset          DD 0
    first_address_in_cache  DD 0

;; void load(char* reg, char** tags, char cache[CACHE_LINES][CACHE_LINE_SIZE], char* address, int to_replace);
load:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; address of reg
    mov ebx, [ebp + 12] ; tags
    mov ecx, [ebp + 16] ; cache
    mov edx, [ebp + 20] ; address
    mov edi, [ebp + 24] ; to_replace (index of the cache line that needs to be replaced in case of a cache MISS)
    ;; DO NOT MODIFY

    ;; TODO: Implment load
    ;; FREESTYLE STARTS HERE

    mov [reg], eax
    mov [tags], ebx
    mov [cache], ecx
    mov [address], edx

    mov eax, [address]
    shr eax, OFFSET_BITS
    mov [address_tag], eax

    mov eax, [address]
    and eax, FIRST_THREE_BITS
    mov [address_offset], eax

    ; loop tags array
    xor ecx, ecx
    loop_tags:
        cmp ecx, CACHE_LINES
        je cache_miss
        
        mov eax, [tags]
        mov ebx, [address_tag]
        cmp [eax + ecx * 4], ebx
        je cache_hit

        inc ecx
        jmp loop_tags

    ; the address tag was found in the tags array
    cache_hit:
        ; *reg = cache[to_replace * CACHE_LINE_SIZE + address_offset]
        xor eax, eax
        xor ebx, ebx
        mov ax, cx
        mov bx, CACHE_LINE_SIZE
        mul bx
        
        add eax, [address_offset]

        mov ebx, [reg]
        mov ecx, [cache] 
        mov ebx, [ecx + eax]

        jmp done

    ; address tag not found, cache has to be updated
    cache_miss:
        mov eax, [address_tag]
        shl eax, OFFSET_BITS
        mov [first_address_in_cache], eax

        xor eax, eax
        xor ebx, ebx
        add eax, edi ; to_replace

        mov ax, ax
        mov bx, CACHE_LINE_SIZE
        mul bx ; eax stores the index of line of cache to be modified

        xor ecx, ecx
        loop_cache_line:
            cmp ecx, CACHE_LINE_SIZE
            je cache_miss_done

            add eax, ecx ; eax - final index of cache to be modified

            mov ebx, [cache]
            add ebx, eax

            ; update cache
            mov edx, [first_address_in_cache]
            add edx, ecx
            mov edx, [edx]
            mov [ebx], edx

            sub eax, ecx

            inc ecx
            jmp loop_cache_line

    ; cache updated
    cache_miss_done:
        ; update the value of reg
        mov ebx, [reg]
        mov ecx, [cache]
        add ecx, eax
        add ecx, [address_offset]
        mov ecx, [ecx]
        mov [ebx], ecx

        ; also update the tags array
        mov eax, [tags]
        mov ebx, [address_tag]
        mov [eax + edi * 4], ebx

    done:

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
