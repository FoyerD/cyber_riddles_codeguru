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






put_pixels:
    ; ax=xc, bx=yc, si=x, dx=y
    push bp
    mov bp, sp

    push ax
    push bx
    push cx
    push dx
    push si
    push di


    mov cx, 8
    
    mov di, bx
    add di, dx
    shl di, cl 
    add di, ax
    add di, si
    mov byte [di], 1
    
    mov di, bx
    add di, dx
    shl di, cl 
    add di, ax
    sub di, si
    mov byte [di], 1
    
    mov di, bx
    sub di, dx
    shl di, cl 
    add di, ax
    add di, si
    mov byte [di], 1
    
    mov di, bx
    sub di, dx
    shl di, cl 
    add di, ax
    sub di, si
    mov byte [di], 1
    
    mov di, bx
    add di, si
    shl di, cl 
    add di, ax
    add di, dx
    mov byte [di], 1
    
    mov di, bx
    add di, si
    shl di, cl 
    add di, ax
    sub di, dx
    mov byte [di], 1
    
    mov di, bx
    sub di, si
    shl di, cl 
    add di, ax
    add di, dx
    mov byte [di], 1
    
    mov di, bx
    sub di, si
    shl di, cl 
    add di, ax
    sub di, dx
    mov byte [di], 1

    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret

