`timescale 1ns / 1ps

module Pattern_detect_TB;

    parameter input_1_width=10;
    parameter input_2_width=10;
    parameter output_width=20;
    
    reg clk;
    reg [input_1_width:0] A;
    reg [input_2_width:0] B;
    wire [output_width:0] C;
    wire pattern_detection;
    
    Pattern_detect DUT(.clk(clk), .A(A), .B(B),
                       .C(C), .pattern_detection(pattern_detection));
                       
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end
    
initial begin
    A = 24'd12;
    B = 17'd2;
    repeat(15)@(posedge clk);
    A = 24'd12;
    B = 17'd3;
end

endmodule
