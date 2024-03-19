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

reg last1,last2;      
always @(posedge clk) begin
    last1 <= s_last_1;
    last2 <= s_last_2;
end

always @(posedge clk) begin
    if (reset) begin
       m_data <= 8'h00;
       m_valid <= 1'b0;
    end
    else begin
        // If sel = 1, s_data_1 is the input
        // if sel = 0, s_data_2 is the input
        if (sel) begin
            if (s_valid_2 && m_ready) begin
                m_data <= s_data_2;
                m_valid <= 1'b1;
            end
            else begin
                m_data <= 8'h00;
                m_valid <= 1'b0;
            end
        end
        else begin
            if (s_valid_1 && m_ready) begin
                m_data <= s_data_1;
                m_valid <= 1'b1;
            end
            else begin
                m_data <= 8'h00;
                m_valid <= 1'b0;
            end
        end  
    end
end

always @(posedge clk) begin
        m_last <= reset? 0 :(sel ? last2 : last1);
        s_ready_1 <= sel ? 0 : m_ready;
        s_ready_2 <= sel ? m_ready : 0 ;
end

endmodule
