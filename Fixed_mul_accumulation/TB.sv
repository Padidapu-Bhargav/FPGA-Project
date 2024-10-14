module TB();

parameter  WI1 = 6;           // integer part bitwidth for integer 1  
parameter  WF1 = 10;          // fractional part bitwidth for integer 1
parameter  WI2 = 4;           // integer part bitwidth for integer 2
parameter  WF2 = 8;           // fractional part bitwidth for integer
parameter WIO = 15;
parameter WFO = 30;
parameter Extra = 50;

reg clk;
reg reset;
                     
//A channel
reg signed [ (WI1+WF1)-1 :0]A_data;
reg A_valid;
wire A_ready;
reg A_last;
                     
//B channel
reg signed [ (WI2+WF2)-1 :0]B_data;
reg B_valid;
wire B_ready;
reg B_last;
                     
//out channel
wire signed [(WIO + WFO)-1 :0]out_data;
wire out_valid;
reg out_ready;

fixed_mul #( .WI1(WI1), .WF1(WF1), .WI2(WI2), .WF2(WF2), .WIO(WIO), .WFO(WFO), .Extra(Extra))
            DUT_module ( .clk(clk), .reset(reset),
                  .A_data(A_data), .A_valid(A_valid),
                  .A_ready(A_ready), .A_last(A_last),
                  .B_data(B_data), .B_valid(B_valid),
                  .B_ready(B_ready), .B_last(B_last),
                  .out_data(out_data), .out_valid(out_valid),
                  .out_ready(out_ready));

// Clock generation
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

// Reset logic
initial begin
    reset = 1;
    #20 reset = 0;
end

 /*  // CASE-1
// case-1 A channel stimulus
initial begin
    A_data = 'd0;
    A_valid = 0;
    A_last = 0;
    #20;
    A_valid = 1;
    A_data = 16'h1234;
    #100 A_last = 1;
    #20 A_last = 0;
end

// case-1 B channel stimulus
initial begin
    B_data = 'd0;
    B_valid = 0;
    B_last = 0;
    #20;
    B_valid = 1;
    B_data = $random;
    repeat(10) #20 B_data = $random; 
    B_last = 1;
    #20 B_last = 0;
    forever #20 B_data = $random;
end
 */

 /* // CASE-2
// case-2 A channel stimulus
initial begin
    A_data = 'd0;
    A_valid = 0;
    A_last ='d0;
    #20;
    A_valid = 1;
    A_data = $random;
    repeat(10) #20 A_data = $random; 
    A_last = 1;
    #20 A_last = 'd0;
    forever #20 A_data = $random;
end


// case-2 B channel stimulus
initial begin
    B_data = 'd0;
    B_valid = 0;
    B_last = 0;
    #20;
    B_valid = 1;
    B_data = 16'h4324;
    #100 B_last = 1;
    #20 B_last = 0;
end
 */

// /* // CASE-3
initial begin
    A_data = 'd0;
    B_data = 'd0;
    A_valid = 'd0;
    B_valid = 'd0;
    A_last ='d0;
    B_last = 'd0;
    #20;
    A_valid = 1'd1;
    B_valid = 1'd1;
    A_data = $random;
    B_data = $random;
    repeat(20)begin
        #20 A_data = $random;
        B_data = $random; 
    end
    A_last = 1'd1;
    #20 A_last = 'd0;
    repeat(20)begin
        #20 A_data = $random;
        B_data = $random; 
    end
    B_last = 1'd1;
    #20 B_last = 1'd0;
    repeat(20)begin
        #20 A_data = $random;
        B_data = $random; 
    end
    B_last = 1'd1;
    A_last = 1'd1;
    #20 B_last = 1'd0;
    A_last = 1'd0;
    forever begin
        #20 A_data = $random;
         B_data = $random;
    end
end
// */

// Output ready signal
initial begin
    out_ready = 1;
    #500 out_ready = 1;
   
end

// Simulation end
initial begin
    #300 $finish;
end

endmodule
