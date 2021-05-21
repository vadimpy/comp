module Fetch(
    input clk,
    output wire [15:0] insn,
    // regfile
    output wire [15:0] regfile_write_value,
    input wire [15:0] regfile_read_value,
    // rom
    output wire [15:0] rom_address,
    input wire [15:0] rom_read_value,
    // pc from exec stage
    input wire branch_flag,
    input wire [15:0] exec_program_counter
);

    wire [15:0] program_counter;
    wire [15:0] next_program_counter;
    reg stall_controller;

    assign program_counter = regfile_read_value;
    assign rom_address = program_counter; 
    assign next_program_counter = rom_read_value[15:14] === 2'b01 ? program_counter : program_counter + 1;
    assign insn = stall_controller === 1 ? 16'd0 : rom_read_value;
    assign regfile_write_value = branch_flag ? exec_program_counter : next_program_counter;

always @(posedge clk)
begin
    if (rom_read_value[15:14] === 2'b01)
        stall_controller <= 1;
    if (branch_flag)
        stall_controller <= 0;
end

endmodule