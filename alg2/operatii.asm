extern strlen
extern strcmp
extern qsort
section .text
global sort
global get_words

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor
;  dupa lungime si apoi lexicografix
sort:
    ; create a new stack frame
    enter 0, 0
    push ebx



    ; **words
    mov edi, [ebp + 8]
    ; number of words
    mov esi, [ebp + 12]
    ; size
    mov edx, [ebp + 16]
    push compare_size
    push edx
    push esi
    push edi

    call qsort
    ;refac stiva
    add esp, 16

    pop ebx
    xor eax, eax
    leave
    ret

compare_size:
    ; create a new stack frame
    enter 0, 0
    push ebx
    push esi
    push edi


    ; a
    mov eax, [ebp+8]
    ; *a
    mov eax, [eax]      
    ; b
    mov ebx, [ebp+12]    
    ; *b
    mov ebx, [ebx]       

    push ecx
    push edx

    push eax
    call strlen
    ;refac stiva
    add esp, 4

    pop edx
    pop ecx

    mov edx, eax

    push ecx
    push edx

    push ebx
    call strlen
    ;refac stiva
    add esp, 4
    pop edx
    pop ecx

    mov ebx, eax
    mov eax, edx


    sub eax, ebx


    pop edi
    pop esi


    ;verific daca am ajuns la final
    cmp eax, 0
    jne fin
    ; a
    mov eax, [ebp + 8]    
    ; *a
    mov eax, [eax]       
    ; b
    mov ebx, [ebp + 12]    
    ; *b
    mov ebx, [ebx]       


    push ecx
    push edx

    push ebx
    push eax
    call strcmp
    ;refac stiva
    add esp, 8



    pop edx
    pop ecx



fin:

    pop ebx

    leave
    ret





;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    ; create a new stack frame
    enter 0, 0
    push ebx
    ; char *s
    mov esi, [ebp + 8]
    ; char **words
    mov edi, [ebp + 12]

    ;initializez ecx cu 0
    mov ecx, 0
    ;initializez ebx cu 0
    mov ebx, 0
for1:
    ; calculezi adresa începutului de cuvânt
    lea eax, [esi + ebx]       
    ;mut eax in words
    mov [edi + ecx * 4], eax
    ;compar eax cu 32
    cmp BYTE [eax], 32
    je discard_space
continue_space:


    jmp go_while
stop_while:
    ;pun NULL
    mov byte [esi + ebx], 0
    inc ebx
    inc ecx
    ;compar cu lungimea
    cmp ecx,[ebp + 16]
    jge end_for1
    jmp for1


go_while:
    ;iau fiecare litera
    mov al, BYTE [esi + ebx]
    ;verific daca e NULL
    cmp al, 0
    je end_for1

    ;verific daca e spatiu
    cmp al, 32
    je stop_while

    cmp al, '.'
    je skip_char
    cmp al, ','
    je skip_char

    inc ebx
    jmp go_while

skip_char:
    ;pun NULL
    mov BYTE [esi + ebx], 0
    inc ebx
    jmp go_while


discard_space:

    jmp continue_space


end_for1:




    pop ebx
    xor eax, eax
    leave
    ret

