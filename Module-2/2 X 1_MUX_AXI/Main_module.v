`timescale 1ns / 1ps

module Mux_2_1(
    input clk, reset, sel,
    
    // Slave-1
    input [7:0] s_data_1,
    input s_valid_1,
    output reg s_ready_1,
    input s_last_1,
    
    // Slave -2
    input [7:0] s_data_2,
    input s_valid_2,
    output reg s_ready_2,
    input s_last_2,
 
    // Master
    output reg [7:0] m_data,
    input m_ready,
    output reg m_valid,
    output reg m_last
    );        

always @(posedge clk) begin
    if (reset) begin
       m_data <= 8'h00;
    end
    else begin
        // If sel = 1, s_data_1 is the input
        // if sel = 0, s_data_2 is the input
        if (~sel) begin
            if (s_valid_1 && m_ready) begin
                m_data <= s_data_1;
            end
            else begin
                m_data <= m_data;
            end
        end
        else begin
            if (s_valid_2 && m_ready) begin
                m_data <= s_data_2;
            end
            else begin
                m_data <= m_data;
            end
        end  
    end
end

always @(posedge clk) begin
        m_valid <= ~sel ? s_valid_1 : s_valid_2;
        m_last <= ~sel ? s_last_1 : s_last_2;
        s_ready_1 <= ~sel ? m_ready : 0;
        s_ready_2 <= ~sel ? 0 : m_ready;
end

endmodule
