module pwm(
    input wire ref_clk,
    input wire [15:0] duty_cycle,
    output wire clk
);

reg [15:0] cnt;

assign clk = cnt < duty_cycle ? 1'b1 : 1'b0;

initial begin
    cnt <= 16'h0000;
end

always @(posedge ref_clk)
begin
    cnt <= cnt + 16'h0001;
end

endmodule