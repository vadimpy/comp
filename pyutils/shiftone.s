mov x2, 16
mov x4, 1

init:
    mov x0, 1
    sr x0, sp, 0
    b wait_loop_init

loop:
    cmp x0, xzr
    beq init
    mul x0, x0, x2
    sr x0, sp, 0

wait_loop_init:
    mov x5, 64

wait_loop:
    sub x5, x5, x4
    cmp x5, xzr
    bneq wait_loop
    b loop
