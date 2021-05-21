module ReadOnlyMemory (
    // for fetcher
    input [15:0] fetch_address,
    output reg [15:0] fetch_read_value
);

integer i;
reg [15:0] mem [0:1<<16 - 1];

initial begin
    $readmemh("/home/vadimpy/Documents/fpga/iocomp/pyutils/rom_image.mem", mem);
end

always @(*)
begin
    fetch_read_value <= mem[fetch_address];
end

endmodule