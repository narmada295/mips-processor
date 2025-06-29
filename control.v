module control(opcode, RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, JumpLink, AluOP);
    input [5:0] opcode;
    output RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, JumpLink;
    output [1:0] AluOP;
    
    // Decode opcode
    wire r_type, lw, sw, beq, j, jal;
    
    and r_type_and(r_type, ~opcode[5], ~opcode[4], ~opcode[3], ~opcode[2], ~opcode[1], ~opcode[0]); // 000000
    and lw_and(lw, opcode[5], ~opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0]); // 100011
    and sw_and(sw, opcode[5], ~opcode[4], opcode[3], ~opcode[2], opcode[1], opcode[0]); // 101011
    and beq_and(beq, ~opcode[5], ~opcode[4], ~opcode[3], opcode[2], ~opcode[1], ~opcode[0]); // 000100
    and j_and(j, ~opcode[5], ~opcode[4], ~opcode[3], ~opcode[2], opcode[1], ~opcode[0]); // 000010
    and jal_and(jal, ~opcode[5], ~opcode[4], ~opcode[3], ~opcode[2], opcode[1], opcode[0]); // 000011
    
    // Control signals
    assign RegDst = r_type;
    assign ALUSrc = lw | sw;
    assign MemtoReg = lw;
    assign RegWrite = r_type | lw | jal;
    assign MemRead = lw;
    assign MemWrite = sw;
    assign Branch = beq;
    assign Jump = j | jal;
    assign JumpLink = jal;
    
    // ALUOp[1] = R-type
    assign AluOP[1] = r_type;
    
    // ALUOp[0] = beq
    assign AluOP[0] = beq;
endmodule