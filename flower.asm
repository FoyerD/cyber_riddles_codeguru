mov bx, 0xff20
bottom_line:
    mov byte [bx], 0x1
    inc bx
    cmp word bx, 0xffe0
    jnz bottom_line

mov bx, 0xff80
vertical_line:
    mov byte [bx], 0x1
    sub word bx, 0x100
    cmp word bx, 0x8080
    jnz vertical_line

mov bx, 0x4030
mov ax, 0x8
left_diagonal:
    mov byte [bx], 0x1
    add word bx, 0x102
    dec ax
    test ax, ax
    jnz left_diagonal

mov bx, 0x40d0
mov ax, 0x8
right_diagonal:
    mov byte [bx], 0x1
    add word bx, 0xfe
    dec ax
    test ax, ax
    jnz right_diagonal

finish:
    jmp finish


