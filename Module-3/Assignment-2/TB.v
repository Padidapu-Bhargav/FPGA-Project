`timescale 1ns / 1ps

module packet_data_tb;

  // Parameters
  parameter  Data_width = 8;
  parameter   Depth = 10;


  //Ports
  reg  clk=1;
  reg  rst=1;
  reg [Data_width-1   :0] s_data='d0;
  reg  s_valid=0;
  reg  s_last=0;
  wire  s_ready;
  wire [Data_width-1   :0] m_data;
  wire  m_valid;
  wire m_last;
  reg  m_ready=0;
//  logic full,empty;

  reg [Data_width-1:0] len=16;
  reg [Data_width-1:0] k=4;
  //reg [Data_width+Data_width-1:0] packet_config={k,len};

  packet_data DUT (
              .clk(clk),
              .rst(rst),
              .s_data(s_data),
              .s_valid(s_valid),
              .s_last(s_last),
              .s_ready(s_ready),
              .m_data(m_data),
              .m_valid(m_valid),
              .m_last(m_last),
              .m_ready(m_ready),
              .k(k),.len(len)
              //.packet_config(packet_config)
            );
 
  initial begin
    clk = 0;
    forever #20 clk = ~clk;
end

initial   begin
    rst = 1;
    #20 rst = 0;
end

integer i;
always@(posedge clk) begin
   i=0;
   s_last =0;
   if( i==10) begin
       s_last =1'b1;
       i=0;
   end
   else begin
       i = i+1;
       s_last = 1'b0;
   end
end
initial begin
    s_data = 0;
    repeat(2)@(posedge clk);
    forever @(posedge clk) s_data = s_data +2;
end

initial begin
s_valid = 1;
m_ready =1;
end
endmodule



