`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2024 12:35:03
// Design Name: 
// Module Name: fixed_point_add_TB
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


module fixed_point_add_TB();

//parameters
parameter WI1 = 6;
parameter WF1 = 10;
parameter WI2 = 6;
parameter WF2 = 8;
parameter WIO = 10;
parameter WFO = 10;

reg clk;
reg reset;
reg signed [(WI1+WF1)-1:0]A;
reg signed [(WI2+WF2)-1:0]B;
wire signed[(WIO+WFO)-1:0]C;

Fixed_point_add #(
    .WI1(WI1),
    .WF1(WF1),
    .WI2(WI2),
    .WF2(WF2),
    .WIO(WIO),
    .WFO(WFO))
    DUT (.clk(clk),.reset(reset),.A(A),.B(B),.C(C));
    
initial begin
    clk=1'b0;
    forever #10 clk = ~clk;
end

initial begin
    reset = 1'b1;
    #20 reset =1'b0;
end

initial begin
    A=16'h1F60;
    B=14'h1f80;
    
    #110 A=16'h3C80;
    B=14'h1f84;
    
    #110 A=16'haC30;
    B=14'h1c80;
    
    #110A=16'hfff1;
    B=14'h2b30;
    
    #110A=16'h7b80;
    B=14'h1d60;
    
    #110 A=16'h3C80;
    B=14'h1f84;
    
    #110A=16'h8000;
    B=14'h2000;
    
    #110 A=16'h3C80;
    B=14'h1f84;
    
    
end


endmodule
