%define depth [bp+10]
%define size [bp+8]
%define square_y [bp+6]
%define square_x [bp+4]

%define subsize [bp-0xe]
%define start_x [bp-0x10]
%define start_y [bp-0x12]


mov ax, 4
push ax

mov ax,0x51
push ax

mov ax, 0x58
push ax
push ax

call sierpinski_carpet
jmp end

; sierpinski_carpet(x, y, size, depth)
sierpinski_carpet:
    push bp
    mov bp, sp

    push ax
    push bx
    push cx
    push dx
    push si
    push di
    sub sp, 6       ; Allocate 6 bytes for locals

    ; test depth for 0
    mov ax, depth
    test ax, ax
    jnz .continue_1
    jmp sierpinski_carpet_end
    .continue_1:

    ; subsize = size/3
    mov ax, size
    xor dx, dx
    mov bx, 3
    div bx
    mov subsize, ax

    ; start_x = square_x + subsize
    mov ax, square_x
    add ax, subsize
    mov start_x, ax
    
    ; start_y = square_y + subsize
    mov ax, square_y
    add ax, subsize
    mov start_y, ax
    
    mov cx, start_y
    mov bx, start_y
    add bx, subsize     ; bx = end_y

    y_loop:
        cmp cx, bx
        jge y_loop_end

        mov dx, start_x
        mov si, start_x
        add si, subsize     ; si = end_x

        x_loop:
            cmp dx, si
            jge x_loop_end

            mov ah, cl
            mov al, dl
            mov di, ax
            mov byte [di], 1

            inc dx
            jmp x_loop

        x_loop_end:
        inc cx
        jmp y_loop

    y_loop_end:

    mov ax, depth
    cmp ax, 1
    jz sierpinski_carpet_end


    mov cx, square_y
    mov bx, 0
    recurse_y:
        cmp bx, 3
        jge recurse_end

        mov dx, square_x
        mov si, 0
        recurse_x:
            cmp si, 3
            jge recurse_x_end

            cmp bx, 1
            jne do_call
            cmp si, 1
            je skip_call

        do_call:
            mov ax, depth
            dec ax
            push ax
            push word subsize
            push cx
            push dx
            call sierpinski_carpet
            add sp, 8

        skip_call:
            mov ax, subsize
            add dx, ax
            inc si
            jmp recurse_x

        recurse_x_end:
            mov ax, subsize
            add cx, ax
            inc bx
            jmp recurse_y

    recurse_end:

sierpinski_carpet_end:
    add sp, 6

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax

    pop bp
    ret


end:
    jmp 0x0
