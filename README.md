# comp
Verilog implementation of simple programmable computer
### CPU
CPU is 4-staged and has fetch, decode, execute and write-back stages. Instruction set is pretty little: 4 arithmetic, 4 branches, 2 memory-access instrucitons and 3 pseudo-instructions supported by assembler tool. Stalls on branches and by-pass mechanisms for arithmetic instructions are supported.
### Memory
There are two types of memory: RAM and ROM. ROM contains code, RAM has output-specialized cells and can be used to store data. Addressation is direct, there is no paging and virtual memory. Also there is no caches in CPU.
### Output
There are three ways to output information, but this part of project is easily scalable. The first way is controlled clock frequenc division. Reference clock signal frequency is divided by the number stored in particular RAM cell and then sent to platform GPIO pin (FPGA Altera Cyclone IV in my case). The second is PWM with controlled duty cycle. The same as before value to set duty cycle is stored in particular memory cell, and signal itself is sent to the pin. The third way is digit segment.
