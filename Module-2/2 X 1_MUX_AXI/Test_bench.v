`timescale 1ns / 1ps


module TB();
reg sel;
reg [7:0]A,B;
reg clk,reset,Tvalid,Tready,Tlast;
wire [7:0]out;
Mux_2_1 sample(sel,A,B,clk,reset,Tvalid,Tready,Tlast,out);

 /*task set_inputs(
        input [7:0] d0, d1,
        input s,TV,TR,
        output sel,tv,tr,
        output [7:0]A,B);
        begin
            A <= d0;
            B <= d1;
            sel <= s;
        end
    endtask*/

initial begin
clk <=0;
sel <=0;
reset <= 0;
Tvalid <=0;
Tready <=0;
Tlast <=0;
end

initial begin
    forever #5 clk = ~clk;
    end
    
/*initial begin
    forever #50 reset = ~reset;
    end*/
  
initial begin
    forever #150 Tlast = ~Tlast;
    end

initial begin
    forever #10 sel = ~sel;
    end
    
initial begin
  /*  set_inputs(8'h22,8'h33,1'b1,1'b1,1'b1,sel,Tvalid,Tready,A,B);
    #200; set_inputs(8'h44,8'h55,1'b1,1'b1,1'b1,sel,Tvalid,Tready,A,B);*/
      A = 8'h22; B = 8'h33 ; Tvalid =1 ; Tready =1 ; 
   #100   A = 8'h33; B = 8'h44 ; Tvalid =1 ; Tready =0 ;
   #100   A = 8'h55; B = 8'h66 ; Tvalid =1 ; Tready =1 ;
   #100   A = 8'h22; B = 8'h33 ; Tvalid =1 ; Tready =1 ;
   #100   A = 8'h11; B = 8'h44 ; Tvalid =0 ; Tready =0 ;
   #100   A = 8'h55; B = 8'h88 ; Tvalid =1 ; Tready =0 ;
   #100   A = 8'h12; B = 8'h56 ; Tvalid =1 ; Tready =1 ;
   #100   A = 8'h90; B = 8'h15 ; Tvalid =1 ; Tready =1 ;
      

end
endmodule
