`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.09.2024 15:21:21
// Design Name: 
// Module Name: TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TB();
reg [7:0]A,B;
reg [1:0]sel;
wire [15:0]C;
wire [7:0]rem;

arith_operations DUT(.A(A), .B(B), .sel(sel), .C(C), .rem(rem));

parameter delay=100;

initial begin
    A = 8'd0;
    B = 8'd0;
    sel = 2'd0;
    #delay;
    
    A = 8'd2;
    B = 8'd3;
    sel = 2'd0;
    #delay;
    
    A = 8'd60;
    B = 8'd20;
    sel = 2'd1;
    #delay;
    
    A = 8'd10;
    B = 8'd9;
    sel = 2'd2;
    #delay;    
    
    A = 8'd100;
    B = 8'd39;
    sel = 2'd3;
    #delay;
    
    A = 8'd1300;
    B = 8'd230;
    sel = 2'd0;
    #delay;
    
    
end
endmodule
