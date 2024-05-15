`timescale 1ns / 1ps

module Pattern_detect#(parameter input_1_width=10,
                       parameter input_2_width=10,
                       parameter output_width=20,
                       parameter pattern=20'd36)(
    input clk,
    input [input_1_width:0] A,
    input [input_2_width:0] B,
    output  [output_width:0] C,
    output reg pattern_detection
);

reg [output_width:0] ab;


// Pattern detect mask
reg [input_1_width:0] A1;
reg [input_2_width:0] B1;


always @(posedge clk) begin
A1 <= A;
B1 <= B;
end

always @(posedge clk) begin
      
    ab <= A1 * B1 ; 

    if (ab == pattern ) begin
        pattern_detection <= 1'b1; 
    end else begin
        pattern_detection <= 1'b0;
    end
end

assign C = ab;
endmodule
