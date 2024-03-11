`timescale 1ns / 1ps


`timescale 1ns / 1ps


module TB();
reg clk;
reg rst;
reg sel;
    
//slave-1
reg [7:0]s_data_1;
reg s_valid_1;
wire s_ready_1;
reg s_last_1;
        
//slave -2
reg [7:0]s_data_2;
reg s_valid_2;
wire s_ready_2;
reg s_last_2;
        
 //master
wire [7:0]m_data;
wire m_valid;
reg m_ready;
wire m_last;

Mux_2_1 sample(.clk(clk),.reset(rst),.sel(sel),
               .s_data_1(s_data_1),
               .s_valid_1(s_valid_1),
               .s_ready_1(s_ready_1),
               .s_last_1(s_last_1),
               .s_data_2(s_data_2),
               .s_valid_2(s_valid_2),
               .s_ready_2(s_ready_2),
               .s_last_2(s_last_2),
               .m_data(m_data),
               .m_ready(m_ready),
               .m_valid(m_valid),
               .m_last(m_last) );

initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

initial begin
    rst = 0;
    #20 rst = 1;
    #30 rst = 0;
end

initial begin
    s_last_1 = 1'b0;
    
    s_last_2 = 1'b0;
end

initial begin
     s_data_1 = 8'h23 ;// $random;
end 

initial begin
    s_data_2 = 8'h45;//$random;
end 

initial begin
    m_ready =1;
  //  forever #50 m_ready = ~m_ready;
end

initial begin
    s_valid_1=0; //m_ready=0;
     forever #120 s_valid_1 = ~s_valid_1;
end



initial begin
    s_valid_2=0;// m_ready=0;
     forever #140 s_valid_2 = ~s_valid_2;

end


initial begin
    sel =0;
    forever #100 sel = ~sel;
end  

initial
begin

s_last_1  = 0;
#230 s_last_1 = 1;
#10 s_last_1 =0;
#230 s_last_1 = 1;
#10 s_last_1= 0;
#210 s_last_1 = 1;
#10 s_last_1 = 0;
#190 s_last_1 =1;
#10 s_last_1 = 0;       
end
 
 
initial begin
s_last_2  = 0;
#190 s_last_2 = 1;
#10 s_last_2 = 0;
#350 s_last_2 = 1;
#10 s_last_2 =0;
#230 s_last_2 =1;
#10 s_last_2 = 0;        
end
endmodule
