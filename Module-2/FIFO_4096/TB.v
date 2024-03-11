module testbench_fifo_2048;

    // Signals
    reg [7:0] data_in;
    reg clk,reset,w_en,r_en;
    wire full, empty;
    wire [3:0]fifo_cnt_1;
    wire [3:0]fifo_cnt_2;
    wire [7:0] final_data;

    // Instantiate DUT
    FIFO_4096 dut (
        .data_in(data_in),
        .clk(clk),
        .rst(reset),
        .r_en(r_en),
        .w_en(w_en),
        .empty(empty),
        .full(full),
        .fifo_cnt_1(fifo_cnt_1),
        .fifo_cnt_2(fifo_cnt_2),
        .final_data(final_data)
    );
 
   
// Clock Generation
 initial 
    begin
        clk = 1;
        forever #10 clk = ~clk;
    end
    

    
//reset
initial begin
     reset = 0;
     #20 reset = ~reset;
     #10 reset = ~ reset;
end
   
initial begin
    repeat (1000)
        begin
            //data_in = 8'h00;
            #20 data_in = $random;
        end
     end
     

     initial 
     begin
           w_en = 1;        r_en = 0;
       #10 w_en = 1;        r_en = 0;
       #100 w_en = 1;        r_en = 0;
       #150 w_en = 0;        r_en = 1;
       #150 w_en = 0;        r_en = 1;
       #100 w_en = 0;        r_en = 1;
       
     end

endmodule

