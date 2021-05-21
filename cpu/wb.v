module Writeback (
    input wire clk,
    input wire [15:0] w_insn,
    input wire [15:0] mem_ro_port_value,
    output reg regfile_wo_port_enable,
    output wire [3:0] regfile_wo_port_reg_num,
    output wire [15:0] regfile_wo_port_value
);

reg [15:0] insn;

assign regfile_wo_port_reg_num = insn[15:14] === 2'b10 ? insn[13:10] : 4'd0;
assign regfile_wo_port_value = insn[15:14] === 2'b10 ? mem_ro_port_value : 16'd0;

always @(posedge clk)
begin
    insn <= w_insn; 
    regfile_wo_port_enable <= w_insn[15:14] === 2'b10;
end

endmodule