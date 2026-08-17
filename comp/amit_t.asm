mov bx, 0x7060
bottom_line:
    mov byte [bx], 0x1
    inc bx
    cmp word bx, 0x70a0
    jnz bottom_line

mov bx, 0x9080
vertical_line:
    mov byte [bx], 0x1
    sub word bx, 0x100
    cmp word bx, 0x6080
    jnz vertical_line

mov bx, 0x6070
left_diagonal:
    mov byte [bx], 0x1
    add word bx, 0x101
    cmp bx, 0x8090
    jnz left_diagonal

mov bx, 0x6090
right_diagonal:
    mov byte [bx], 0x1
    add word bx, 0xff
    cmp bx, 0x8070
    jnz right_diagonal

mov cx, 5
mov bx, 0x6E7E

draw_row:
    mov dx, 5
    mov di, bx

draw_col:
    mov byte [di], 1
    inc di
    dec dx
    jnz draw_col

    add bx, 0x100
    dec cx
    jnz draw_row



mov ax, 0x80
mov bx, 0x70
lea dx, [0xc0-0x80]
circles:
    call draw_circle
    dec dx
    dec dx
    test dx, dx
    jnz circles

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
    
    ; Octant 1
    mov di, bx
    add di, dx
    shl di, cl 
    add di, ax
    add di, si
    call draw_random_pixel
    
    ; Octant 2
    mov di, bx
    add di, dx
    shl di, cl 
    add di, ax
    sub di, si
    call draw_random_pixel
    
    ; Octant 3
    mov di, bx
    sub di, dx
    shl di, cl 
    add di, ax
    add di, si
    call draw_random_pixel
    
    ; Octant 4
    mov di, bx
    sub di, dx
    shl di, cl 
    add di, ax
    sub di, si
    call draw_random_pixel
    
    ; Octant 5
    mov di, bx
    add di, si
    shl di, cl 
    add di, ax
    add di, dx
    call draw_random_pixel
    
    ; Octant 6
    mov di, bx
    add di, si
    shl di, cl 
    add di, ax
    sub di, dx
    call draw_random_pixel
    
    ; Octant 7
    mov di, bx
    sub di, si
    shl di, cl 
    add di, ax
    add di, dx
    call draw_random_pixel
    
    ; Octant 8
    mov di, bx
    sub di, si
    shl di, cl 
    add di, ax
    sub di, dx
    call draw_random_pixel

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

    push cx
    push dx
    push si
    push di
    sub sp, 6

    ; x=-10, y=-12, d=-14
    mov word [bp-10], 0
    mov word [bp-12], dx
    mov cx, 1
    mov di, dx
    shl di, cl
    mov cx, 3
    sub cx, di
    mov word [bp-14], cx

    mov word si, [bp-10]
    mov word dx, [bp-12]
    call put_pixels
    while_yGEx:
        mov di, [bp-12]
        mov si, [bp-10]
        cmp di, si
        jl done_while_yGEx

        cmp word [bp-14], 0
        jle dLE0
        dG0:
            dec word [bp-12]
            ; d += 4(x-y) + 10
            add word [bp-14], 10
            mov si, [bp-10]
            sub si, [bp-12]
            mov cl, 2
            shl si, cl
            add [bp-14], si
            jmp after_dG0
        dLE0:
            ; d += 4x + 6
            add word [bp-14], 6
            mov si, [bp-10]
            mov cl, 2
            shl si, cl
            add [bp-14], si

        after_dG0:

        inc word [bp-10]
        mov si, [bp-10]
        mov dx, [bp-12]
        call put_pixels
        jmp while_yGEx
    done_while_yGEx:
        
    add sp, 6
    pop di
    pop si
    pop dx
    pop cx
    pop bp
    ret

draw_random_pixel:
    push ax
    push cx
    push dx

    mov ax, [prng_seed]
    
    ; Failsafe: Xorshift breaks if the seed is ever exactly 0
    test ax, ax
    jnz .do_xorshift
    mov ax, 0xACE1      ; Reset to a valid non-zero seed
    
.do_xorshift:
    ; 1. Shift left 7 and XOR
    mov dx, ax
    mov cl, 7
    shl dx, cl
    xor ax, dx
    
    ; 2. Shift right 9 and XOR
    mov dx, ax
    mov cl, 9
    shr dx, cl
    xor ax, dx
    
    ; 3. Shift left 8 and XOR
    mov dx, ax
    mov cl, 8
    shl dx, cl
    xor ax, dx
    
    ; Save the new chaotic seed
    mov [prng_seed], ax
    
    ; Decide whether to draw (25% density)
    and ah, 0x03
    jnz .skip_pixel
    
    mov byte [di], 1    ; Draw the stardust pixel!
    
.skip_pixel:
    pop dx
    pop cx
    pop ax
    ret
prng_seed: dw 0xACE1
