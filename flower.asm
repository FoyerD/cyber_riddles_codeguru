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

    mov ax, 0x80
    mov bx, 0x40
    lea dx, [0xa0-0x80]
    call draw_circle

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

draw_circle:
    ; ax=xc, bx=yc, dx=r
    push bp
    mov bp, sp

    push ax
    push bx
    push cx
    push dx
    push si
    push di
    sub sp, 6

    ; x=-14, y=-16, d=-18
    mov word [bp-14], 0
    mov word [bp-16], dx
    mov cx, 1
    mov di, dx
    shl di, cl
    mov cx, 3
    sub cx, di
    mov word [bp-18], cx

    mov word si, [bp-14]
    mov word dx, [bp-16]
    call put_pixels
    while_yGEx:
        mov di, [bp-16]
        mov si, [bp-14]
        cmp di, si
        jl done_while_yGEx

        cmp word [bp-18], 0
        jle dLE0
        dG0:
            dec word [bp-16]
            ; d += 4(x-y) + 10
            add word [bp-18], 10
            mov si, [bp-14]
            sub si, [bp-16]
            mov cl, 2
            shl si, cl
            add [bp-18], si
            jmp after_dG0
        dLE0:
            ; d += 4x + 6
            add word [bp-18], 6
            mov si, [bp-14]
            mov cl, 2
            shl si, cl
            add [bp-18], si

        after_dG0:

        inc word [bp-14]
        mov si, [bp-14]
        mov dx, [bp-16]
        call put_pixels
        jmp while_yGEx
    done_while_yGEx:
        
    add sp, 6
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret

