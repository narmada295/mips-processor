module signextend(out, in);
    input [15:0] in;
    output [31:0] out;
    
    // Lower 16 bits pass through directly
    assign out[15:0] = in;
    
    // Upper 16 bits are all equal to the sign bit (in[15])
    genvar i;
    generate
        for (i = 16; i < 32; i = i + 1) begin : sign_extend_gen
            assign out[i] = in[15];
        end
    endgenerate
endmodule