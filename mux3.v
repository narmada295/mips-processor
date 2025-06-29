module mux3(sel, ina, inb, inc, out);
    parameter DATA_LENGTH = 8;
    
    input [1:0] sel;
    input [DATA_LENGTH-1:0] ina;
    input [DATA_LENGTH-1:0] inb;
    input [DATA_LENGTH-1:0] inc;
    output [DATA_LENGTH-1:0] out;
    
    wire [DATA_LENGTH-1:0] temp_out;
    
    // First level mux between ina and inb based on sel[0]
    mux #(DATA_LENGTH) mux1(sel[0], ina, inb, temp_out);
    
    // Second level mux between temp_out and inc based on sel[1]
    mux #(DATA_LENGTH) mux2(sel[1], temp_out, inc, out);
endmodule