// test of rom, fetch and regfile
`timescale  1ns/1ns
module tb1;

    wire clk;
    Clock clock(clk);

    wire [31:0] rom_fetch_bus;
    wire [31:0] fetch_regfile_bus;
    wire [15:0] fetch_decode_bus;
    wire [15:0] decode_exec_bus; 
    wire [16:0] exec_fetch_bus;

    wire [3:0] ro_port1_reg_num;
    wire [15:0] ro_port1_value;
    wire [3:0] ro_port2_reg_num;
    wire [15:0] ro_port2_value;
    wire wo_port1_enable;
    wire [3:0] wo_port1_reg_num;
    wire [15:0] wo_port1_value;
    wire wo_port2_enable;
    wire [3:0] wo_port2_reg_num;
    wire [15:0] wo_port2_value;
    wire [7:0] alu_flags;
    wire [7:0] exec_regfile_alu_flags;

    wire ram_ro_port_enable;
    wire [15:0] ram_ro_port_address;
    wire [15:0] ram_ro_port_value;
    wire ram_wo_port_enable;
    wire [15:0] ram_wo_port_address;
    wire [15:0] ram_wo_port_value;

    wire [15:0] exec_wb_bus;
    wire [15:0] seg_value;
    wire [15:0] diod_value;

    RegisterFile regfile(
        clk,
        fetch_regfile_bus[31:16],
        fetch_regfile_bus[15:0],
        ro_port1_reg_num,
        ro_port1_value,
        ro_port2_reg_num,
        ro_port2_value,
        wo_port1_enable,
        wo_port1_reg_num,
        wo_port1_value,
        wo_port2_enable,
        wo_port2_reg_num,
        wo_port2_value,
        alu_flags,
        exec_regfile_alu_flags
    );

    Fetch fetch(
        clk,
        fetch_decode_bus,
        fetch_regfile_bus[31:16],
        fetch_regfile_bus[15:0],
        rom_fetch_bus[31:16],
        rom_fetch_bus[15:0],
        exec_fetch_bus[16],
        exec_fetch_bus[15:0]
    );
    
    Decoder decode(
        clk,
        fetch_decode_bus,
        decode_exec_bus,
        ro_port1_reg_num,
        ro_port2_reg_num        
    );

    Execute exec(
        clk,
        decode_exec_bus,
        ro_port1_value,
        ro_port2_value,
        alu_flags,
        exec_regfile_alu_flags,
        wo_port1_enable,
        wo_port1_reg_num,
        wo_port1_value,
        exec_fetch_bus[16],
        exec_fetch_bus[15:0],
        ram_ro_port_enable,
        ram_ro_port_address,
        ram_wo_port_enable,
        ram_wo_port_address,
        ram_wo_port_value,
        exec_wb_bus
    );

    Writeback wb(
        clk,
        exec_wb_bus,
        ram_ro_port_value,
        wo_port2_enable,
        wo_port2_reg_num,
        wo_port2_value
    );

    ReadOnlyMemory rom(
        rom_fetch_bus[31:16],
        rom_fetch_bus[15:0]
    );

    wire [15:0] pwm_diod;

    RandomAccessMemory ram(
        clk,
        ram_ro_port_enable,
        ram_ro_port_address,
        ram_ro_port_value,
        ram_wo_port_enable,
        ram_wo_port_address,
        ram_wo_port_value,
		seg_value,
        diod_value,
        pwm_diod
    );

    wire DIOD;
	OutputController out_controller(
        clk, seg_value, diod_value, pwm_diod,
	    DS_EN1, DS_EN2, DS_EN3, DS_EN4,
	    DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G,
        DIOD
    );

initial begin
    $dumpvars;
    #15000
    $finish;
end

endmodule