`timescale 1ns / 1ps

module AXI_8_bit(
    input clk, // clock signal
    input rst, // reset signal
    
    //slave
    input [7:0]s_data,
    input s_valid,
    output reg s_ready,
    input  s_last,
    
    
    //master
    output  reg [7:0]m_data,
    output  reg m_valid,
    input m_ready,
    output  reg m_last
     );
     
reg [7:0]data;
reg valid;
reg ready;
reg last;



always@(posedge clk) begin
    if(rst)begin
        valid <= 1'b0;
        data <= 8'b0;
        last <= 1'b0;
    end
    else if(s_valid && s_ready) begin
        data <= s_data;
        valid <= 1'b1;
        last <= s_last;
     end
     else begin
        valid <= 1'b0;
        last <= 1'b0;
     end
     
end

integer cnt;

always@(posedge clk) begin
    if(rst) begin
        ready <= 1'b0;
        cnt <= 1'b0;
    end
    else begin
        if(cnt <= 2)begin
            s_ready <= 1'b1;
            cnt <= cnt + 1'b1; 
        end
        else if( cnt <= 4 ) begin
            s_ready <= 1'b0;
            cnt <= cnt + 1'b1;
        end 
        else cnt <= 1'b0;
    end
end

always@(posedge clk) begin
    m_data <= data;
    m_valid<= valid;
    m_last <= last;
end

endmodule
