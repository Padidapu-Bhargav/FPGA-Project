
module fixed_mac
#(parameter  WI1 = 4,           // integer part bitwidth for integer 1  
             WF1 = 8,          // fractional part bitwidth for integer 1
             WI2 = 3,           // integer part bitwidth for integer 2
             WF2 = 5,          // fractional part bitwidth for integer
             WIO = 15,
             WFO = 30,
             Extra = 50 
             ) (
                     input clk,
                     input reset,
                     
                     //A channel
                     input signed [ (WI1+WF1)-1 :0]A_data,
                     input A_valid,
                     output reg A_ready,
                     input A_last,
                     
                     //B channel
                     input signed [ (WI2+WF2)-1 :0]B_data,
                     input B_valid,
                     output reg B_ready,
                     input B_last,
                     
                     //out channel
                     output signed [ (WIO + WFO)-1 :0]out_data,
                     output out_valid,
                     input out_ready,
                     output out_last,
                     
                     input OF_saturation,
                     output overflow,
                     
                     input UF_saturation,
                     output underflow                                         
               );
// The final product integer length is taken as the sum of both integer parts
localparam F_int =  WI1+WI2 ;
// The final product Fraction length is taken as the sum of both Fraction parts 
localparam F_Frac =  WF1+WF2 ; 

//declare states
reg [1:0]current_state,next_state;
localparam IDLE=2'd0, MUL=2'd1,OUT=2'd2;

// temporary registers to store the data if there is a valid
reg signed [ (WI1+WF1)-1 :0]A;
reg signed [ (WI2+WF2)-1 :0]B;

reg valid,ready,last;
reg signed [F_int+F_Frac-1:0]product;
reg signed [F_int+F_Frac-1:0]product_temp;
reg signed [F_int+F_Frac+Extra-1:0]Data; // temporary out data
reg signed [F_int+F_Frac+Extra-1:0]accumulate; // final sum
reg OF;
reg UF;

Resize #(
    .WI1(F_int+Extra),
    .WF1(F_Frac),
    .WIO(WIO),
    .WFO(WFO))
    DUT_resize(.clk(clk),.reset(reset),.Data(Data),.final_Data(out_data),
               .OF_saturation(OF_saturation), .overflow(OF),
               .UF_saturation(UF_saturation), .underflow(UF) ); 

// registering the A_data and B_data for a proper transaction
always@(posedge clk) begin 
    if(reset)begin
        A <= 'b0;
        B <= 'b0;
    end
    else begin
        A <= (A_valid && A_ready ) ? A_data : A;
        B <= (B_valid && B_ready ) ? B_data : B;
    end
end

//current state logic
always@(posedge clk) begin
    if(reset) current_state <= IDLE;
    else current_state <= next_state;
end

//next state logic
always@(*)begin
       case(current_state)
            IDLE:       begin
                        if(~reset) next_state <= MUL ;
                        else next_state <= IDLE;
                        end
            
            MUL:        begin
                        if(last ) begin
                            next_state <= OUT;
                            end
                        else begin
                            if(reset) next_state <= IDLE;
                            else next_state <= MUL;
                            end
                        end
            
                                    
            OUT:        begin  
                            if(out_ready) begin
                                if(reset) next_state <= IDLE;
                                else if(last) next_state <= OUT;
                                else next_state <= MUL;
                            end 
                            else begin
                                next_state <= OUT;
                            end
                        end
                        
            default: begin
                next_state <=IDLE;
            end
        endcase
end

// registerning the last signal
always@(posedge clk) begin
    if(reset) begin
        last <= 'd0;
    end
    else begin
        last <= A_last | B_last;
    end

end

always@(*) begin
    if(reset) begin
		valid <= 'd0;
        product_temp <= 'd0;
    end
    else begin 
        valid <= A_valid & B_valid; 
        product_temp <=(out_ready)? 'd0 :((last) ? product : product_temp);
    end
end
    
always@(*) begin
    if(reset) begin
        A_ready <= 'd0;
        B_ready <= 'd0;
        ready <= 'd0;
    end
    else begin
    
        case(current_state) 
            MUL:begin
                   ready <= 'd1;
                   B_ready <= ready & A_valid;
                   A_ready <= ready & B_valid;
                end
            default: begin
                        ready <= 'd0;
                     end
        endcase
    end
end

always@(posedge clk) begin
    if(reset) begin
        product <= 'd0;
        Data <= 'd0;
		accumulate <= 'd0;
    end
    else begin
         case(next_state)
            IDLE:begin
                     accumulate <= 'd0;
                     product <= 'd0;
                 end
            MUL: begin
                    if(valid && ready) begin
                        product <= A * B;
                        accumulate <= accumulate + product; 
                    end
                    else begin
                        product <= product;
                        accumulate <= accumulate;
                    end
                 end
           
            OUT :   begin
                    product <= 'd0;
                    Data <= accumulate+product_temp;
                    //Data <= (out_ready) ? 'd0 :accumulate+product_temp;
                    accumulate <= (out_ready) ? 'd0 :accumulate; 
                    end
        endcase
    end
end

assign out_valid = (current_state == OUT ? 1'd1 :1'd0);
assign overflow = OF;
assign underflow = UF;
assign out_last = (out_ready && out_valid) ? ((current_state == OUT)? 'd1: 'd0): 'd0;

endmodule
