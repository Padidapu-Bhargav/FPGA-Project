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
reg ready;
reg valid;

integer cnt;

always@(posedge clk) begin
    if(reset) begin
        ready <= 1'b0;
        cnt <= 1'b0;
    end
    //else ready <= 1'b1 ;
    else begin
        if(cnt <= 3)begin
            ready <= 1'b1;
           cnt <= cnt + 1'b1; 
        end
        else if( cnt <= 5 ) begin
            ready <= 1'b0;
            cnt <= cnt + 1'b1;
        end 
        else cnt <= 1'b0;
    end
end

always @(posedge clk) begin
    if (reset) begin
       data <= 8'h00;
       valid <= 1'b0;
       last <= 1'b0;
    end
    else begin
        // If sel = 1, s_data_1 is the input
        // if sel = 0, s_data_2 is the input
        if (sel) begin
            if (s_valid_2 && ready) begin
                data <= s_data_2;
                valid <= s_valid_2;
                last  <= s_last_2;
            end
            else begin
                valid <= 1'b0;
                last <= 1'b0;
            end
        end
        else begin
            if (s_valid_1 && ready) begin
                data <= s_data_1;
                valid <= s_valid_1;
                last <= s_last_1;
            end
            else begin
                valid<= 1'b0;
                last <= 1'b0;
            end
        end  
    end
end

always @(posedge clk) begin
    m_data <= data;
    m_valid <= valid;
    m_last <= last;
    s_ready_1 <= sel ? 0 : ready ;
    s_ready_2 <= sel ? ready : 0 ;
end

endmodule
