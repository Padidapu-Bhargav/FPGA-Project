`timescale 1ns / 1ps

module Pattern_detect#(parameter input_1_width=10,
                       parameter input_2_width=10,
                       parameter output_width=20)(
    input clk,
    input [input_1_width:0] A,
    input [input_2_width:0] B,
    input [output_width:0] pd_pattern1,
    output  [output_width:0] C,
    output reg ones_o
);

reg [output_width:0] ab;


// Pattern detect mask
reg [input_1_width:0] A1;
reg [input_2_width:0] B1;
reg [output_width:0] pd_pattern;
reg [output_width :0] mask = 20'b11111111111111111111;

always @(posedge clk) begin
A1 <= A;
B1 <= B;
pd_pattern <= pd_pattern1;
end

always @(posedge clk) begin
      
    ab <= A1 * B1 ; // Perform the multiplication

    // Pattern detect logic
    if (ab == (pd_pattern||mask)) begin
        ones_o <= 1'b1; // Set ones_o if pattern detected
    end else begin
        ones_o <= 1'b0; // Reset ones_o if pattern not detected
    end
end

assign C = ab;
endmodule
