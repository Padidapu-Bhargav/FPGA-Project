`timescale 1ns / 1ps

///////////////
// MAC operation ( (a + b)*(c + d) )
///////////////

module MAC_add#(parameter Data_width=16)(
    // slave data A
    input [Data_width-1:0]a_data,
       
    //slave data B
    input [Data_width-1:0]b_data,
    
    //slave data C
    input [Data_width-1:0]c_data,
    
    //slave data D
    input [Data_width-1:0]d_data,
    
    //master 
    output reg [Data_width-1:0]m_data

    );
    
 always@(*)begin
   m_data <= ( (a_data + b_data )*( c_data + d_data) );
 end   
    
    
endmodule
