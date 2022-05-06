temp dw 0               ; temp will store the number being read
jmp read_input

read_input:
    mov ah, 01h
    int 21h             ; next char is read to al
    mov dl, al          ; char is STORED in DL
    cmp dl, 0D          ; end of line
    je print_result     ; printing part will start
    cmp dl, ' '         ; if the char is ' ', the number is compeletly read and currently stored in temp
    je push_to_stack
    cmp dl, '+'         ; if the char is an operation symbol, jump to the corresponding label 
    je addition
    cmp dl, '*'         ; !!Necessary pop actions can be done inside operation labels
    je multiply
    cmp dl, '/'
    je divide
    cmp dl, '^'
    je bitXor
    cmp dl, '&'
    je bitAnd
    cmp dl, '|'
    je bitOr
    ; or the char being read is a number:
    mov ax, temp        ; current number is moved to AX
    mov cx 16d
    mul cx              ; ax is multiplied by 16
    cmp dl, '@'
    jb process_number   ; al is between 0-9, inclusive
    ja process_letter   ; al is between A-F, inclusive
    
process_number:
    sub dl, '0'
    add ax, dl 
    mov temp, ax        ; current number is again in TEMP
    jmp read_input

process_letter:
    sub dl, 'A'         ; now if dl is 'A', its value becomes 0. But it should be 10:
    add dl, 10d 
    add ax, dl 
    mov temp, ax        ; current number is again in TEMP
    jmp read_input


push_to_stack:
    mov ax, temp        ; since I am not sure if we can directly push temp to the stack, 
    push ax             ; I used an intermediate variable  
    mov temp, 0d        ; temp is cleaned for the new number to be read
    jmp read_input

print_result:
    pop bx              ; the only number in the stack will be popped to be read 
    ; NOW, bx is in decimal
    ; first, it should be converted to hexadecimal to be printed
    jmp string_set      ; this might be the wrong label name :<

end
