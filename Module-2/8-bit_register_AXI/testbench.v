`timescale 1ns / 1ps


module TB();
reg [7:0] in_data;
reg clk,reset;
reg T_valid_in,T_ready,Tlast;
wire [7:0] out_data;
wire [4:0] frame_cnt;

AXI_8_bit_register sample(in_data,clk,reset,T_valid_in,T_ready,Tlast,out_data,frame_cnt);

initial begin
clk <=0;
reset <= 0;
T_valid_in <=0;
T_ready <=0;
Tlast <=0;
end

initial begin
    forever #5 clk = ~clk;
    end
    
initial begin
    forever #50 reset = ~reset;
    end
  
initial begin
    Tlast =0;
    #85 Tlast =1;
    #5 Tlast =0;
    #95 Tlast =1;
    #5 Tlast =0;
    end
    
initial begin
 in_data = 8'h12;
    T_valid_in = 1'b1;
    T_ready = 1'b1;
    
 #100in_data = 8'h22;
    T_valid_in = 1'b1;
    T_ready = 1'b1;
    
 #100in_data = 8'h33;
    T_valid_in = 1'b0;
    T_ready = 1'b0;
    
 #100in_data = 8'h44;
    T_valid_in = 1'b1;
    T_ready = 1'b1;
    
 #100in_data = 8'h55;
    T_valid_in = 1'b0;
    T_ready = 1'b1;
    
 #100in_data = 8'h66;
    T_valid_in = 1'b1;
    T_ready = 1'b0;
    
 #100in_data = 8'h77;
    T_valid_in = 1'b1;
    T_ready = 1'b1; 
    
 #100in_data = 8'h88;
    T_valid_in = 1'b1;
    T_ready = 1'b1; 
    
 #100in_data = 8'hAA;
    T_valid_in = 1'b1;
    T_ready = 1'b1; 
    
  #100in_data = 8'hBB;
    T_valid_in = 1'b1;
    T_ready = 1'b1; 
end
endmodule
