`timescale 1ns / 1ps

module Pattern_detect_TB;

    parameter input_1_width=10;
    parameter input_2_width=10;
    parameter output_width=20;
    
    reg clk;
    reg [input_1_width:0] A;
    reg [input_2_width:0] B;
    reg [output_width:0] pd_pattern1;
    wire  [output_width:0] C;
    wire ones_o;
    
    Pattern_detect DUT(.clk(clk), .A(A), .B(B), .pd_pattern1(pd_pattern1),
                       .C(C), .ones_o(ones_o));
                       
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end
    
initial begin
    A = 24'd12;
    B = 17'd2;
    pd_pattern1 =  43'd24;;
end

endmodule
