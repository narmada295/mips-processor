module rom(
    input [31:0] addr,
    output [31:0] data
);
    reg [31:0] memory [0:1023]; // 1K instruction memory
    
    assign data = memory[addr[11:2]]; // Word-aligned access
    
    // Initialized with a test program
    initial begin
        memory[0] = 32'h20020005; // addi $2, $0, 5    # $2 = 5
        memory[1] = 32'h2003000c; // addi $3, $0, 12   # $3 = 12
        memory[2] = 32'h00430820; // add $1, $2, $3    # $1 = $2 + $3 = 17
        memory[3] = 32'h00412022; // sub $4, $2, $1    # $4 = $2 - $1 = -12
        memory[4] = 32'h00622824; // and $5, $3, $2    # $5 = $3 & $2 = 4
        memory[5] = 32'h00623025; // or $6, $3, $2     # $6 = $3 | $2 = 13
        memory[6] = 32'h10600002; // beq $3, $0, 2     # Not taken
        memory[7] = 32'h0c000000; // jal 0             # $31 = PC+4, PC = 0
        memory[8] = 32'h08000000; // j 0               # PC = 0
    end
endmodule