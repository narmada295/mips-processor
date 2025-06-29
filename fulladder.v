module full_adder(a, b, c_in, sum, c_out);
    input a, b, c_in;
    output sum, c_out;
    
    wire w1, w2, w3;
    
    xor xor1(w1, a, b);
    xor xor2(sum, w1, c_in);
    
    and and1(w2, a, b);
    and and2(w3, w1, c_in);
    or or1(c_out, w2, w3);
endmodule