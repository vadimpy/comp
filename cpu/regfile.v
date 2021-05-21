module RegisterFile (
    input wire clk,

    // for fetcher, rw
    input wire [15:0] fetch_write_value,
    output wire [15:0] fetch_read_value,

    // read-only port1
    input wire [3:0] ro_port1_reg_num,
    output reg [15:0] ro_port1_value,

    // read-only port2
    input wire [3:0] ro_port2_reg_num,
    output reg [15:0] ro_port2_value,

    // write-only port1
    input wire wo_port1_enable,
    input wire [3:0] wo_port1_reg_num,
    input wire [15:0] wo_port1_value,

    // write-only port2
    input wire wo_port2_enable,
    input wire [3:0] wo_port2_reg_num,
    input wire [15:0] wo_port2_value,

    // alu flags
    output wire [7:0] alu_flags_output,
    input wire [7:0] new_alu_flags
);

wire [15:0] zero;
reg [15:0] gp_regs [0:7];
reg [7:0] alu_flags;
reg [15:0] stack_pointer;
reg [15:0] program_counter;

assign zero = 0;
assign fetch_read_value = program_counter;
assign alu_flags_output = alu_flags;

initial begin
    program_counter = 0;
    alu_flags = 0;
    stack_pointer = 0;
end

always @(posedge clk)
begin
    program_counter <= fetch_write_value;
    alu_flags <= new_alu_flags;
    case (ro_port1_reg_num)
        4'd00   : ro_port1_value <= zero;
        4'd01   : ro_port1_value <= gp_regs[0];
        4'd02   : ro_port1_value <= gp_regs[1];
        4'd03   : ro_port1_value <= gp_regs[2];
        4'd04   : ro_port1_value <= gp_regs[3];
        4'd05   : ro_port1_value <= gp_regs[4];
        4'd06   : ro_port1_value <= gp_regs[5];
        4'd07   : ro_port1_value <= gp_regs[6];
        4'd08   : ro_port1_value <= gp_regs[7];
        4'd09   : ro_port1_value <= stack_pointer;
        4'd10   : ro_port1_value <= program_counter;
        default : ro_port1_value <= zero;
    endcase

    case (ro_port2_reg_num)
        4'd00   : ro_port2_value <= zero;
        4'd01   : ro_port2_value <= gp_regs[0];
        4'd02   : ro_port2_value <= gp_regs[1];
        4'd03   : ro_port2_value <= gp_regs[2];
        4'd04   : ro_port2_value <= gp_regs[3];
        4'd05   : ro_port2_value <= gp_regs[4];
        4'd06   : ro_port2_value <= gp_regs[5];
        4'd07   : ro_port2_value <= gp_regs[6];
        4'd08   : ro_port2_value <= gp_regs[7];
        4'd09   : ro_port2_value <= stack_pointer;
        4'd10   : ro_port2_value <= program_counter;
        default : ro_port2_value <= zero;
    endcase

    if ((wo_port1_enable) && (wo_port1_reg_num !== wo_port2_reg_num))
        case (wo_port1_reg_num)
            4'd00   : ;
            4'd01   : gp_regs[0]        <= wo_port1_value;
            4'd02   : gp_regs[1]        <= wo_port1_value;
            4'd03   : gp_regs[2]        <= wo_port1_value;
            4'd04   : gp_regs[3]        <= wo_port1_value;
            4'd05   : gp_regs[4]        <= wo_port1_value;
            4'd06   : gp_regs[5]        <= wo_port1_value;
            4'd07   : gp_regs[6]        <= wo_port1_value;
            4'd08   : gp_regs[7]        <= wo_port1_value;
            4'd09   : stack_pointer     <= wo_port1_value;
            4'd10   : program_counter   <= wo_port1_value;
            default : ;
        endcase

    if (wo_port2_enable)
        case (wo_port2_reg_num)
            4'd00   : ;
            4'd01   : gp_regs[0]        <= wo_port2_value;
            4'd02   : gp_regs[1]        <= wo_port2_value;
            4'd03   : gp_regs[2]        <= wo_port2_value;
            4'd04   : gp_regs[3]        <= wo_port2_value;
            4'd05   : gp_regs[4]        <= wo_port2_value;
            4'd06   : gp_regs[5]        <= wo_port2_value;
            4'd07   : gp_regs[6]        <= wo_port2_value;
            4'd08   : gp_regs[7]        <= wo_port2_value;
            4'd09   : stack_pointer     <= wo_port2_value;
            4'd10   : program_counter   <= wo_port2_value;
            default : ;
        endcase
end

endmodule