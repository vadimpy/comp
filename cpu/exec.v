module Execute(
    input wire clk,
    input wire [15:0] w_insn,
    input wire [15:0] ro_port1_value,
    input wire [15:0] ro_port2_value,
    input wire [7:0] alu_flags,
    output wire [7:0] new_alu_flags,
    output reg wo_port_enable, 
    output reg [3:0] wo_port_reg_num,
    output reg [15:0] wo_port_value,
    output wire fetch_branch_flag,
    output wire [15:0] fetch_program_counter,
    output wire mem_ro_port_enable,
    output reg [15:0] mem_ro_port_address,
    output wire mem_wo_port_enable,
    output reg [15:0] mem_wo_port_address,
    output reg [15:0] mem_wo_port_value,
    output wire [15:0] out_insn
);

reg [15:0] by_pass_reg_value;
reg [3:0] by_pass_reg_num;
wire [15:0] offset;
reg [15:0] insn;
reg [15:0] res;
wire [15:0] address_base;
wire [15:0] address_offset;
wire [15:0] value_to_write;


//by-pass
wire [15:0] op1;
wire [15:0] op2;
assign op1 = insn[7:4] === by_pass_reg_num ? by_pass_reg_value : ro_port1_value;
assign op2 = insn[3:0] === by_pass_reg_num ? by_pass_reg_value : ro_port2_value;

assign is_nop = ~(|(insn));
assign new_alu_flags[7:2] = alu_flags[7:2];
assign new_alu_flags[1:0] = (insn[15:14] === 2'b00) & ~is_nop ? {res[15], ~(|(res))} : alu_flags[1:0];
assign offset = {{4{insn[11]}}, insn[11:0]};
assign fetch_program_counter = res;
assign fetch_branch_flag = (insn[15:14] === 2'b01) ? 1 : 0;
assign address_base = insn[9:6] === by_pass_reg_num ? by_pass_reg_value : ro_port1_value;
assign address_offset = {{10{insn[5]}}, insn[5:0]};
assign value_to_write = insn[13:10] === by_pass_reg_num ? by_pass_reg_value : ro_port2_value;
assign mem_ro_port_enable = insn[15:14] === 2'b10;
assign mem_wo_port_enable = insn[15:14] === 2'b11;
assign out_insn = insn;

always @(posedge clk) begin
    insn <= w_insn;
    by_pass_reg_num <= wo_port_reg_num;
    by_pass_reg_value <= wo_port_value;
end

always @(*) begin
    if (insn[15:14] === 2'b00) // arithm
    begin
        case (insn[13:12])
            2'b00 : res = op1 + op2; // add
            2'b01 : res = op1 - op2; // sub
            2'b10 : res = op1 * op2; // mul
            default : res = {{8{insn[7]}}, insn[7:0]}; // mov
        endcase
        wo_port_reg_num = insn[11:8];
        wo_port_value = res;
        wo_port_enable = 1;
    end
    if (insn[15:14] === 2'b01) // branhces
    begin
        case (insn[13:12])
            2'b00 : res = ro_port1_value + offset ; // b
            2'b01 : res = alu_flags[0] ? ro_port1_value + offset : ro_port1_value + 16'h0001; // beq
            2'b10 : res = alu_flags[0] ? ro_port1_value + 16'h0001 : ro_port1_value + offset; // bneq
            default : res = alu_flags[1] ? ro_port1_value + offset : ro_port1_value + 16'h0001; // blt
        endcase
        wo_port_reg_num = 0;
        wo_port_value = 0;
        wo_port_enable = 0;
    end
    if (insn[15:14] === 2'b10) // load
    begin
        res = address_base + address_offset;
        mem_ro_port_address = res;
        wo_port_enable = 0;
    end
    if (insn[15:14] === 2'b11) // store
    begin
        wo_port_enable = 1;
        res = address_base + address_offset;
        mem_wo_port_address = res;
        mem_wo_port_value = value_to_write;
    end
end

endmodule