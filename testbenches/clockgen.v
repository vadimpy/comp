`timescale 1ns/1ps
    
module Clock #(parameter period=10, parameter duty_cycle=0.5) (output reg clk);

parameter high_time = duty_cycle * period,
          low_time = period - high_time;

initial begin
    clk = 0;
end

always begin
    #low_time
    clk = 1;
    #high_time;
    clk = 0;        
end

endmodule