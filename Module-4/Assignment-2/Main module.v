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


module FP_Mul
#(parameter  WI1 = 5,           // integer part bitwidth for integer 1  
             WF1 = 11,          // fractional part bitwidth for integer 1
             WI2 = 5,           // integer part bitwidth for integer 2
             WF2 = 11,          // fractional part bitwidth for integer 2
             WIO = 6,           // integer part bitwidth for addition output (user input)
             WFO = 11          // integer part bitwidth for addition outout (user input)
             ) (
                     input clk,
                     input reset,
                     input signed [ (WI1+WF1)-1 :0]A,
                     input signed [ (WI2+WF2)-1 :0]B,
                     output reg signed [ (WIO+WFO)-1 :0]C,
                     output reg overflow,
                     output reg underflow
               );
 
localparam F_int =  WI1+WI2 ; // Final integer part length among the two numbers is taken
localparam F_Frac =  WF1+WF2 ; // Final fractional part length among the two numbers is taken

reg [F_int+F_Frac:0]product;
reg [F_int:0]product_I;
reg [F_Frac-1:0]product_F;

reg [WIO-1:0]C_I;
reg [WFO-1:0]C_F;

always@(posedge clk) begin
     if(reset) begin
        product <= 'd0;
        C_I <= 'd0;
        C_F <= 'd0;
        overflow <= 'd0;
        underflow <= 'd0;
     end
     else begin
       product = A*B;
       product_I = product[F_int+F_Frac:F_Frac];
       product_F = product[F_Frac:0];
     end
     
     underflow = |product_F[F_Frac-WFO-1:0];
     
     if(WIO>F_int)
        overflow=0;
     else if(product[F_int+F_Frac]==0)
        overflow=|product[F_int+F_Frac:(F_int+F_Frac-(F_int-(WIO-1)))];
     else if(product[F_int+F_Frac]==1)
        overflow=(~(&product[F_int+F_Frac:F_Frac+WIO-1]));
     else
        overflow=0;  
end

always@(posedge clk) begin
    C_F <= product_F[F_Frac-1:F_Frac-WFO];
    if(overflow)begin
        if(product[F_int+F_Frac] == 0) begin
            C_I <= {product[F_int+F_Frac],{(WIO-1){1'b1}}};
        end
        else if( product[F_int+F_Frac] == 1) begin
            C_I <= {product[F_int+F_Frac],{(WIO-1){1'b0}}};
        end
     end
     else begin
        C_I <= product_I[WIO-1:0];
     end
     C <= {C_I,C_F};
end

endmodule
