`timescale 1ns / 1ps

/////////
// MAC operation ( a*c + b*c )
/////////

module MAC#(parameter Data_width=8)(
    // slave data a
    input [Data_width-1:0]a_data, 
    
    //slave data b
    input [Data_width-1:0]b_data,
    
    //slave data c
    input [Data_width-1:0]c_data,
    
    //master 
    output reg [Data_width-1:0]m_data
    );
    
 always@(*)begin
   m_data <= (a_data*c_data + b_data*c_data);
 end   
   
endmodule
