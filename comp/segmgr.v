module segmgr
(
    input wire clk,
    input wire [27:0] seg,
    output reg [6:0] seg_pins,
    output reg [3:0] segen
);

reg [1:0] cnt;

initial begin
    cnt = 2'b00;
end

always @(posedge clk) begin
    case (cnt)
        2'b00   : {seg_pins, segen} <= {seg[6:0], 4'b1110};
        2'b01   : {seg_pins, segen} <= {seg[13:7], 4'b1101};
        2'b10   : {seg_pins, segen} <= {seg[20:14], 4'b1011};
        default : {seg_pins, segen} <= {seg[27:21], 4'b0111};
    endcase
    cnt <= cnt + 2'b01;
end

endmodule
