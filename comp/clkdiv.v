module clkdiv #(parameter n=5) (
    input wire clk,
    output wire clk_out
);

reg [n:0] cnt;
assign clk_out = cnt[n];

initial begin
    cnt <= {n+1{1'b0}};
end

always @(posedge clk)
begin
	cnt <= cnt + {{n{1'b0}}, 1'b1};
end

endmodule