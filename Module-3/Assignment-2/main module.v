`timescale 1ns / 1ps

module packet_data #(
    parameter Data_width = 8,
    parameter Depth = 10)(

      input clk,
      input rst,

      input [Data_width-1   :0]   s_data,
      input s_valid,
      input s_last,
      output reg s_ready,
      input [Data_width-1:0]k,
      input [Data_width-1:0]len,
      //input [Data_width+Data_width-1 :0] packet_config,
      output reg [Data_width-1   :0]  m_data,
      output reg m_valid,
      output  m_last,
      input  m_ready,
      output reg full,
      output reg empty
    );

  reg [Data_width-1:0] mem_1 [Depth-1:0];
  reg [Data_width-1:0] mem_2 [Depth-1:0];
  reg [Data_width+2:0] mem_3 [Depth-1:0];
  reg [Data_width-1:0] wr_ptr=0;
  reg [Data_width-1:0] rd_ptr=0;
  reg [Data_width-1:0] wr_ptr2=6;
 
 


integer i;

assign m_last = s_last;
// Updating the storage with zeros
initial begin
 for(i = 0; i < Depth; i = i + 1)
  begin
    mem_1[i] = 0;
    mem_2[i] = 0;
    mem_3[i] = 0;
  end
end

// slave ready
always@(posedge clk)  begin
  if (rst)
    s_ready <=0;
  else
    s_ready <=1;
end

always@(posedge clk) begin
 if (rst) wr_ptr = -1;
 else if(s_valid && s_ready) begin
        mem_1[wr_ptr] = s_data;
        wr_ptr = wr_ptr +1;
        if(wr_ptr == Depth)begin
         wr_ptr = 0;
         full =1'b1;
        end
    if(full) begin
        mem_2[wr_ptr2] = s_data;
        wr_ptr2 = wr_ptr2 +1;
       if(wr_ptr2==Depth)begin
        wr_ptr2 =6;
        full =0;
        end
    end
end
end

always @(posedge clk) begin
    for (i = 0; i < Depth; i = i + 1) begin
      mem_3[i] <= mem_1[i] + mem_2[i];
    end
end

always @(posedge clk) begin
        m_data <= mem_3[rd_ptr];
        m_valid <= 1'b1;
        rd_ptr <= rd_ptr + 1;
        if (rd_ptr == Depth - 1) begin
            rd_ptr <= 0;
        end
end

 endmodule
