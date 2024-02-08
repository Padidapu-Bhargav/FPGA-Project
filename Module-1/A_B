
module A_B (input x, input y, output z);
    wire [5:0]z1;
    A IA1(x,y,z1[0]);
    B IB1(x,y,z1[1]);
    A IA2(x,y,z1[2]);
    B IB2(x,y,z1[3]);
    
    
    assign z1[4] = z1[0] | z1[1];
    assign z1[5] = z1[2] & z1[3] ;
    assign z= z1[4] ^ z1[5];

endmodule
module B( input x, input y, output z );
    assign z= ~(x^y);
endmodule

module A(input x, input y, output z);
    assign z = (x^y) & x;
endmodule
