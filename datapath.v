module datapath(
    input clk, reset,
    input RegDst, AluSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, JumpLink,
    input [1:0] ALUOp,
    output [5:0] OpCode
);
    // Internal wires
    wire [31:0] PC_adr;
    wire [31:0] PC_plus_4;
    wire [31:0] Instruction;
    wire [4:0] WriteReg;
    wire [31:0] WriteData;
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] SignExtImm;
    wire [31:0] ALU_B;
    wire [31:0] ALU_result;
    wire ALU_zero;
    wire [31:0] ReadData;
    wire [31:0] ShiftedImm;
    wire BranchSel;
    wire [3:0] ALUCtrl;
    wire [25:0] JumpTarget;
    
    // PC Logic
    pclogic PC(
        .clk(clk),
        .reset(reset),
        .branchOffset(ShiftedImm),
        .jumpTarget(JumpTarget),
        .aout(PC_adr),
        .pcsel(BranchSel),
        .Jump(Jump),
        .JumpLink(JumpLink),
        .pc_plus_4(PC_plus_4)
    );
    
    // Instruction Memory (ROM)
    rom InstrMemory(
        .addr(PC_adr),
        .data(Instruction)
    );
    
    // Extract opcode
    assign OpCode = Instruction[31:26];
    
    // Jump target extraction
    assign JumpTarget = Instruction[25:0];
    
    // MUX for Register Write destination
    wire [4:0] rt = Instruction[20:16];
    wire [4:0] rd = Instruction[15:11];
    wire [4:0] ra_addr = 5'd31; // Register $31 for return address (JAL)
    
    // Modified to support JAL instruction using a 3-way mux
    wire [1:0] reg_dest_sel;
    assign reg_dest_sel = {JumpLink, RegDst};
    
    mux3 #(5) RegDstMux(
        .sel(reg_dest_sel),
        .ina(rt),           // For I-type instructions
        .inb(rd),           // For R-type instructions
        .inc(ra_addr),      // For JAL instruction
        .out(WriteReg)
    );
    
    // MUX for selecting write data (JAL saves PC+4)
    wire [31:0] RegWriteData;
    mux #(32) JALMux(
        .sel(JumpLink),
        .ina(WriteData),
        .inb(PC_plus_4),
        .out(RegWriteData)
    );
    
    // Register File
    rf RegFile(
        .clk(clk),
        .RegWrite(RegWrite),
        .ra(Instruction[25:21]), // rs
        .rb(Instruction[20:16]), // rt
        .rc(WriteReg),           // Write destination
        .da(ReadData1),
        .db(ReadData2),
        .dc(RegWriteData)
    );
    
    // Sign Extend
    signextend SignExtend(
        .in(Instruction[15:0]),
        .out(SignExtImm)
    );
    
    // Shift left 2 for branch offset (implemented directly)
    assign ShiftedImm = {SignExtImm[29:0], 2'b00};
    
    // ALU Control
    alucontrol ALUControl(
        .AluOp(ALUOp),
        .FnField(Instruction[5:0]),
        .AluCtrl(ALUCtrl)
    );
    
    // MUX for ALU input B
    mux #(32) ALUSrcMux(
        .sel(AluSrc),
        .ina(ReadData2),
        .inb(SignExtImm),
        .out(ALU_B)
    );
    
    // ALU
    alu ALU(
        .opA(ReadData1),
        .opB(ALU_B),
        .ALUop(ALUCtrl),
        .result(ALU_result),
        .zero(ALU_zero)
    );
    
    // Branch AND gate
    andm BranchAnd(
        .inA(Branch),
        .inB(ALU_zero),
        .out(BranchSel)
    );
    
    // Data Memory
    ram DataMemory(
        .clk(clk),
        .addr(ALU_result),
        .din(ReadData2),
        .we(MemWrite),
        .re(MemRead),
        .dout(ReadData)
    );
    
    // MUX for Memory to Register
    mux #(32) MemtoRegMux(
        .sel(MemtoReg),
        .ina(ALU_result),
        .inb(ReadData),
        .out(WriteData)
    );
    
endmodule