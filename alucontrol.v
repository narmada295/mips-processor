module alucontrol(AluOp, FnField, AluCtrl);
    input [1:0] AluOp;
    input [5:0] FnField;
    output [3:0] AluCtrl;
    
    wire r_add, r_sub, r_and, r_or, r_slt, r_nor;
    
    // Decode function field for R-type instructions
    and r_add_and(r_add, ~FnField[5], ~FnField[4], ~FnField[3], ~FnField[2], ~FnField[1], ~FnField[0]); // 000000
    and r_sub_and(r_sub, ~FnField[5], ~FnField[4], ~FnField[3], ~FnField[2], FnField[1], ~FnField[0]);  // 000010
    and r_and_and(r_and, ~FnField[5], ~FnField[4], ~FnField[3], FnField[2], ~FnField[1], ~FnField[0]);  // 000100
    and r_or_and(r_or, ~FnField[5], ~FnField[4], ~FnField[3], FnField[2], ~FnField[1], FnField[0]);     // 000101
    and r_slt_and(r_slt, ~FnField[5], ~FnField[4], FnField[3], ~FnField[2], FnField[1], ~FnField[0]);   // 001010
    and r_nor_and(r_nor, ~FnField[5], ~FnField[4], ~FnField[3], FnField[2], FnField[1], FnField[0]);    // 000111
    
    // Control signals based on AluOp and function field
    wire add_op, sub_op, and_op, or_op, slt_op, nor_op;
    
    // ADD: (AluOp == 00) || (AluOp[1] && r_add)
    or add_or(add_op, (~AluOp[1] & ~AluOp[0]), (AluOp[1] & r_add));
    
    // SUB: (AluOp == 01) || (AluOp[1] && r_sub)
    or sub_or(sub_op, (~AluOp[1] & AluOp[0]), (AluOp[1] & r_sub));
    
    // AND: AluOp[1] && r_and
    and and_and(and_op, AluOp[1], r_and);
    
    // OR: AluOp[1] && r_or
    and or_and(or_op, AluOp[1], r_or);
    
    // SLT: AluOp[1] && r_slt
    and slt_and(slt_op, AluOp[1], r_slt);
    
    // NOR: AluOp[1] && r_nor
    and nor_and(nor_op, AluOp[1], r_nor);
    
    // AluCtrl output logic
    // AluCtrl[3] - Set for NOR operation
    assign AluCtrl[3] = nor_op;
    
    // AluCtrl[2] - Set for SUB and SLT operations
    or ctrl2_or(AluCtrl[2], sub_op, slt_op);
    
    // AluCtrl[1] - Set for ADD and SUB operations
    or ctrl1_or(AluCtrl[1], add_op, sub_op);
    
    // AluCtrl[0] - Set for OR and SLT operations
    or ctrl0_or(AluCtrl[0], or_op, slt_op);
    
endmodule
