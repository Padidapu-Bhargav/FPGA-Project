

module Resize#(parameter  WI1 = 5,           // integer part bitwidth for integer 1  
                          WF1 = 11,          // fractional part bitwidth for integer 1
                          WIO = 6,           // integer part bitwidth for addition output (user input)
                          WFO = 11          // integer part bitwidth for addition outout (user input)
                     ) (
                     input clk,
                     input reset,
                     input signed [ (WI1+WF1)-1 :0]product,
                     output reg signed [ (WIO+WFO)-1 :0]final_product
               );
    


// temporary register for calculation of SUM
reg [WI1-1:0]product_I;  // integer part of product
reg [WF1-1:0]product_F;  // fractional part of product
reg signed [(WIO+WFO)-1:0]product_temp; 
reg [WIO-1:0]product_temp_I; // integer part of temporary product
reg [WFO-1:0]product_temp_F; // fractional part of temporary product



///////////////////////////
//integer and fractional parts are separated and stored
///////////////////////////    
always @(*) begin
  product_I = product[(WI1+WF1-1):WF1];
  product_F = product[(WF1-1):0];
end

always @(*) begin
  if (WI1 > WIO) begin                                 
    product_temp_I = product_I[ WI1-WIO-1 :0];
  end
  else begin
    product_temp_I = { {(WIO-WI1) {product_I[WI1-1]} },product_I};
  end
end

always @(*) begin
  if (WF1 > WFO) begin
    product_temp_F = product_F[WF1-1:WF1-WFO];
  end
  else begin
    product_temp_F = {product_F,{(WFO-WF1){1'b0}}};
  end
 end

always @(*) begin
	 if(reset) begin
         final_product = 'd0;
	 end
	 else begin
           final_product = {product_temp_I,product_temp_F};
     end
end

endmodule
