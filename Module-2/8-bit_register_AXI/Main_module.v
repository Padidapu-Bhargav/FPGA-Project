`timescale 1ns / 1ps

module AXI_8_bit(
    input clk,rst,
    
    //master
    input [7:0]data_in,
    input m_valid,
    output reg m_ready,
    input  m_last,
    
    //slave
    output reg [7:0]s_data,
    output reg s_valid,
    input s_ready,
    output reg s_last
     );
reg [7:0]hold_data;


always@(posedge clk) begin
    s_valid <= m_valid;
    m_ready <= s_ready;
    s_last <= m_last;
end


always@(posedge clk) begin
    if(rst) begin
        hold_data <= 8'h00;
    end
    else begin
        if(m_valid && s_ready) begin
            hold_data <= data_in;
        end
        else begin
             hold_data <= hold_data;
        end 
    end
end

always@(posedge clk) begin
    if(rst) begin
        s_data <= 8'h00;
    end
    else begin
        if(s_valid && m_ready) begin
            s_data <= hold_data;
        end
        else begin
             s_data <= s_data;
        end 
    end
end


endmodule
