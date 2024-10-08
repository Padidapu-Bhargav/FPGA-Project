module arith_operations#(parameter Data_width_input= 8, 
						 parameter Data_width_output= 16)(
	 input clk,rst,							 
    input [Data_width_input -1:0]A,B,
    input [1:0]sel,
    output [Data_width_output-1:0]C,
    output [Data_width_input-1 :0]rem
    );
	 
	 reg [Data_width_input -1:0]A_temp=0;
	 reg [Data_width_input -1:0]B_temp=0;
    reg [1:0]sel_temp=0;
    reg [Data_width_output-1:0]C_temp=0;
    reg [Data_width_input-1 :0]rem_temp=0;
    
    always@(posedge clk) begin
        if(~rst) begin
            A_temp <= 'd0;
			B_temp <= 'd0;
			sel_temp <= 'd0;
            C_temp <= 'd0;
            rem_temp <= 'd0;
        end
        else begin
            A_temp <= A;
			B_temp <= B;
			sel_temp <= sel;
			
            case(sel_temp)
            2'b00:begin
                C_temp <= A_temp + B_temp;
                rem_temp <= 'd0;
            end
            2'b01:begin
                C_temp <= A_temp - B_temp;
                rem_temp <= 'd0;
            end
            2'b10:begin
                C_temp <= A_temp * B_temp;
                rem_temp <= 'd0;
            end
            2'b11:begin
                C_temp <= A_temp / B_temp;
                rem_temp <= A % B ;
            end
            default : begin
                C_temp <= 'd0;
                rem_temp <= 'd0;
            end
            endcase
        end 
    end
    assign C = C_temp;
    assign rem = rem_temp;
endmodule
