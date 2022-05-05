jmp read_input
temp dw 0

read_input:
   mov ah, 01h
   int 21h
   mov bl, al
   mov bh, 0h
   cmp bl, ' '
   je push_to_stack
   cmp bl, '+'
   je addition
   cmp bl, '*'
   je multiply
   cmp bl, '/'
   je divide
   cmp bl, '^'
   je bitXor
   cmp bl, '&'
   je bitAnd
   cmp bl, '|'
   je bitOr
   cmp bl, 0d
   je print_result
   mov ax, temp
;   mov cx, 16d
   mov cx, 10h
   mul cx
   cmp bl, '@'
   jb process_number
   ja process_letter

process_number:
   sub bx, 30h
   add ax, bx
   mov temp, ax
   jmp read_input

process_letter:
   sub bx, 37h
;   add dx, 10d
   add ax, bx
   mov temp, ax
   jmp read_input

addition:
   pop ax
   pop dx
   add ax, dx
   mov temp, ax
   jmp read_input

multiply:
   pop ax
   pop cx
   mul cx
   mov temp, ax
   jmp read_input

divide:
   pop ax
   pop dx
   div dx
   mov temp,ax
   jmp read_input

bitXor:
   pop ax
   pop cx
   xor ax, cx    ;xors ax with bx and writes it in ax
   mov temp,ax
   jmp read_input 

bitAnd:
   pop ax
   pop cx
   and ax, cx    ;ands ax with bx and writes it in ax
   mov temp,ax
   jmp read_input 

bitOr:
   pop ax
   pop cx
   or ax, cx    ;ors ax with bx and writes it in ax
   mov temp,ax
   jmp read_input 

push_to_stack:
   mov ax, temp
   push ax
   mov temp, 0h
   jmp read_input

print_result:
   mov bx, temp
   jmp string_set
   num dw 4 dup 0
   cr dw 10, "$"

string_set:
    mov ax, bx
    mov bx, offset num+3
    mov b[bx], "$"
    dec bx

convert:
    mov dx, 0
    mov cx, 10h
    div cx
    cmp dx, 9h
    ja more_than_nine
    add dx, 30h
    jmp move_on
    
more_than_nine:
    add dx, 37h

move_on:
    mov [bx], dl
    dec bx
    cmp ax, 00
    jnz convert

cmp bx, num-2
jb here

leading_zeros:
    mov b[bx], 0030h
    dec bx
    cmp bx, num-2
    jae leading_zeros

here:
    mov ah, 09
    mov dx, offset cr
    int 21h

print:
    mov dx, bx
    inc dx
    mov ah, 09
    int 21h

close:
    mov ah, 04ch
    mov al, 00
    int 21h

