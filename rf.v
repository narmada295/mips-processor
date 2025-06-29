module rf(clk, RegWrite, ra, rb, rc, da, db, dc);
    input clk, RegWrite;
    input [4:0] ra, rb, rc;
    input [31:0] dc;
    output [31:0] da, db;
    
    // 32 registers of 32 bits each - named reg_outputs to match testbench
    reg [31:0] reg_outputs [0:31];
    
    // Read operations are combinational
    assign da = (ra == 5'b0) ? 32'b0 : reg_outputs[ra]; // Register 0 is always 0
    assign db = (rb == 5'b0) ? 32'b0 : reg_outputs[rb]; // Register 0 is always 0
    
    // Write operation
    always @(posedge clk) begin
        if (RegWrite && rc != 5'b0) // Prevent writing to register 0
            reg_outputs[rc] <= dc;
    end
    
    // Initialize registers to 0
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            reg_outputs[i] = 32'b0;
        end
    end
endmodule