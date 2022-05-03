jmp start

num dw 4 dup 0  ;the result will be 16 bits
cr dw 10, "$"

start:     ;the result is kept in bx
  mov bx, 0023h
  mov dx, 003ah
  add bx, dx        ;trying to print the result of addition
  

;addition:
;  add ax, dx
;  jmp print
;
;multiply:
;  mul dx
;  jmp print
;
;divide:
;  div dx
;  jmp print
;  
;bitXor:
;  xor ax, bx     ;xors ax with bx and writes the result in ax
;  jmp print
;
;bitAnd:
;  and ax, bx
;  jmp print
;
;bitOr:
;  or ax, bx
;  jmp print
  

string_set:
  mov ax, bx   
  mov bx, offset num+3
  mov b[bx], "$"
  dec bx
  
convert:    ;converting from numbers to their ascii values
  mov dx, 0
  mov cx, 10h
  div cx
  cmp dx, 9h    ;if the digit is greater than 9, than it is not an integer
  ja more_than_nine
  add dx, 30h    ;add 30 if the character is an integer
  jmp move_on
  
more_than_nine:
  add dx, 37h    ;add 37 if the character is a,b,c,d,e or f
  
move_on:
  mov [bx], dl   ;add the current ascii value to the bx index of the string
  dec bx
  cmp ax, 00     ;check if we got the whole number
  jnz convert
  
cmp bx, num-2    ;if bx==num-2, leading_zeros are not needed
jb here

leading_zeros:   ;adding leading zeros until all the digits are full
  mov b[bx], 0030h
  dec bx
  cmp bx, num-2
  jae leading_zeros
  
here:
  mov ah, 09
  mov dx, offset cr
  int 21h
  
print:       ;print the result string
  mov dx, bx
  inc dx
  mov ah, 09
  int 21h
  
close:
  mov ah, 04ch
  mov al, 00
  int 21h
