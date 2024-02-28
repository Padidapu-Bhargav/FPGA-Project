`timescale 1ns / 1ps

module Mux_2_1(
input sel,
input [7:0]A,B,
input clk,reset,Tvalid,Tready,Tlast,
output [7:0]out
);
reg [7:0]Hold_data;
 
always@(posedge clk,posedge reset) begin
    if(reset || Tlast) 
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

   
assign out = Hold_data;
endmodule
