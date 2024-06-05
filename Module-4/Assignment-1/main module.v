`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2024 12:34:41
// Design Name: 
// Module Name: Fixed_point_add
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


module Fixed_point_add
#(parameter  WI1 = 5,           // integer part bitwidth for integer 1  
             WF1 = 11,          // fractional part bitwidth for integer 1
             WI2 = 5,           // integer part bitwidth for integer 2
             WF2 = 11,          // fractional part bitwidth for integer 2
             WIO = 6,           // integer part bitwidth for addition output (user input)
             WFO = 11 ,         // integer part bitwidth for addition outout (user input)
             F_int = ((WI1>=WI2))?WI1:WI2,// Final integer part length among the two numbers is taken
             F_Frac = ((WF1>=WF2))?WF1:WF2 // Final fractional part length among the two numbers is taken
             ) (
                     input clk,
                     input reset,
                     input signed [ (WI1+WF1)-1 :0]A,
                     input signed [ (WI1+WF1)-1 :0]B,
                     output reg signed [ (WIO+WFO)-1 :0]C
               );
 
 
reg [WI1-1:0]A_I;  // integer part of A
reg [WF1-1:0]A_F;  // fractional part of A
reg [WI2-1:0]B_I;  // integer part of B
reg [WF2-1:0]B_F;  // fractional part of B
reg signed [(F_int+F_Frac)-1:0]A_temp; 
reg [F_int-1:0]A_temp_I; // integer part of temporary A
reg [F_Frac-1:0]A_temp_F; // fractional part of temporary A
reg signed [(F_int+F_Frac)-1:0]B_temp;
reg [F_int-1:0]B_temp_I; // integer part of temporary B
reg [F_Frac-1:0]B_temp_F; // fractional part of temporary B
  reg [F_int+F_Frac:0]sum; // temporary sum
  reg [F_int:0]sum_I; // integer part of temporary sum
  reg [F_Frac-1:0]sum_F; // fractional part of temporary sum



reg overflow=0;
reg underflow=0;

///////////////////////////
//integer and fractional parts are separated and stored
///////////////////////////    
always @(*) begin
  A_I = A[(WI1+WF1-1):WF1];
  A_F = A[(WF1-1):0];
  B_I = B[(WI2+WF2-1):WF2];
  B_F = B[(WF2-1):0];
end

always @(*) begin
  if (WI1 > WI2) begin                                 
    B_temp_I = { {(WI1-WI2) {B_I[WI2-1]} },B_I};
    A_temp_I = A_I;
  end
  else begin
    A_temp_I = { {(WI2-WI1) {A_I[WI1-1]} },A_I};
    B_temp_I = B_I;
  end
end

  
always @(*) begin
  if (WF1 > WF2) begin
    B_temp_F = {B_F,{(WF1-WF2){1'b0}}};
    A_temp_F = A_F;
  end
  else begin
    A_temp_F = {A_F,{(WF2-WF1){1'b0}}};
    B_temp_F = B_F;
  end
 end

always @* begin
    A_temp = {A_temp_I,A_temp_F};
    B_temp = {B_temp_I,B_temp_F};
end

reg [WIO-1:0]C_I;
reg [WFO-1:0]C_F;

always@(posedge clk) begin
     if(reset) begin
        sum <= 'd0;
        C_I <= 'd0;
        C_F <= 'd0;
        overflow <= 'd0;
        underflow <= 'd0;
     end
     else begin
       sum = A_temp+B_temp;
       sum_I = sum[F_int+F_Frac:F_Frac];
       sum_F = sum[F_Frac:0];
       
     end
     underflow = |sum_F[F_Frac-WFO-1:0];
     if(WIO>F_int)
        overflow=0;
     else if(sum[F_int+F_Frac]==0)
        overflow=|sum[F_int+F_Frac:(F_int+F_Frac-(F_int-(WIO-1)))];
     else if(WIO==F_int)
        overflow=(A_temp[F_int+F_Frac-1]^sum[F_int+F_Frac-1]) &&
                 (B_temp[F_int+F_Frac-1]^sum[F_int+F_Frac-1]); 
     else if(sum[F_int+F_Frac]==1)
        overflow=(~(&sum[F_int+F_Frac:F_Frac+WIO-1]));
     else
        overflow=0;  
end

always@(posedge clk) begin
    C_F <= sum_F[F_Frac-1:F_Frac-WFO];
    if(overflow)begin
        if(sum[F_int+F_Frac] == 0) begin
            C_I <= {sum[F_int+F_Frac],{(WIO-1){1'b1}}};
        end
        else if( sum[F_int+F_Frac] == 1) begin
            C_I <= {sum[F_int+F_Frac],{(WIO-1){1'b0}}};
        end
     end
     else begin
        C_I <= sum_I[WIO-1:0];
     end
     C <= {C_I,C_F};
end
    
endmodule
