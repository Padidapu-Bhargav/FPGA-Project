`timescale 1ns / 1ps

module MAC_add_TB();
parameter DW=8;
reg [DW-1:0]a;
reg [DW-1:0]b;
reg [DW-1:0]c;
reg [DW-1:0]d;

wire [DW-1:0]m_data;

MAC_add DUT(.a_data(a),.b_data(b),.c_data(c),.d_data(d),.m_data(m_data));

    initial begin
        a='d2;b='d3;c='d3;d='d5;
        #10 a='d3;b='d4;c='d2;d='d1;
        #10 a='d5;b='d3;c='d1;d='d2;
        #10 a='d5;b='d2;c='d3;d='d4;
        #10 a='d2;b='d4;c='d3;d='d5;
        #10 a='d1;b='d7;c='d2;d='d1;
        #10 a='d3;b='d6;c='d3;d='d4;
        #10 a='d2;b='d3;c='d4;d='d2;
        #10 a='d3;b='d4;c='d5;d='d3;
        #10 a='d7;b='d3;c='d2;d='d1;
        #10 a='d23;b='d2;c='d5;d='d5;
        #10 a='d21;b='d4;c='d23;d='d15;
        #10 a='d14;b='d7;c='d13;d='d25;
        #10 a='d38;b='d6;c='d33;d='d15;
    end
endmodule
