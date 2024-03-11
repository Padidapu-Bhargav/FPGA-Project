`timescale 1ns / 1ps

module FIFO_4096( 
        input [7:0] data_in,
        input clk,rst,w_en,r_en,
        output [7:0] final_data,
        output reg full, empty,
        output  [3:0]fifo_cnt_1,
        output  [3:0]fifo_cnt_2
             );
             
wire f1,f2,e1,e2;
reg w1,w2,r1,r2;
wire [7:0]data_out_1;

    // for FIFO1
always @(posedge clk) begin
    if (rst) begin
        r1 <= 1'b0;
        w1 <= 1'b0;
        r2 <= 1'b0;
        w2 <= 1'b0;
        
    
    end else begin
            if(e1 && e2 ) w1 <= w_en;
            else if((~e1 || ~f1)&& e2) begin
                 r1 <= r_en;
                 w1 <= w_en;     
            end
            else if(f1 && e2 ) begin
                r1 <=  r_en;
                w1 <= 1'b0;
            end
        end   
end
    
    // for FIFO 2
always @(posedge clk) begin
    if (rst) begin
        r1 <= 1'b0;
        w1 <= 1'b0;
        r2 <= 1'b0;
        w2 <= 1'b0;
    end else begin
            if(f1 &&e2) w2 <= w_en;     
            else if(f1 && ( ~e2 || ~f2)) begin
                r2 <=  r_en;
                w2 <=  w_en;
            end else if(f1 && f2) begin
                r2 <= r_en;
                w2 <= 1'b0;
            end
        end   
end

FIFO_2048 FIFO_1( data_in, clk, rst, r1, w1, e1, f1,fifo_cnt_1, data_out_1);


FIFO_2048 FIFO_2(data_out_1, clk, rst, r2, w2 , e2, f2,fifo_cnt_2, final_data);

always @(posedge clk,posedge rst) begin
    if (rst) begin
        full <= 1'b0;
        empty <= 1'b1;
    end else begin
        full <= f1 && f2;
        empty <= e1 && e2;
    end
end
endmodule


