`timescale 1ns / 1ps

// ( (a+b) * (c+d) )
// reg1 = a+b
// reg2 = b+c
// reg3 = reg1*reg2

module MAC_pipeline#(parameter DW = 8)(
    
    input clk,
    input reset,
    
    // signals and data for the input A
    input [DW-1:0]A_data,
    input A_valid,
    output A_ready,
    
    // signals and data for the input B
    input [DW-1:0]B_data,
    input B_valid,
    output B_ready,
    
    // signals and data for the input C
    input [DW-1:0]C_data,
    input C_valid,
    output C_ready,
    
    // signals and data for the input D
    input [DW-1:0]D_data,
    input D_valid,
    output D_ready,
    
    output [2*DW-1:0]m_data,
    output reg m_valid,
    input m_ready,
    
    output  OVERFLOW
    );
    
assign A_ready = reset ? 0 : m_ready;
assign B_ready = reset ? 0 : m_ready;
assign C_ready = reset ? 0 : m_ready;
assign D_ready = reset ? 0 : m_ready;

reg [DW:0] reg1,reg2;
reg [2*DW-1:0]reg3;
reg valid;
always@(posedge clk)begin
    if(reset)begin
        reg1 <= 'd0;
        reg2 <= 'd0;
        reg3 <= 'd0;
        //m_data <= 'd0;
        valid <= 1'd0;
    end
    else begin
        if(A_valid && B_valid && C_valid &&D_valid && A_ready && B_ready && C_ready && D_ready) begin
            reg1 <= A_data + B_data ;
            reg2 <= C_data + D_data;
            reg3 <= reg1*reg2;
            valid <= A_valid & B_valid & C_valid & D_valid;
        end
        else begin
            reg1 <= 'd0;
            reg2 <= 'd0;
            reg3 <= 'd0;
            valid <= 1'd0;
        end
    end
    m_valid <= valid;
end

assign m_data = reg3;
assign OVERFLOW = |reg3[2*DW-1:DW];
endmodule

