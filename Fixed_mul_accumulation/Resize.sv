

module Resize#(parameter  WI1 = 5,           // integer part bitwidth for integer 1  
                          WF1 = 11,          // fractional part bitwidth for integer 1
                          WIO = 6,           // integer part bitwidth for addition output (user input)
                          WFO = 11          // integer part bitwidth for addition outout (user input)
                     ) (
                     input clk,
                     input reset,
                     input signed [ (WI1+WF1)-1 :0]Data,
                     output signed [ (WIO+WFO)-1 :0]final_Data,
                     output overflow
               );
    


// temporary register for calculation of SUM
reg [WI1-1:0]Data_I;  // integer part of product
reg [WF1-1:0]Data_F;  // fractional part of product
reg signed [(WIO+WFO)-1:0]Data_temp; 
reg [WIO-1:0]Data_temp_I; // integer part of temporary product
reg [WFO-1:0]Data_temp_F; // fractional part of temporary product
reg OF;


///////////////////////////
//integer and fractional parts are separated and stored
///////////////////////////    
always @(*) begin
  Data_I = Data[(WI1+WF1-1):WF1];
  Data_F = Data[(WF1-1):0];
end

// overflow condition
always@(*) begin
   if(reset) OF <= 0;
   else begin
       if(WIO>WI1) OF <=0;
       else if(Data[WI1+WF1-1]==0)
           OF <=|Data[WI1+WF1-1: WF1+WIO-1];
       else if(Data[WI1+WF1-1]==1)
           OF <=(~(&Data[WI1+WF1-1: WF1+WIO-1]));
       else
           OF <=0;
   end    
end

always @(*) begin
  if (WI1 > WIO) begin                                 
    Data_temp_I = {Data_I[WI1-1],Data_I[ WIO-1 :0]};
  end
  else begin
    Data_temp_I = { {(WIO-WI1) {Data_I[WI1-1]} },Data_I};
  end
end

always @(*) begin
  if (WF1 > WFO) begin
    Data_temp_F = Data_F[WF1-1:WF1-WFO];
  end
  else begin
    Data_temp_F = {Data_F,{(WFO-WF1){1'b0}}};
  end
 end
 
always @(*) begin
	 if(reset) begin
        Data_temp = 'd0;
	 end
	 else begin
	    Data_temp = {Data_temp_I,Data_temp_F};
     end
end

assign final_Data = Data_temp;
assign overflow = OF;

endmodule
