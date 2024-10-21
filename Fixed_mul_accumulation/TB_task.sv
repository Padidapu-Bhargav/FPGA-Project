module TB();

parameter  WI1 = 6;           // integer part bitwidth for integer 1  
parameter  WF1 = 10;          // fractional part bitwidth for integer 1
parameter  WI2 = 4;           // integer part bitwidth for integer 2
parameter  WF2 = 8;           // fractional part bitwidth for integer
parameter WIO = 7;
parameter WFO = 20;

localparam num_a = 10;
localparam num_b = 10 ;

localparam final_num = (num_a >= num_b) ? num_a : num_b ;

parameter Extra = $clog2(final_num);

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



 // Reset Task
task automatic reset_task;
    begin
        @(posedge clk);
        reset<=~reset;
        if(reset) begin
            $display("INFO: Reset Started");
        end
        else begin
            $display("INFO: Reset Done!");
        end
    end
endtask

task A_channel(input integer Num_cycles, input signed [WI1+WF1-1:0]Data, input is_random);
    integer i;
    begin
        
        if (is_random) begin
            A_data = $random;
            A_valid <= 'd1;
        end
        else begin
            A_data = Data ;
            A_valid <= 'd1;
            repeat(2)@(posedge clk);
            A_last = 1;
        end
        for (i = 0; i < Num_cycles; i = i + 1) begin
                #20;
                if (is_random) begin
                    A_data = $random;
                    A_valid <= 'd1;
                end
                else begin
                    A_data = Data ; // or any other deterministic pattern
                    A_valid <= 'd1;
                end
            end
        A_last = (is_random)? 1'd1: 1'd0;
        if(is_random)#20;
        else #0;
        A_last = 1'd0;
        A_data = 'd0;
        A_valid = 1'd0;
    end
endtask

task B_channel(input integer Num_cycles, input signed [WI2+WF2-1:0]Data, input is_random);
    integer i;
    begin
        
        if (is_random)begin
            B_data = $random;
            B_valid <= 'd1;
        end
        else begin
            B_data = Data ;
            B_valid <= 'd1;
            repeat(2)@(posedge clk);
            B_last = 1;
        end
        for (i =0 ; i < Num_cycles; i = i + 1) begin
                #20;
                if (is_random) begin
                    B_data = $random;
                    B_valid <= 'd1;
                end
                else begin
                    B_data = Data ; // or any other deterministic pattern
                    B_valid <= 'd1;
                end
            end
        B_last = (is_random) ? 1'd1 : 1'd0;
        if(is_random)#20;
        else #0;
        B_last = 1'd0;
        B_data = 'd0;
        B_valid = 1'd0;
    end
endtask

integer a_num,b_num;

// Clock generation
initial begin
    clk = 1;
    forever begin
        #10 clk = ~clk;
    end
end

initial begin
    reset=1;
    a_num = num_a;
    b_num = num_b;
    @(posedge clk);
    reset_task;
    A_data = 'd0;
    A_valid = 'd0;
    A_last = 'd0;
    B_data = 'd0;
    B_valid = 'd0;
    B_last = 'd0;
    
     //CASE-1
    @(negedge clk);
    fork
          A_channel( a_num, 16'h1234, 0);
          B_channel( b_num, $random, 1);
    join 
    
     //CASE-2
    repeat(5)@(negedge clk);
    fork
          A_channel( a_num, 16'h1234, 1);
          B_channel( b_num, 12'h467, 0);
    join 
    
     //CASE-3
    repeat(2) @(negedge clk);
    fork
        A_channel( a_num, 16'h1234, 1);
        B_channel( b_num, 12'h467, 1);
    join 
    /*repeat(2) @(negedge clk);
    fork
        A_channel( a_num, 16'h1234, 1);
        B_channel( b_num, 12'h467, 1);
    join 
    repeat(2) @(negedge clk);
    fork
        A_channel( a_num, 16'h1234, 1);
        B_channel( b_num, 12'h467, 1);
    join */ 
        
end 

// Output ready signal
initial begin
    out_ready = 0;
    repeat(18)@(posedge clk);
    out_ready = 1;
    repeat(3)@(posedge clk);
    out_ready = 0;
    repeat(12)@(posedge clk);
    out_ready = 1;
    repeat(2)@(posedge clk);
    out_ready = 0;
    repeat(12)@(posedge clk);
    out_ready = 1;     
    repeat(2)@(posedge clk);
    out_ready = 0;          
end
// Simulation end
//initial begin
//    #300 $finish;
//end

endmodule
