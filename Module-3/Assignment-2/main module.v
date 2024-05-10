`timescale 1ns / 1ps

module packet_data #(
    parameter Data_width = 8,
    parameter Depth = 15)(

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
      output reg m_last,
      input  m_ready,
      output  full,
      output  empty
    );
integer i;
  reg [Data_width-1:0] mem_1 [Depth-1:0];
  reg [Data_width-1:0] mem_2 [Depth-1:0];
  reg  mem_3 [Depth-1:0];
  reg  store_last [Depth-1:0];
  reg [Data_width-1:0] wr_ptr1;
  reg [Data_width-1:0] rd_ptr;
  reg [Data_width-1:0] wr_ptr2;

//assign wr_ptr2 = len -k;

//always@(*) m_last = s_last;
// Updating the storage with zeros
initial begin
 for(i = 0; i < Depth; i = i + 1)
  begin
    mem_1[i] = 0;
    mem_2[i] = 0;
    mem_3[i] = 0;
    store_last[i] = 0;
  end
end

// slave ready
always@(posedge clk)  begin
  if (rst)  s_ready <=0;
  else s_ready <=1;
end

assign full = wr_ptr1==Depth?1:0;
assign empty = wr_ptr1==0?1:0;

// for mem_1
always@(posedge clk)begin
    if (rst)begin
        wr_ptr1 <= 0;
        wr_ptr2 <= 0;
    end 
    else if( s_valid && s_ready) begin
        mem_1[wr_ptr1] <= s_data;
        mem_3[wr_ptr1] <= s_last;
        if(wr_ptr1 == len-1)begin
            wr_ptr1 <= 0;
            wr_ptr2 <= len-k; 
           // m_valid <= 1;   
        end
        else wr_ptr1 <= wr_ptr1 + 1;
        if(wr_ptr2 != 0) begin
            mem_2[wr_ptr2] <= s_data;
            store_last[wr_ptr2] <= s_data == 0 ? 1'b0 : 1'b1;
            if(wr_ptr2 == len-1)begin
                wr_ptr2 <= 0;
               // m_valid <= 0;  
            end
            else begin
                wr_ptr2 <= wr_ptr2 + 1;
                //m_valid <= 1;
            end
        end
        
    end
end

always@(posedge clk) begin
    if(rst) begin
        rd_ptr <= 0;
        m_valid <= 0;
        m_last <= 0;
        m_data <= 0;
    end
    else if( m_ready)begin
        m_valid = store_last[rd_ptr];
        m_last <= m_valid ? mem_3[rd_ptr]:0;
        m_data <= mem_1[rd_ptr] + mem_2[rd_ptr];
        rd_ptr <= rd_ptr == len-1 ? 0 : rd_ptr +1;
    end
    else begin
        m_valid = 0;
        m_last = 0;
        m_data = 0;
    end
end


 endmodule
