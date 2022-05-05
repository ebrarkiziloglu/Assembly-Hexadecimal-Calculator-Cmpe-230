jmp read_input     	  ; temp will store the number being read
temp dw 0

read_input:
   mov ah, 01h
   int 21h             ; next char is read to al
   mov bl, al          ; char is STORED in bl
   mov bh, 0h
   cmp bl, '+'         ; if the char is an operation symbol, jump to the corresponding label 
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
   cmp bl, ' '         ; if the char is ' ', the number is compeletly read and currently stored in temp
   je push_to_stack
   cmp bl, 0d          ; end of line
   je print_result     ; printing part will start
   mov ax, temp        ; or the char being read is a number, current number is moved to AX
   mov cx, 10h  
   mul cx              ; ax is multiplied by 16
   cmp bl, '@'
   jb process_number   ; al is between 0-9, inclusive
   ja process_letter   ; al is between A-F, inclusive
  
process_number:
   sub bx, 30h
   add ax, bx
   mov temp, ax        ; current number is in temp
   jmp read_input

process_letter:
   sub bx, 37h
   add ax, bx
   mov temp, ax        ; current number is again in temp
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
   pop cx
   pop ax
   mov dx, 0h
   div cx
   mov temp,ax
   jmp read_input

bitXor:
   pop ax
   pop cx
   xor ax, cx          ; xors ax with cx and writes it in ax
   mov temp,ax
   jmp read_input 

bitAnd:
   pop ax
   pop cx
   and ax, cx          ; ands ax with cx and writes it in ax
   mov temp,ax
   jmp read_input 

bitOr:
   pop ax
   pop cx
   or ax, cx           ; ors ax with cx and writes it in ax
   mov temp,ax
   jmp read_input 

push_to_stack:
   mov ax, temp
   push ax
   mov temp, 0h        ; temp is cleaned for the new number to be read
   jmp read_input

print_result:
   mov bx, temp        ; temp keeps the result
   jmp string_set
   num dw 4 dup 0      ; the result will be 16 bits
   cr dw 10, "$"

string_set:
    mov ax, bx
    mov bx, offset num+3
    mov b[bx], "$"
    dec bx

convert:               ; converting from numbers to their ascii values
    mov dx, 0
    mov cx, 10h
    div cx
    cmp dx, 9h         ; if the digit is greater than 9, than it is not an integer
    ja more_than_nine
    add dx, 30h        ; add 30 if the character is an integer
    jmp move_on
    
more_than_nine:
    add dx, 37h        ; add 37 if the character is a,b,c,d,e or f

move_on:
    mov [bx], dl       ; add the current ascii value to the bx index of the string
    dec bx
    cmp ax, 00         ; check if we got the whole number
    jnz convert

cmp bx, num-2          ; if bx==num-2, leading_zeros are not needed
jb here

leading_zeros:         ; adding leading zeros until all the digits are full
    mov b[bx], 0030h
    dec bx
    cmp bx, num-2
    jae leading_zeros

here:
    mov ah, 09
    mov dx, offset cr
    int 21h

print:                 ; print the result string
    mov dx, bx
    inc dx
    mov ah, 09
    int 21h

close:
    mov ah, 04ch
    mov al, 00
    int 21h

