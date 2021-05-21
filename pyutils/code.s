mov x4, 32
mov x6, 48
mov x2, 16
mul x2, x2, x2
mul x6, x6, x6
mov x1, 16
mov x3, -1
movr x7, x2

loop:
    sr x7, sp, 2
    sr x7, sp, 0
    add x7, x7, x4
    cmp x7, x6
    beq redirect
    cmp x7, x2
    beq redirect
    b loop

redirect:
    mul x4, x4, x3
    b loop