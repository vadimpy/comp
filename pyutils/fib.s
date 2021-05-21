start:
    mov x4, 1
    mov x0, 0
    mov x1, 1
    mov x6, 10

loop:
    sr x0, sp, 0
    add x2, x0, x1
    movr x0, x1
    movr x1, x2
    sub x6, x6, x4
    beq start

wait_loop_init:
    mov x5, 64

wait_loop:
    sub x5, x5, x4
    cmp x5, xzr
    bneq wait_loop
    b loop
