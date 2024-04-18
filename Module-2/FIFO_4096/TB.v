module TB();
   // 4096 Testbench
    // Signals
    //reg [7:0] data_in;
    parameter Depth = 16;
    parameter Ptr_width=$clog2(Depth);
    
    reg clk,reset,w_en,r_en;
    wire full, empty;
    wire [11:0]fifo_cnt_1;
    wire [11:0]fifo_cnt_2;
    wire [31:0]data_out_1;
    wire [31:0]data_out_2;
    
    reg [31:0]s_data;
    reg s_valid;
    wire s_ready;
    reg  s_last;
    
    //master
    wire  [31:0]m_data;
    wire  m_valid;
    reg m_ready;
    wire  m_last;

    // Instantiate DUT
    FIFO_4096 dut (
       // .data_in(data_in),
        .clk(clk),
        .rst(reset),
        .r_en(r_en),
        .w_en(w_en),
        .empty(empty),
        .data_out_1(data_out_1),
        .full(full),
        .fifo_cnt_1(fifo_cnt_1),
        .fifo_cnt_2(fifo_cnt_2),
        .data_out_2(data_out_2),
        .s_data(s_data),
        .s_valid(s_valid),
        .s_ready(s_ready),
        .s_last(s_last),
        .m_data(m_data),
        .m_valid(m_valid),
        .m_ready(m_ready),
        .m_last(m_last)
        
       );
 
   
// Clock Generation
 initial 
    begin
        clk = 0;
        forever #10 clk = ~clk;
    end
     
//reset
initial begin
      reset = 1'b1;
      #30;
      reset = 1'b0;
      
end

initial begin
   forever begin
       repeat(40)@(posedge clk)s_last = 1'b0;
       s_last =1'b1;
       @(posedge clk) s_last =1'b0;
   end
end


initial begin
     s_data = 0;
    // Assuming clk is defined and s_data is an output
    forever begin
        @(posedge clk);
        s_data = s_data + 2;
    end
end

     
initial begin
    r_en = 1'b0;
    repeat(4300)@(posedge clk) w_en = 1'b1;
    w_en =1'b0;
    r_en = 1'b1;
    /*repeat(2)@(posedge clk)begin
        w_en = 1'b1;
        r_en = 1'b0;end
    repeat(10)@(posedge clk)begin
        w_en = 1'b1;
        r_en = 1'b0;end
    repeat(5)@(posedge clk)begin
        w_en = 1'b1;
        r_en = 1'b0; end
    //@(posedge clk)r_en = 1'b1;
    repeat(2)@(posedge clk)begin
        w_en = 1'b1;
        r_en = 1'b0; end
    repeat(10)@(posedge clk) begin
        w_en = 1'b0;
        r_en = 1'b1;
    end
    repeat(5)@(posedge clk)begin
        w_en = 1'b0;
        r_en = 1'b1;end
    repeat(3)@(posedge clk)begin
        w_en = 1'b0;
        r_en = 1'b1;end
    repeat(5)@(posedge clk)begin
        w_en = 1'b1;
        r_en = 1'b0;end
    repeat(5)@(posedge clk)begin
        w_en = 1'b1;
        r_en = 1'b0;end
    repeat(15)@(posedge clk)
        w_en = 1'b1;
        r_en = 1'b0;*/
end

/*initial begin
    repeat(4)@(posedge clk) s_valid=1'b1; 
    repeat(5)@(posedge clk) s_valid=1'b0; 
    repeat(5)@(posedge clk) s_valid=1'b1;
    repeat(4)@(posedge clk) s_valid=1'b0; 
    repeat(4)@(posedge clk) s_valid=1'b1;
    repeat(4)@(posedge clk) s_valid=1'b1; 
    repeat(5)@(posedge clk) s_valid=1'b0; 
    repeat(5)@(posedge clk) s_valid=1'b1;
    repeat(4)@(posedge clk) s_valid=1'b0; 
    repeat(4)@(posedge clk) s_valid=1'b1;
end*/

initial begin
    s_valid = 1'b1;
end

initial begin
    //@(posedge clk) m_ready=1'b0;
    @(posedge clk) m_ready=1'b1;
    /*repeat(5)@(posedge clk) m_ready = 1'b1;
    repeat(2)@(posedge clk) m_ready = 1'b0;
    repeat(5)@(posedge clk) m_ready = 1'b1;
    repeat(3)@(posedge clk) m_ready = 1'b0;
    repeat(8)@(posedge clk) m_ready = 1'b1;
    repeat(2)@(posedge clk) m_ready = 1'b0; 
    repeat(8)@(posedge clk) m_ready = 1'b1;
    repeat(4)@(posedge clk) m_ready = 1'b0;
    repeat(6)@(posedge clk) m_ready = 1'b1;
    repeat(4)@(posedge clk) m_ready = 1'b0;
    repeat(4)@(posedge clk) m_ready = 1'b1;*/
end

endmodule
