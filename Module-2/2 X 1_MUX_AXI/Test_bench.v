
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
    rst = 1'b0;
    @(posedge clk) rst = 1'b1;
    @(posedge clk) rst = 1'b0;
end

initial begin
    repeat(25) @(posedge clk) sel = 1'b0;
    repeat(20) @(posedge clk) sel = 1'b1;
end  

// Data when the sel =0
initial begin
     s_data_1 = 8'h00 ;
     forever begin
         @(posedge clk)
         @(posedge clk) s_data_1 = $random;
     end
end 

// Data when the sel =1
initial begin
     s_data_2 = 8'h00 ;
     forever begin
         @(posedge clk)
         @(posedge clk) s_data_2 = $random;
     end
end 

initial begin
    @(posedge clk) m_ready=1'b0;
    @(posedge clk) m_ready=1'b1;
    repeat(2)@(posedge clk) m_ready = 1'b0; 
    repeat(5)@(posedge clk) m_ready = 1'b1;
    repeat(4)@(posedge clk) m_ready = 1'b0;
    repeat(4)@(posedge clk) m_ready = 1'b1;
    repeat(4)@(posedge clk) m_ready = 1'b0; 
    repeat(8)@(posedge clk) m_ready = 1'b1;
    repeat(4)@(posedge clk) m_ready = 1'b0;
    repeat(4)@(posedge clk) m_ready = 1'b1;
    repeat(4)@(posedge clk) m_ready = 1'b0;
    repeat(4)@(posedge clk) m_ready = 1'b1;
end

initial begin
    repeat(4)@(posedge clk) s_valid_1=1'b1; 
    repeat(5)@(posedge clk) s_valid_1=1'b1; 
    repeat(5)@(posedge clk) s_valid_1=1'b0;
    repeat(4)@(posedge clk) s_valid_1=1'b0; 
    repeat(4)@(posedge clk) s_valid_1=1'b1;
end

initial begin
    repeat(4)@(posedge clk) s_valid_2=1'b0; 
    repeat(5)@(posedge clk) s_valid_2=1'b1; 
    repeat(20)@(posedge clk) s_valid_2=1'b0;
    repeat(5)@(posedge clk) s_valid_2=1'b1;
    repeat(8)@(posedge clk) s_valid_2=1'b0;
    repeat(5)@(posedge clk) s_valid_2=1'b1;

end

initial begin
    repeat(23)@(posedge clk) s_last_1 = 1'b0; 
    @(posedge clk) s_last_1 = 1'b1;
    @(posedge clk) s_last_1 = 1'b0;   
end

initial begin
    repeat(47)@(posedge clk) s_last_2 = 1'b0; 
    @(posedge clk) s_last_2 = 1'b1;
    @(posedge clk) s_last_2 = 1'b0; 
    
end

endmodule
