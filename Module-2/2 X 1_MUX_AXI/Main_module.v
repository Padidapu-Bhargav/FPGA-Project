`timescale 1ns / 1ps

module Mux_2_1(
input sel,
input [7:0]A,B,
input clk,reset,Tvalid,Tready,Tlast,
output [7:0]out,
output [4:0]frame_cnt
);
reg [7:0]Hold_data;
reg [4:0]cnt=5'd0;
always@(posedge clk,posedge reset) begin
    if(reset ) 
        begin
            Hold_data <= 8'h00;
        end
    else 
        begin
            if(Tvalid && Tready) 
                Hold_data = sel ? B : A ;
            else
                Hold_data <= Hold_data;
        end    
end

always@(Tlast) begin
    if(Tlast) cnt <= cnt + 1;
    else cnt <= cnt;
end
assign frame_cnt = cnt;  
assign out = Hold_data;
endmodule
