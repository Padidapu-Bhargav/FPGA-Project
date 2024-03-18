`timescale 1ns / 1ps

module AXI_8_bit(
    input clk,rst,
    
    //slave
    input [7:0]s_data,
    input s_valid,
    output reg s_ready,
    input  s_last,
    
    
    //master
    output  reg [7:0]m_data,
    output reg m_valid,
    input m_ready,
    output reg m_last
     );
reg [7:0]data;
reg valid;
reg ready;
reg last;


always@(posedge clk) begin
    last <= s_last;
end

always@(posedge clk) begin
    if(rst)begin
        valid <= 0;
        data <= 8'b0;
    end
    else if(s_valid && m_ready) begin
        data <= s_data;
        valid <= 1'b1;
     end
     else begin
        valid <= 1'b0;
        data <= 8'b0;
     end
     
end

always@(posedge clk) begin
    m_data <= data;
    m_valid <= valid;
     s_ready <= rst ? 0 : m_ready;
    m_last <= last;
end

endmodule
