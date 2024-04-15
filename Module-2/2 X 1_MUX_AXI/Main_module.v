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
    
reg [7:0]data;
reg last;
wire ready;
reg valid;

integer cnt;

assign ready = m_ready;

always @(posedge clk) begin
    if (reset) begin
       m_data <= 8'h00;
       valid <= 1'b0;
       last <= 1'b0;
    end
    else begin
        // If sel = 1, s_data_1 is the input
        // if sel = 0, s_data_2 is the input
        if (sel) begin
            if (s_valid_2 && ready) begin
                m_data <= s_data_2;
                m_valid <= s_valid_2;
                m_last  <= s_last_2;
            end
            else begin
                m_valid <= 1'b0;
                m_last <= 1'b0;
            end
        end
        else begin
            if (s_valid_1 && ready) begin
                m_data <= s_data_1;
                m_valid <= s_valid_1;
                m_last <= s_last_1;
            end
            else begin
                m_valid<= 1'b0;
                m_last <= 1'b0;
            end
        end  
    end
end


always @(posedge clk) begin
    s_ready_1 <= sel ? 0 : ready ;
    s_ready_2 <= sel ? ready : 0 ;
end

endmodule
