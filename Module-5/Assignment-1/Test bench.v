`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2024 14:24:26
// Design Name: 
// Module Name: FSM_TB
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


module FSM_TB();

reg clk,arst;
reg [15:0]s_data;
reg s_valid,s_last;
wire s_ready;
reg [7:0]s_keep;
wire  [15:0] m_data;
wire m_valid,m_last;
reg m_ready;
wire [7:0]m_keep;integer i;reg rd_en;

FSM1 DUT(clk,arst,
         s_data,s_valid,s_last,s_ready,s_keep,
         m_data,m_valid,m_last,m_ready,m_keep,rd_en);
         
initial begin
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
/*initial begin
    s_keep <= 8'd00;
    #25;s_keep<=8'd16;
    #10;s_keep<=8'd16;
    #10;s_keep<=8'd8;
    #10;s_keep<=8'd4;
    #10;s_keep<=8'd12;
    #10;s_keep<=8'd16;
    #10;s_keep<=8'd8;
    #10;s_keep<=8'd8;
    #10;s_keep<=8'd12;
    #10;s_keep<=8'd8;
    #10;s_keep<=8'd16;
    #10;s_keep<=8'd12;
    #10;s_keep<=8'd16;
    #10;s_keep<=8'd12;
    #10;s_keep<=8'd16;
    #10;s_keep<=8'd12;
    #10;s_keep<=8'd16;
end*/
initial begin
    s_keep <= 8'd00;
    #25;s_keep<=8'd16;
    #10;s_keep<=8'd12;
    #10;s_keep<=8'd16;
    #40;s_keep<=8'd12;
    #30;s_keep<=8'd8;
    #10;s_keep<=8'd12;
    #10;s_keep<=8'd16;
    #10;s_keep<=8'd12;
    #10;s_keep<=8'd16;
    #10;s_keep<=8'd12;
    #10;s_keep<=8'd16;
    #10;s_keep<=8'd16;
    #10;s_keep<=8'd12;
    #10;s_keep<=8'd16;
    #10;s_keep<=8'd12;
    #10;s_keep<=8'd16;
    #10;s_keep<=8'd12;
    #20;s_keep<=8'd16;
end
initial begin
    rd_en = 0;
    #80; rd_en=1;
end

endmodule
