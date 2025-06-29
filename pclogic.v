module pclogic(clk, reset, branchOffset, jumpTarget, aout, pcsel, Jump, JumpLink, pc_plus_4);
    input reset, clk, pcsel, Jump, JumpLink;
    input [31:0] branchOffset;
    input [25:0] jumpTarget;
    output reg [31:0] aout;
    output [31:0] pc_plus_4;
    
    // PC + 4 adder
    wire [32:0] pc_adder_carry;
    assign pc_adder_carry[0] = 0;
    
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : pc_adder_gen
            wire sum, c_out;
            
            // Adding 4 to PC - set bits 2 and 3 of second operand to 1
            wire b_bit = (i == 2) ? 1'b1 : ((i == 3) ? 1'b0 : 1'b0);
            
            full_adder fa(
                .a(aout[i]),
                .b(b_bit),
                .c_in(pc_adder_carry[i]),
                .sum(sum),
                .c_out(c_out)
            );
            assign pc_plus_4[i] = sum;
            assign pc_adder_carry[i+1] = c_out;
        end
    endgenerate
    
    // Branch adder - adds PC+4 and shifted immediate
    wire [31:0] branch_target;
    wire [32:0] branch_adder_carry;
    assign branch_adder_carry[0] = 1'b0;
    
    generate
        for (i = 0; i < 32; i = i + 1) begin : branch_adder_gen
            wire sum, c_out;
            full_adder fa(
                .a(pc_plus_4[i]),
                .b(branchOffset[i]),
                .c_in(branch_adder_carry[i]),
                .sum(sum),
                .c_out(c_out)
            );
            assign branch_target[i] = sum;
            assign branch_adder_carry[i+1] = c_out;
        end
    endgenerate
    
    // Jump logic - combines PC+4[31:28] with jump target address
    wire [31:0] jump_addr;
    assign jump_addr = {pc_plus_4[31:28], jumpTarget, 2'b00};
    
    // wires for selecting next PC
    wire [31:0] branch_or_pc4;
    wire [31:0] next_pc;
    
    // MUX for branch or PC+4
    mux #(32) branch_mux(
        .sel(pcsel),
        .ina(pc_plus_4),
        .inb(branch_target),
        .out(branch_or_pc4)
    );
    
    // MUX for jump
    mux #(32) jump_mux(
        .sel(Jump),
        .ina(branch_or_pc4),
        .inb(jump_addr),
        .out(next_pc)
    );
    
    // PC register with reset
    always @(posedge clk) begin
        if (reset)
            aout <= 32'b0;
        else
            aout <= next_pc;
    end
endmodule