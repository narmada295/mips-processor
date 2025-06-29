module mips(clk, reset);
    input clk, reset;
    
    // Control signals
    wire [5:0] OpCode;
    wire [1:0] ALUOp;
    wire RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, Jump, JumpLink;
    
    // Connect control unit
    control Control(
        .opcode(OpCode),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemToReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .Jump(Jump),
        .JumpLink(JumpLink),
        .AluOP(ALUOp)
    );
    
    // Connect datapath
    datapath Datapath(
        .clk(clk),
        .reset(reset),
        .RegDst(RegDst),
        .AluSrc(ALUSrc),
        .MemtoReg(MemToReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .Jump(Jump),
        .JumpLink(JumpLink),
        .ALUOp(ALUOp),
        .OpCode(OpCode)
    );
endmodule