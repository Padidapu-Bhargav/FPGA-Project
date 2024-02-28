`timescale 1ns / 1ps

module AXI_8_bit_register(
input [7:0] in_data,
input clk,reset,
input T_valid_in,T_ready,Tlast,
output [7:0] out_data);

reg [7:0]Hold_data; // it is used for holding the data;

always @(posedge clk , posedge reset) begin

   
    if(reset || Tlast)begin
        Hold_data <= 8'b00000000;
    end
     
    else begin
        if(T_valid_in && T_ready)
            begin
                Hold_data <= in_data;          
            end
        else 
            begin
                Hold_data <= Hold_data;
            end
    end
end
assign out_data = Hold_data;
endmodule
