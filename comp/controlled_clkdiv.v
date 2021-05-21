module controlled_clkdiv (
    input wire fast_clk,
    input wire [15:0] threshold,
    output wire clk_out
);

reg [15:0] cnt;
initial begin
    cnt <= 16'h0000;
end

assign clk_out = cnt === 16'h0000;

always @(posedge fast_clk)
begin
    cnt <= cnt > threshold ? 16'h0000 : cnt + 16'h0001;
end

endmodule