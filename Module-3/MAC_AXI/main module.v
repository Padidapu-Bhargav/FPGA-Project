`timescale 1ns / 1ps

/////////
// MAC operation ( a+b * c+d )
/////////

module MAC_AXI#(parameter Data_width=8)(
    input clk,
    input reset,
    // slave data A
    input [Data_width-1:0]A, // data
    input a_valid,
    output a_ready,
    
    //slave data B
    input [Data_width-1:0]B,
    input b_valid,
    output b_ready,
    
    //slave data C
    input [Data_width-1:0]C,
    input c_valid,
    output c_ready,
    
    //slave data D
    input [Data_width-1:0]D,
    input d_valid,
    output d_ready,
    
    //master 
    output [Data_width-1:0]m_data,
    output reg m_valid,
    input m_ready
    );
    
    // registers used for the pipelining
    reg [Data_width-1:0]A0='d0;
    reg [Data_width-1:0]B0='d0;
    reg [Data_width-1:0]C0='d0;
    reg [Data_width-1:0]D0='d0;
    reg [Data_width-1:0]out_0='d0;
    
    reg [Data_width-1:0]A1='d0;
    reg [Data_width-1:0]B1='d0;
    reg [Data_width-1:0]C1='d0;
    reg [Data_width-1:0]D1='d0;
    reg [Data_width-1:0]out_1='d0;
    
    reg valid_1;
    reg valid_2;
    reg valid_3;
    
    assign a_ready = a_valid & m_ready;
    assign b_ready = b_valid & m_ready;
    assign c_ready = c_valid & m_ready; 
    assign d_ready = d_valid & m_ready; 
    
    always@(posedge clk) begin
        if(reset)begin
            A0 <= 'd0;
            B0 <= 'd0;
            C0 <= 'd0;
            D0 <= 'd0;
            A1 <= 'd0;
            B1 <= 'd0;
            C1 <= 'd0;
            D1 <= 'd0;
            out_0 <= 'b0;
            out_1 <= 'b0;
            valid_1 <= 'b0;
            valid_2 <= 'b0;
            valid_3 <= 'b0;
            m_valid <= 'b0;
        end
        else if(a_valid && b_valid && c_valid && m_ready) begin
                               
                A0 <= A;
                B0 <= B;
                C0 <= C;
                D0 <= D;
                                
                A1 <= A0;
                B1 <= B0;
                C1 <= C0;
                D1 <= D0;
                
                out_0<= ( ($signed(A1)+ $signed(B1))*($signed(C1)+ $signed(D1)));      
                out_1 <= out_0;
                valid_1 <= a_valid & b_valid & c_valid & d_valid;        
                valid_2 <= valid_1;
                valid_3 <= valid_2;
                m_valid <= valid_3;
        end
        else begin 
                A0 <= 0;
                A1 <= 0;
        
                B0 <= 0;
                B1 <= 0;
                
                C0 <= 0;
                C1 <= 0;
                
                D0 <= 0;
                D1 <= 0;
                
                out_0 <= 0;
                out_1 <= 0;
        
                valid_1<=0;
                valid_2<=0;
                valid_3<=0;
                m_valid<=0;
        end
end

assign m_data = out_1;
    
endmodule
