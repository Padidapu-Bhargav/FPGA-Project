module TB();

parameter  WI1 = 6;           // integer part bitwidth for integer 1  
parameter  WF1 = 10;          // fractional part bitwidth for integer 1
parameter  WI2 = 4;           // integer part bitwidth for integer 2
parameter  WF2 = 8;           // fractional part bitwidth for integer
parameter WIO = 7;
parameter WFO = 13;

localparam num_a = 30;
localparam num_b = 30;
localparam num_out = 100;
  
localparam num_final = (num_a >= num_b) ? num_a : num_b ;

parameter Extra = $clog2(num_final);

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

wire overflow;
reg OF_saturation;
wire underflow;
reg UF_saturation;

fixed_mac #( .WI1(WI1), .WF1(WF1), .WI2(WI2), .WF2(WF2), .WIO(WIO), .WFO(WFO), .Extra(Extra))
            DUT_module ( .clk(clk), .reset(reset),
                  .A_data(A_data), .A_valid(A_valid),
                  .A_ready(A_ready), .A_last(A_last),
                  .B_data(B_data), .B_valid(B_valid),
                  .B_ready(B_ready), .B_last(B_last),
                  .out_data(out_data), .out_valid(out_valid),
                  .out_ready(out_ready), .overflow(overflow),
                  .OF_saturation(OF_saturation), .underflow(underflow),
                  .UF_saturation(UF_saturation));


integer a_num,b_num,out_num;

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
    out_num = num_out;
   
    reset_task;
    A_data = 'd0;
    A_valid = 'd0;
    A_last = 'd0;
    B_data = 'd0;
    B_valid = 'd0;
    B_last = 'd0;
    out_ready = 'd0;
    OF_saturation = 'd1;
    UF_saturation = 'd1;
    
     //CASE-1
    repeat(3)@(posedge clk);
    fork
        begin
        B_channel( b_num, 12'h234, 1, 9);
        end
        begin
            A_channel( a_num, 16'h1234, 1, 7);
            //repeat(5)@(negedge clk);
            //A_channel( a_num, 16'h1234, 1, 5);
        end
        begin
        outready ( out_num);
        end
    join
    A_data = 16'h0400;
    B_data = 12'h0100;
    
    /* //CASE-2
    repeat(10)@(negedge clk);
    fork
          A_channel( a_num, 16'h1234, 1, 8);
          B_channel( b_num, 12'h467, 0, 6);
          outready ( out_num);
    join 
    A_data = 16'h0800;
    B_data = 12'h0200; */
    
    /* //CASE-3
    repeat(3)@(negedge clk);
    fork
        B_channel( b_num, 12'h467, 1, 8);
        begin
            A_channel( a_num, 16'h1234, 1, 5);
            repeat(9)@(negedge clk);
            A_channel( a_num, 16'h1234, 1, 5);
        end
        outready ( out_num);
    join 
    //A_data = 16'h0c00;
    //B_data = 12'h0400;
    //OF_saturation = 'd1;
    //  UF_saturation = 'd1;
    repeat(2) @(negedge clk);
    fork
        A_channel( a_num, 16'h1234, 1,5);
        B_channel( b_num, 12'h467, 1,6);
    join 
    repeat(2) @(negedge clk);
    fork
        A_channel( a_num, 16'h1234, 1);
        B_channel( b_num, 12'h467, 1);
    join */ 
        
end 

// tasks

// outready based on no of clock cycles
task outready(input integer Num_cycles);
begin
    integer i;
    @(posedge clk);
    for (i = 0; i < (2*Num_cycles); i = i + 1) begin
                #20;
               out_ready = (i==Num_cycles-1) ? 1'd1 : 1'd0;
    end
    #20;
    out_ready = 'd0;
end
endtask

 // Reset Task
task automatic reset_task;
    begin
        repeat(3)@(posedge clk);
        reset<=~reset;
        if(reset) begin
            $display("INFO: Reset Started");
        end
        else begin
            $display("INFO: Reset Done!");
        end
    end
endtask


// A channel data with throttle and wait
task A_channel(input integer Num_cycles, input signed [WI1+WF1-1:0]Data, 
               input is_random, input integer throttle);
    integer i;
    
    begin
         A_valid = 'd1;
         A_data = Data ;
         //#20;
         for (i = 1; i < (2*Num_cycles); i = i + 1) begin
                #20;
                $display("A = %0d, Num_cycles = %0d",i,Num_cycles);
                while(!A_ready)begin
                    #20;
                    //i = i-1;
                end
                
                if(A_ready)begin
                   if (is_random) begin
                        A_data = (A_valid)?$random:A_data;
                        if( i % (throttle) == 0) A_valid =~A_valid;
                        else A_valid = A_valid;
                    end
                    else begin
                        if( i % (throttle) == 0) A_valid =~A_valid;
                        else A_valid = A_valid;
                    end
                    A_last = ( i == (2*Num_cycles)-2) ? 1'd1 : 'd0 ;
                    //#20; 
                end
                
            end
            //A_last = 1'd1;
        //#20;
        A_last = 1'd0;
        A_data <= 'd0;
        A_valid = 'd0;
    end
endtask

// B channel data with throttle and wait
task B_channel(input integer Num_cycles, input signed [WI1+WF1-1:0]Data, 
               input is_random, input integer throttle);
    integer i;
    begin
        B_valid = 'd1;
        B_data = Data ;
        //#20;
        for (i = 1; i < (2*Num_cycles); i = i + 1) begin  
        $display("B = %0d, num = %0d",i,Num_cycles);          
           #20; 
            while(!B_ready)begin
                #20;
                //i = i-1;
            end
            if(B_ready) begin
                if (is_random) begin
                    B_data = (B_valid)?$random:B_data;
                    if( i % (throttle) == 0) B_valid =~B_valid;
                    else B_valid = B_valid;
                end
                else begin
                    if( i % (throttle) == 0) B_valid =~B_valid ;
                    else B_valid = B_valid;
                end
                B_last = ( i == (2*Num_cycles)-3) ? 1'd1 : 'd0 ;
                //#20;
            end
            
        end
       // B_last = 1'd1;
        //#20;
        B_last = 1'd0;
        B_data = 'd0;
        B_valid = 1'd0;
    end
endtask

// A channel data original
/*task A_channel(input integer Num_cycles, input signed [WI1+WF1-1:0]Data, input is_random);
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
endtask*/

/* // A channel data without throttle
task A_channel(input integer Num_cycles, input signed [WI1+WF1-1:0]Data, 
               input is_random, input throttle);
    integer i;
    begin
        A_data = Data ;
        A_valid <= 'd1;
        for (i = 0; i < Num_cycles; i = i + 1) begin
                #20;
                if (is_random) begin
                    A_data = $random;
                    A_valid <= 'd1;
                end
                else begin
                    A_data = Data ; 
                    A_valid <= 'd1;
                end
            end
        A_last = 1'd1;
        #20;
        A_last = 1'd0;
        A_data = 'd0;
        A_valid = 1'd0;
    end
endtask*/

/* // A channel data with throttle
task A_channel(input integer Num_cycles, input signed [WI1+WF1-1:0]Data, 
               input is_random, input integer throttle);
    integer i;
    begin
        A_data = Data ;
        A_valid = 'd1;
        for (i = 1; i < Num_cycles; i = i + 1) begin
                #20;
                if (is_random) begin
                    A_data = (A_valid)?$random:A_data;
                    if( i % (throttle) == 0) A_valid = ~A_valid;
                    else A_valid = A_valid;
                end
                else begin
                    if( i % (throttle) == 0) A_valid = ~A_valid;
                    else A_valid = A_valid;
                end
            end
        A_last = 1'd1;
        #20;
        A_last = 1'd0;
        A_data = 'd0;
        A_valid = 1'd0;
    end
endtask */

/* // B channel data with throttle
task B_channel(input integer Num_cycles, input signed [WI1+WF1-1:0]Data, 
               input is_random, input integer throttle);
    integer i;
    begin
        B_data = Data ;
        B_valid = 'd1;
        for (i = 1; i < Num_cycles; i = i + 1) begin
                #20;
                if (is_random) begin
                    B_data = (B_valid)?$random:B_data;
                    if( i % (throttle) == 0) B_valid = ~B_valid;
                    else B_valid = B_valid;
                end
                else begin
                    if( i % (throttle) == 0) B_valid = ~B_valid;
                    else B_valid = B_valid;
                end
            end
        B_last = 1'd1;
        #20;
        B_last = 1'd0;
        B_data = 'd0;
        B_valid = 1'd0;
    end
endtask*/

/* //B channel data without throttle
task B_channel(input integer Num_cycles, input signed [WI2+WF2-1:0]Data,
               input is_random);
    integer i;
    begin
        B_data = Data ;
        B_valid <= 'd1;
        for (i = 0; i < Num_cycles; i = i + 1) begin
                #20;
                if (is_random) begin
                    B_data = $random;
                    B_valid <= 'd1;
                end
                else begin
                    B_data = Data ; 
                    B_valid <= 'd1;
                end
            end
        B_last = 1'd1;
        #20;
        B_last = 1'd0;
        B_data = 'd0;
        B_valid = 1'd0;
    end
endtask */

/* //B channel data original
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
endtask*/


endmodule
