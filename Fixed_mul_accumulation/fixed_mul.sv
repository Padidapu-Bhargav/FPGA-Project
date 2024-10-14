
module fixed_mul
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
                     output A_ready,
                     input A_last,
                     
                     //B channel
                     input signed [ (WI2+WF2)-1 :0]B_data,
                     input B_valid,
                     output B_ready,
                     input B_last,
                     
                     //out channel
                     output signed [ (WIO + WFO)-1 :0]out_data,
                     output out_valid,
                     input out_ready
                     
               );
// The final product integer length is taken as the sum of both integer parts
localparam F_int =  WI1+WI2 ;
// The final product Fraction length is taken as the sum of both Fraction parts 
localparam F_Frac =  WF1+WF2 ; 

//declare states
reg [1:0]current_state,next_state;
localparam IDLE=2'd0, MUL=2'd1,OUT=2'd2;

reg valid,ready,last;
reg [F_int+F_Frac+Extra-1:0]product;
reg [F_int+F_Frac+Extra-1:0]Data; // temporary out data
reg [F_int+F_Frac+Extra-1:0]accumulate; // final sum

Resize #(
    .WI1(F_int+Extra),
    .WF1(F_Frac),
    .WIO(WIO),
    .WFO(WFO))
    DUT_resize(.clk(clk),.reset(reset),.product(Data),.final_product(out_data)); 

assign B_ready = out_ready;
assign A_ready = out_ready;

//current state logic
always@(posedge clk) begin
    if(reset) current_state <= IDLE;
    else current_state <= next_state;
end

//next state logic
always@(*)begin
       
       case(current_state)
            IDLE:       begin
                        if(valid && ready) next_state <= MUL;
                        else next_state <= IDLE;
                        end
            
            MUL:        begin
                        if(last) begin
                            next_state <= OUT;
                            end
                        else begin
                            if(!(valid&& ready)) next_state <= IDLE;
                            else next_state <= MUL;
                            end
                        end
            
                                    
            OUT:        begin   
                            if(!(valid && ready)) next_state <= IDLE;
                            else if(last) next_state <= OUT;
                            else next_state <= MUL;
                        end
                        
            default: begin
                next_state <=IDLE;
            end
        endcase
end

always@(*) begin
    if(reset) begin
		valid <= 'd0;
		ready <= 'd0;
		last <= 'd0;
    end
    else begin 
        valid <= A_valid & B_valid;
        ready <= A_ready & B_ready;
        last <= A_last | B_last;
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
                        product <= A_data * B_data;
                        accumulate <= accumulate + product; 
                        end
                    else begin
                        product <= product;
                        accumulate <= accumulate;
                        end
                 end
           
            OUT :   begin
                    Data <= accumulate;
                    accumulate <= 'd0;    
                    end
        endcase
    end
end

//assign out_data = Data_temp;
assign out_valid = (current_state == OUT ? 1'd1 :1'd0);


endmodule
