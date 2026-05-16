%define depth [bp+10]
%define size [bp+8]
%define square_y [bp+6]
%define square_x [bp+4]

%define subsize [bp-0xe]
%define start_x [bp-0x10]
%define start_y [bp-0x12]


;sx, xy, size, depth
sierpinski_carpet:
    push bp
    mov bp, sp

    push ax
    push bx
    push cx
    push dx
    push si
    push di
    sub sp, 6

    ; test depth for 0
    mov ax, depth
    test ax, ax
    jz sierpinski_carpet_end

    ; subsize = size/3
    mov ax, size
    mov bx, 3
    div word bx
    mov subsize, ax

    ; start_x = square_x + subsize
    mov word ax, square_x
    mov start_x, ax
    mov ax, subsize
    add start_x, ax
    
    ; start_y = square_y + subsize
    mov word ax, square_y
    mov start_y, ax
    mov ax, subsize
    add start_y, ax
    
    y_loop:
        x_loop:
            
        x_loop_end:
    y_loop_end:

    mov ax, depth
    cmp ax, 1
    jz sierpinski_carpet_end




sierpinski_carpet_end:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax

    pop bp
    ret
