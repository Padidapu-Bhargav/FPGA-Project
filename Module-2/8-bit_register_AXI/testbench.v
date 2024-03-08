`timescale 1ns / 1ps


module TB();
reg clk,rst;
    
//master
reg [7:0]data_in;
reg m_valid;
wire m_ready;
reg m_last;
    
//slave
wire [7:0]s_data;
wire s_valid;
reg s_ready;
wire s_last;


AXI_8_bit sample(.clk(clk), .rst(rst),
                          .data_in(data_in),
                          .m_valid(m_valid),
                          .m_ready(m_ready),
                          .m_last(m_last),
                          .s_data(s_data),
                          .s_valid(s_valid),
                          .s_ready(s_ready),
                          .s_last(s_last)       );


initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

initial begin
    rst = 0;
    #10 rst = 1;
    #10 rst = 0;
end

initial begin
    m_last =0;
    #190 m_last = 1 ;
    #20 m_last =0;
    #380 m_last =1;
    #20 m_last = 0;
    #280 m_last =1;
    #20 m_last = 0;
end


initial begin
    data_in =0;
    repeat(100) #50 data_in = $random;
end   

initial begin
    m_valid=0; s_ready=0;
    #110 m_valid=1; s_ready=1;
    #100 m_valid=1; s_ready=0;
    #100 m_valid=0; s_ready=1;
    #100 m_valid=1; s_ready=0;
    #100 m_valid=1; s_ready=1;
    #100 m_valid=0; s_ready=1;
    #100 m_valid=1; s_ready=0;
    #100 m_valid=1; s_ready=1;
    #100 m_valid=0; s_ready=1;
end

endmodule
