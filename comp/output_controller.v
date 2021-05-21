module OutputController(
    input wire CLK,
    input wire [15:0] seg_hex,
    input wire [15:0] diod_clock_threshold,
    input wire [15:0] diod_pwm,
    output DS_EN1, DS_EN2, DS_EN3, DS_EN4,
    output DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G,
    output DIOD
);

wire [6:0] seg_pins;
wire [27:0] seg;
wire [3:0] segen;
wire clkdiv;
wire diod_fast_clk;

//controlled_clkdiv diod_driver(diod_fast_clk, diod_clock_threshold, DIOD);
pwm pwm_diod(CLK, diod_pwm, DIOD);
clkdiv #(.n(5)) Clkdiv1(CLK, clkdiv);
clkdiv #(.n(13)) Clkdiv2(CLK, diod_fast_clk);
hex2seg Hex2seg_0(seg_hex[3:0], seg[6:0]);
hex2seg Hex2seg_1(seg_hex[7:4], seg[13:7]);
hex2seg Hex2seg_2(seg_hex[11:8], seg[20:14]);
hex2seg Hex2seg_3(seg_hex[15:12], seg[27:21]);

segmgr SegMgr(clkdiv, seg, seg_pins, segen);

assign {DS_EN1, DS_EN2, DS_EN3, DS_EN4} = segen;
assign {DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G} = seg_pins;


endmodule