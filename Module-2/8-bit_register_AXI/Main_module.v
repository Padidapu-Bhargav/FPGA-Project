`timescale 1ns / 1ps

module AXI_8_bit_register(
    input clk,rst,
    
    //master
    input [7:0]data_in,
    input m_valid,
    output reg m_ready,
    output reg  m_last,
    
    //slave
    output reg [7:0]s_data,
    output reg s_valid,
    input s_ready,
    output reg s_last
     );
reg [7:0]hold_data;
reg valid;   
always@(clk)begin
    valid<=m_valid;
end

always@(posedge clk) begin
    s_valid <= m_valid;
    m_ready <= s_ready;
end


always@(posedge clk) begin
    if(rst) begin
        s_data <= 8'h00;
    end
    else begin
        s_valid <= m_valid;
        m_ready <= s_ready;
        if(m_valid && s_ready) begin
            s_data <= data_in;
        end
        else begin
             s_data <= s_data;
            end 
       
    end
end

always@(clk) begin
    if({valid,m_valid}==2'b10)begin
     m_last <= 1'b1 ;
     s_last <= 1'b1 ;
     end
    else begin
    m_last <= 1'b0 ;
    s_last <= 1'b0 ;
    end
end

endmodule
