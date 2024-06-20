`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.06.2024 17:04:55
// Design Name: 
// Module Name: FSM2_TB
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


module FSM2_TB();

reg clk,arst;
reg [15:0]s_data;
reg s_valid,s_last;
wire s_ready;
reg [7:0]s_keep;
wire  [15:0] m_data;
wire m_valid,m_last;
reg m_ready;
wire [7:0]m_keep;integer i;reg rd_en;
wire last;
reg [11:0]k;

FSM2 DUT1(clk,arst,
         s_data,s_valid,s_last,s_ready,s_keep,
         m_data,m_valid,m_last,m_ready,m_keep,k,last,rd_en);
         
initial begin
    k = 'd40;
    clk=1'b1;
    forever #5 clk = ~clk;
end

initial begin
     arst = 1'b0;
    #5 arst =1'b1;
end

initial begin
    m_ready=0;
    s_data = 0;
    s_valid =0;
    s_last =0 ;
    #25;
    m_ready=1;
    for(i=0;i<=25;i=i+1) begin
        s_data=$random;
        s_valid=1;
        if(i==10 | i==20)begin
          #10;
          s_data = 16'h0000;
          s_last<=1;
        end
        else s_last<=0;
        #10;
    end
end
initial begin
    s_keep <= 8'd00;
    #25;s_keep<=8'd16;
    #10;s_keep<=8'd16;
    #10;s_keep<=8'd12;
    #10;s_keep<=8'd8;
    #10;s_keep<=8'd12;
    #10;s_keep<=8'd16;
    #10;s_keep<=8'd8;
    #10;s_keep<=8'd16;
    #10;s_keep<=8'd12;
    #10;s_keep<=8'd8;
    #10;s_keep<=8'd16;
    #10;s_keep<=8'd12;
    #10;s_keep<=8'd16;
    #10;s_keep<=8'd12;
    #10;s_keep<=8'd16;
    #10;s_keep<=8'd12;
    #10;s_keep<=8'd16;
    #10;s_keep <= 8'd8;
    #10;s_keep<=8'd16;
end
initial begin
    rd_en = 0;
    #100; rd_en=1;
end

endmodule
