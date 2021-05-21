`timescale  1ns/1ps

module test(input wire x, input wire clk, output reg b);

reg a;

always @(posedge clk) begin
    a = x;
    b = a;
end

endmodule

module tb;

wire clk;
reg x;
wire b;

Clock #(
    .period(1),
    .duty_cycle(0.2)
) clock (.clk(clk));

test t(x, clk, b);

initial begin
    $dumpvars;
    x = 1;
    #5
    x = 0;
    #10
    x = 1;
    #10
    x = 0;
    $finish;
end
endmodule