module ram(
    input clk,
    input [31:0] addr,
    input [31:0] din,
    input we, re,
    output [31:0] dout
);
    reg [31:0] memory [0:1023]; // 1K data memory
    reg [31:0] data_out;
    
    // Read operation
    assign dout = re ? data_out : 32'bz;
    
    always @(*) begin
        if (re) data_out = memory[addr[11:2]];
    end
    
    // Write operation
    always @(posedge clk) begin
        if (we) memory[addr[11:2]] <= din;
    end
    
    // Initialize memory to 0
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            memory[i] = 32'b0;
        end
    end
endmodule