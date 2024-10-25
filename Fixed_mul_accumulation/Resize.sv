module Resize#(parameter  WI1 = 5,           // integer part bitwidth for integer 1  
                          WF1 = 11,          // fractional part bitwidth for integer 1
                          WIO = 6,           // integer part bitwidth for addition output (user input)
                          WFO = 11          // integer part bitwidth for addition outout (user input)
                     ) (
                     input clk,
                     input reset,
                     input signed [ (WI1+WF1)-1 :0]input_Data,
                     output signed [ (WIO+WFO)-1 :0]final_Data,
                     input OF_saturation,
                     output overflow,
                     input UF_saturation,
                     output underflow);
    

reg signed [ (WI1+WF1)-1 :0]Data;
// temporary register for calculation of SUM
reg [WI1-1:0]Data_I;  // integer part of product
reg [WF1-1:0]Data_F;  // fractional part of product
reg signed [(WIO+WFO)-1:0]Data_temp; 
reg [WIO-1:0]Data_temp_I; // integer part of temporary product
reg [WFO-1:0]Data_temp_F; // fractional part of temporary product
reg OF_internal;
reg UF_internal;


///////////////////////////
//integer and fractional parts are separated and stored
///////////////////////////    
always @(*) begin
    if(reset) begin
        Data  = 'd0;
        Data_I = 'd0;
        Data_F = 'd0;
    end
    else begin
        Data = input_Data;
        Data_I = Data[(WI1+WF1-1):WF1];
        Data_F = Data[(WF1-1):0];
    end
  
end

// overflow condition
always@(*) begin
   if(reset) OF_internal = 0;
   else begin
       if(WIO>WI1) OF_internal = 0;
       else if(Data[WI1+WF1-1]==0)
           OF_internal = |Data[WI1+WF1-1: WF1+WIO-1];
       else if(Data[WI1+WF1-1]==1)
           OF_internal  = (~(&Data[WI1+WF1-1: WF1+WIO-1]));
       else
           OF_internal = 0;
   end    
end

//undeflow condition
always@(*) begin
    if(reset) UF_internal = 'd0;
    else begin
        if((WFO != WF1) && (WF1 > WFO )) UF_internal = |Data[WF1-WFO-1:0];
	    else UF_internal =  0;
    end

end

always @(*) begin
    if(reset) begin
        Data_temp_I = 'd0;
    end
    else begin
        if(OF_internal && OF_saturation) begin
            if(Data_I[WI1-1] == 0) Data_temp_I = {Data_I[WI1-1],{(WIO-1){1'b1}}};
            else Data_temp_I = {Data_I[WI1-1],{(WIO-1){1'b0}}};
        end 
        else begin
            if (WI1 > WIO) Data_temp_I = {Data_I[WI1-1],Data_I[ WIO-2 :0]};
            else Data_temp_I = { {(WIO-WI1) {Data_I[WI1-1]} },Data_I};
        end
    end
    
end

always @(*) begin
    if(reset) begin
        Data_temp_F = 'd0;
    end
    else begin
        if(UF_internal && UF_saturation) begin
            Data_temp_F = {(WFO){1'b1}};
        end 
        else begin
            if (WF1 > WFO) Data_temp_F = Data_F[WF1-1:WF1-WFO];
            else  Data_temp_F = {Data_F,{(WFO-WF1){1'b0}}};
        end
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
assign overflow = OF_internal;
assign underflow = UF_internal;

endmodule
