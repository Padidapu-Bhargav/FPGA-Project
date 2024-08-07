


module fixed_mul
#(parameter  WI1 = 5,           // integer part bitwidth for integer 1  
             WF1 = 11,          // fractional part bitwidth for integer 1
             WI2 = 5,           // integer part bitwidth for integer 2
             WF2 = 11,          // fractional part bitwidth for integer 2
             WIO = 10,           // integer part bitwidth for addition output (user input)
             WFO = 22          // integer part bitwidth for addition outout (user input)
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

reg [F_int+F_Frac-1:0]product;
reg [F_int-1:0]product_I;
reg [F_Frac-1:0]product_F;

reg [WIO-1:0]C_I;
reg [WFO-1:0]C_F;

always@(posedge clk) begin
     if(reset) begin
        product <= 'd0;
		  product_I <= 'd0;
		  product_F <= 'd0;
        overflow <= 'd0;
        underflow <= 'd0;
     end
     else begin
       product <= A*B;
       product_I <= product[F_int+F_Frac-1:F_Frac];
       product_F <= product[F_Frac-1:0];
     end
     
	  if(WFO != F_Frac)    underflow <= |product_F[F_Frac-WFO-1:0];
	  else underflow <= 0;
     
     if(WIO >= F_int)
        overflow <= 0;
     else begin
		  if(product[F_int+F_Frac-1]==0)
          overflow <=|product[F_int+F_Frac-1:(F_int+F_Frac-1-(F_int-WIO))];
        if(product[F_int+F_Frac-1]==1)
          overflow <=(~(&product[F_int+F_Frac-1:(F_int+F_Frac-1-(F_int-WIO))]));
		end
end

always@(posedge clk) begin

	 if(reset) begin
		C_I <= 'd0;
      C_F <= 'd0;
	 end
	 
	 C_F <= product_F[F_Frac-1:F_Frac-WFO];
	 
    if(overflow)begin
        if(product[F_int+F_Frac-1] == 0) 
			C_I <= {product[F_int+F_Frac-1],{(WIO-1){1'b1}}};
        if(product[F_int+F_Frac-1] == 1) 
			C_I <= {product[F_int+F_Frac-1],{(WIO-1){1'b0}}};
     end
     else begin
        C_I <= product_I[WIO-1:0];
     end
	  
	  if(underflow)  
		C <= {C_I,C_F,{{F_Frac-WFO-1},{1'b0}}};
	  else C <= {C_I,C_F};
end

endmodule
