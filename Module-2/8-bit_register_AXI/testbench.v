`timescale 1ns / 1ps


module TB();
reg clk,rst;
    
//slave
reg [7:0]s_data;
reg s_valid;
wire s_ready;
reg s_last;

    
//master
wire [7:0]m_data;
wire m_valid;
reg m_ready;
wire m_last;


AXI_8_bit sample(.clk(clk), .rst(rst),
                          .s_data(s_data),
                          .s_valid(s_valid),
                          .s_ready(s_ready),
                          .s_last(s_last),
                          .m_data(m_data),
                          .m_valid(m_valid),
                          .m_ready(m_ready),
                          .m_last(m_last)       );


initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

initial begin
    rst = 1;
    #20 rst = 0;
end

initial begin

    s_data = 0;
    s_valid = 0;
    s_last = 0;
    repeat(2) @(posedge clk);
    
    //1st frame
    repeat (7) begin
      @(posedge clk);
      s_valid = 1;
      s_data = $random;  
    end
    @(posedge clk) s_last = 1;  
    s_data = $random; 
    @(posedge clk)s_data = 0;
    s_valid = 0; 
    s_last = 0;
    
    // 3 clock pulse difference between frame
    repeat(3) @(posedge clk); 
    // 2nd frame
    s_valid = 0;
    s_last = 0;
    repeat (7) begin
      @(posedge clk);
      s_valid = 1;
      s_data = $random;   
    end
    @(posedge clk) s_last = 1;  
    s_data = $random; 
    @(posedge clk)s_data = 0;
    s_valid = 0; 
    s_last = 0;
    
    //3 clock pulse difference between frames
    repeat(3) @(posedge clk); 
    // 3rd frame
    s_valid = 0;
    s_last = 0;
      
    repeat (7) begin
      @(posedge clk);
      s_valid = 0;
      s_data = $random;   
    end
    @(posedge clk) s_last = 1;  
    s_data = $random; 
    @(posedge clk)s_data = 0;
    s_valid = 0; 
    s_last = 0;
    
    // 3 clock pulse delay
    repeat(3) @(posedge clk); 
    // 4th frame
     @(posedge clk)  s_valid =0;
      s_data = $random;
     @(posedge clk)  s_valid =0;
      s_data = $random;
     @(posedge clk)  s_valid =0;
      s_data = $random;
     @(posedge clk)  s_valid =0;
      s_data = $random;
      
    repeat (6) begin
      @(posedge clk);
      s_valid = 1;
      s_data = $random;  
    end
    
    @(posedge clk) s_last = 1;  
    s_data = $random;
    @(posedge clk)s_data = 0;
    s_valid = 0; 
    s_last = 0;
    
              
end

initial begin
    repeat(11) @(posedge clk) m_ready = 1'b1;  // Master is always ready to receive data
    repeat(15) @(posedge clk) m_ready = 1'b0;
    repeat(9) @(posedge clk) m_ready = 1'b1;
    repeat(3) @(posedge clk) m_ready = 1'b0;
    repeat(2)@(posedge clk) m_ready = 1'b0;
    repeat(2) @(posedge clk) m_ready = 1'b1;
    repeat(2) @(posedge clk) m_ready = 1'b1;
    repeat(2) @(posedge clk) m_ready = 1'b0;
    @(posedge clk) m_ready = 1'b1;
    
end


endmodule
