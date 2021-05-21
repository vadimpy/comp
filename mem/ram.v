module RandomAccessMemory (
    input wire clk,
    input wire ro_port_enable,
    input wire [15:0] ro_port_address,
    output reg [15:0] ro_port_value,
    input wire wo_port_enable,
    input wire [15:0] wo_port_address,
    input wire [15:0] wo_port_value,
    output wire [15:0] seg_output,
    output wire [15:0] diod_output,
    output wire [15:0] pwm_output
);

reg [15:0] mem [0:99];

assign seg_output = mem[0];
assign diod_output = mem[1];
assign pwm_output = mem[2];

initial begin
    mem[0] <= 16'h0000;
    mem[1] <= 16'h0000;
    mem[2] <= 16'h0000;
end

always @(posedge clk)
begin
    if (wo_port_enable)
        mem[wo_port_address] <= wo_port_value;
    if (ro_port_enable)
        ro_port_value <= mem[ro_port_address];
end

endmodule