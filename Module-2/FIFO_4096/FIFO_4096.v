`timescale 1ns / 1ps

module FIFO_4096#(parameter data_width=32,
                  parameter Depth = 4096,
                  parameter Ptr_width=$clog2(Depth))( 
        //input [7:0] data_in,
        input clk,rst,w_en,r_en,
        output [data_width-1:0] data_out_2,
        output  full, empty,
        output [data_width-1:0]data_out_1,
        output  [Ptr_width+1:0]fifo_cnt_1,
        output  [Ptr_width+1:0]fifo_cnt_2,
        
        
    //slave
    input [data_width-1:0]s_data,
    input s_valid,
    output reg s_ready,
    input  s_last,
    
    
    //master
    output reg [data_width-1:0]m_data,
    output reg m_valid,
    input m_ready,
    output reg  m_last
             );
             
        //using AXI
        reg [data_width-1:0]data_in;
        reg f_w_en,f_r_en;
        
        wire ready;
        assign ready = m_ready;
        
        always@(posedge clk) begin
            s_ready <= ready;
        end
        reg valid;
       
        always@(posedge clk) begin
            
            if(rst) begin
                data_in <= 8'd0;
                valid <= 1'b0;
                m_last <= 1'b0;
            end
            else begin
                 if(s_valid && ready) begin
                    f_w_en <= w_en;
                    f_r_en <= r_en;
                    data_in <= s_data;
                    //m_valid <= s_valid;
                    //valid <= (r_en)?s_valid:0;
                    //m_last <= s_last;
                 end
                 else begin
                    f_w_en <= 1'b0;
                    f_r_en <= 1'b0;
                    //valid <= 1'b0;
                    //m_last <= 1'b0;
                 end
            end  
        end
           
             
             
wire f1,f2,e1,e2;
reg w1,w2,r1,r2;
reg OF,UF;

always@(posedge clk) begin
    m_valid = valid;
    if (rst) begin
        r1 <= 1'b0;
        w1 <= 1'b0;
        r2 <= 1'b0;
        w2 <= 1'b0;
    end 
    else begin
        r1 = (~e1 && f_r_en) ? 1'b1 : 1'b0;
        w1 = (~f1 && ~OF && f_w_en) ? 1'b1 : 1'b0;
        r2 = (e1 && ~e2 && f_r_en) ? 1'b1 : 1'b0 ;
        w2 = (OF && ~f2 && f_w_en) ? 1'b1 : 1'b0 ; 
    end
end


always@(*) begin
   if(f1) OF = 1'b1;
   else if(e1) OF = 1'b0;
end

FIFO_2048 FIFO_1( data_in, clk, rst, r1, w1, e1, f1,fifo_cnt_1, data_out_1);

FIFO_2048 FIFO_2(data_in, clk, rst, r2, w2 , e2, f2,fifo_cnt_2, data_out_2);

//full and empty conditions
reg full_1,empty_1;
always @(posedge clk,posedge rst) begin
    if (rst) begin
        full_1 <= 1'b0;
        empty_1 <= 1'b1;
    end else begin
        full_1 <= f1 && f2;
        empty_1 <= e1 && e2;
    end
end

assign full = full_1;
assign empty = empty_1;

//delaying the e1 signal by one clock cycle
reg e;
always@(posedge clk) begin
    e <=e1;
end

always@(*)begin
    if(valid && s_valid && ready)
        m_last <= s_last;
end

always@(*)begin
    if(r_en) begin
        if(e) m_data <= data_out_2;
        else m_data <= data_out_1;
        valid <= ~empty?(r_en?s_valid:0):0;
    end
end
endmodule


