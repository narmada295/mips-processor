module alu(opA, opB, ALUop, result, zero);

input [31:0] opA;
input [31:0] opB;
input [3:0] ALUop;
output [31:0] result;
output zero;

wire [31:0] and_result;
wire [31:0] or_result;
wire [31:0] add_result;
wire [31:0] sub_result;
wire [31:0] slt_result;
wire [31:0] nor_result;

// AND 
genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin : and_gen
        and and_gate(and_result[i], opA[i], opB[i]);
    end
endgenerate

// OR 
generate
    for (i = 0; i < 32; i = i + 1) begin : or_gen
        or or_gate(or_result[i], opA[i], opB[i]);
    end
endgenerate

// NOR 
generate
    for (i = 0; i < 32; i = i + 1) begin : nor_gen
        nor nor_gate(nor_result[i], opA[i], opB[i]);
    end
endgenerate

// Addition/Subtraction with full adders
wire [31:0] adder_b;
wire [32:0] carry; 

// For subtraction, invert opB and add 1 (two's complement)
generate
    for (i = 0; i < 32; i = i + 1) begin : adder_b_gen
        xor xor_gate(adder_b[i], opB[i], ALUop[2]); 
    end
endgenerate

assign carry[0] = ALUop[2];

generate
    for (i = 0; i < 32; i = i + 1) begin : adder_gen
        wire sum, c_out;
        full_adder fa(
            .a(opA[i]),
            .b(adder_b[i]),
            .c_in(carry[i]),
            .sum(sum),
            .c_out(c_out)
        );
        assign add_result[i] = sum;
        assign carry[i+1] = c_out;
    end
endgenerate

// Both add and subtract use the same adder circuit, but with different B input
assign sub_result = add_result;

// Set less than 
assign slt_result = {31'b0, sub_result[31]};

// MUX to select the final result based on ALUop
reg [31:0] temp_result;
always @(*) begin
    case (ALUop)
        4'b0000: temp_result = and_result;  // AND
        4'b0001: temp_result = or_result;   // OR
        4'b0010: temp_result = add_result;  // ADD
        4'b0110: temp_result = sub_result;  // SUB
        4'b0111: temp_result = slt_result;  // SLT
        4'b1100: temp_result = nor_result;  // NOR
        default: temp_result = 32'b0;       // Default case
    endcase
end

assign result = temp_result;

// Zero detection - OR all bits together, then invert
wire [31:0] or_tree;
assign or_tree[0] = result[0];
generate
    for (i = 1; i < 32; i = i + 1) begin : zero_detect_gen
        or or_gate(or_tree[i], or_tree[i-1], result[i]);
    end
endgenerate
not not_gate(zero, or_tree[31]);

endmodule

