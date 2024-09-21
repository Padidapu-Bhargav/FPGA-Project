module arith_operations(
    input [7:0]A,B,
    input [1:0]sel,
    output reg [15:0]C,
    output reg [7:0]rem
    );
    
    always@(*) begin
        case(sel)
            2'b00:begin
                C <= A + B;
                rem <= 'd0;
            end
            2'b01:begin
                C <= A - B;
                rem <= 'd0;
            end
            2'b10:begin
                C <= A * B;
                rem <= 'd0;
            end
            2'b11:begin
                C <= A / B;
                rem <= A % B ;
            end
            default : begin
                C <= 'd0;
                rem <= 'd0;
            end
        endcase
    end
endmodule
