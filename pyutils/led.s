mov x7, 0
mov x4, 1
mov x6, 12
mov x1, 1
mov x3, -1

loop:
    sr x7, sp, 1
    sr x7, sp, 0
    add x7, x7, x4
    cmp x7, x6
    beq redirect
    cmp x7, xzr
    beq redirect
    b loop

redirect:
    mul x4, x4, x3
    b loop