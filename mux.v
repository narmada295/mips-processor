module mux(sel, ina, inb, out);
    parameter DATA_LENGTH = 8;
    
    input sel;
    input [DATA_LENGTH-1:0] ina;
    input [DATA_LENGTH-1:0] inb;
    output [DATA_LENGTH-1:0] out;
    
    genvar i;
    generate
        for (i = 0; i < DATA_LENGTH; i = i + 1) begin : mux_gen
            wire sel_n, and_a, and_b;
            
            not not_sel(sel_n, sel);
            and and_a_gate(and_a, ina[i], sel_n);
            and and_b_gate(and_b, inb[i], sel);
            or or_gate(out[i], and_a, and_b);
        end
    endgenerate
endmodule