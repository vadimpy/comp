module Decoder(
    input wire clk,
    input wire [15:0] w_insn,
    output wire [15:0] out_insn,
    output reg [3:0] regfile_port1_num,
    output reg [3:0] regfile_port2_num
);

wire [3:0] dst_reg_num;
wire [3:0] op1_reg_num;
wire [3:0] op2_reg_num;
wire [3:0] store_value_reg;
wire [3:0] base_addr_reg;
reg [15:0] insn;

assign out_insn = insn;
assign {op1_reg_num, op2_reg_num} = insn[7:0];
assign base_addr_reg = insn[9:6];
assign store_value_reg = insn[13:10];

always @(posedge clk) begin
    insn <= w_insn;
end

always @(*) begin
    if (insn[15:14] === 2'b00) begin
        if (insn[13:12] !== 2'b11)
        begin
            regfile_port1_num <= op1_reg_num;
            regfile_port2_num <= op2_reg_num;
        end
    end
    if (insn[15:14] === 2'b01) begin
        regfile_port1_num <= 16'd10;
    end
    if (insn[15:14] === 2'b10) begin
        regfile_port1_num <= base_addr_reg;
    end
    if (insn[15:14] === 2'b11) begin
        regfile_port1_num <= base_addr_reg;
        regfile_port2_num <= store_value_reg;
    end
end

endmodule