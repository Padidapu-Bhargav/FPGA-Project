`timescale 1ns / 1ps
module FIFO_2048 (
input [7:0] data_in,
 input clk, rst, rd, wr,
output  empty,
output  full,
output reg [3:0]fifo_cnt,
output reg [7:0] data_out);


reg [7:0] fifo_ram [0:7];
reg [2:0] rd_ptr;
reg [2:0] wr_ptr;

always @(posedge clk) begin
    if (rst) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
       // empty <= 1;
       // full <=  0;
    end 
end


always @(posedge clk) begin: write
         if (wr && ~full)  begin
            fifo_ram [wr_ptr] <= data_in;
             wr_ptr <=  wr_ptr+1;
    end
end

always @ (posedge clk) begin: read
        if (rd && ~empty)
            begin
                data_out <= fifo_ram [rd_ptr];
                rd_ptr <=  rd_ptr+1 ;
            end
end

//counter
always @(posedge clk) begin: count
    if (rst) fifo_cnt <= 0;
    else begin
        case ({wr, rd})
            2'b00: fifo_cnt <= fifo_cnt;
            2'b01: fifo_cnt <= (fifo_cnt==0) ? 0: fifo_cnt-1;
            2'b10: fifo_cnt <= (fifo_cnt==8) ? 8: fifo_cnt+1;
            2'b11 : fifo_cnt <= fifo_cnt;
            default: fifo_cnt <= fifo_cnt;
        endcase
    end
end

assign empty = (fifo_cnt ==0)?1:0;
assign full = (fifo_cnt ==8)?1:0;

/*always@(posedge clk,posedge rst) begin
    empty <= (fifo_cnt == 0);
    full <= (fifo_cnt == 4);
end*/

endmodule



