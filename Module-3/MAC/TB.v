`timescale 1ns / 1ps

module MAC_TB();
parameter DW=8;
reg [DW-1:0]a;
reg [DW-1:0]b;
reg [DW-1:0]c;

wire [DW-1:0]m_data;

MAC DUT(.a_data(a),.b_data(b),.c_data(c),.m_data(m_data));

    initial begin
        a=8'd2;b=8'd3;c=8'd1;
        #10 a=8'd3;b=8'd4;c=8'd2;
        #10 a=8'd4;b=8'd3;c=8'd3;
        #10 a=8'd5;b=8'd2;c=8'd4;
        #10 a=8'd2;b=8'd4;c=8'd3;
        #10 a=8'd1;b=8'd7;c=8'd2;
        #10 a=8'd3;b=8'd6;c=8'd2;
    end
  
endmodule
