struc node
    .val resd 1
    .next resd 1
endstruc

global sort
extern printf
section .data
    fmt db "Min: %d", 10, 0
    ;variabila de final
    var_fin dd 0
    ;lungimea
    len dd 0 

section .text




;; struct node* sort(int n, struct node* node);
;   The function will link the nodes in the array
;   in ascending order and will return the address
;   of the new found head of the list
; @params:
;   n -> the number of nodes in the array
;   node -> a pointer to the beginning in the array
;   @returns:
;   the address of the head of the sorted list
sort:
    ; create a new stack frame
    enter 0, 0
    xor eax, eax
    push ebx
    push esi
    push edi
    ; int n
    mov esi, [ebp + 8] 
    ; struct *node
    mov edi, [ebp + 12]
    ; il initializez cu 1
    mov eax, 1
    ; fac eax maxim
    shl eax, 30

    xor ecx, ecx
init_loop:
    ;fac adresele nulle
    mov [edi + ecx * 8 + node.next], dword 0
    inc ecx
    cmp ecx, esi
    jl init_loop
    xor ecx, ecx

min_for:
    push ebx
    ;pun adresa in ebx
    mov ebx, [edi + ecx * 8 + node.next]
    ; verific daca a fost pusa sau nu
    cmp ebx, 0
    pop ebx
    je compare_func

continue_min:
    inc ecx
    cmp ecx, esi
    jge min_end_for
    jl min_for

compare_func:
    push edx
    ;iau valoarea din structura
    mov edx, [edi + ecx * 8 + node.val]
    cmp edx, eax
    jl swap

prev_swap:
    pop edx
    jmp continue_min

swap:
    mov eax, edx
    ;iau adresa nodului
    lea ebx, [edi + ecx * 8]
    jmp prev_swap


min_end_for:
    push ebx
    ; salvam adresa nodului cu valoarea 1
    mov [var_fin], ebx
    xor ecx, ecx
    ; valoarea curenta cautata (începem de la 1)
    mov ecx, 1
    ; edx = nodul curent
    mov edx, ebx

link_loop:
    inc ecx
    ; compar cu lungimea
    cmp ecx, [ebp + 8]
    jg done_linking
    xor esi, esi

find_node:
    ; iau valoarea din nod
    mov eax, [edi + esi*8 + node.val]
    cmp eax, ecx
    je found_node
    inc esi
    ; compar cu lungimea
    cmp esi, [ebp + 8]
    jl find_node
    ; fallback nu ar trebui sa ajunga aici daca toate valorile sunt prezente
    jmp link_loop          

found_node:
    ; iau adresa elementului
    lea eax, [edi + esi*8]
    mov [edx + node.next], eax
    mov edx, eax
    jmp link_loop

done_linking:
    ; pun pe nodul final adresa NULL
    mov dword [edx + node.next], 0
    mov eax, [var_fin]
    pop ebx

    pop ebx
    mov eax, [var_fin]

    pop ebx
    pop edi
    pop esi
    pop ebx


    leave
    ret

section .note.GNU-stack.