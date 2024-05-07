`timescale 1ns / 1ps

module MAC_pipeline_TB#(parameter DW=8)();

reg clk;
reg reset;
    
    // signals and data for the input A
reg [DW-1:0]A_data;
reg A_valid;
wire A_ready;
    
    // signals and data for the input B
reg [DW-1:0]B_data;
reg B_valid;
wire B_ready;
    
    // signals and data for the input C
reg [DW-1:0]C_data;
reg C_valid;
wire C_ready;

reg [DW-1:0]D_data;
reg D_valid;
wire D_ready;
    
wire [2*DW-1:0]m_data;
wire m_valid;
reg m_ready;
    
wire  OVERFLOW;

MAC_pipeline DUT(.clk(clk),.reset(reset),
                  .A_data(A_data),.A_valid(A_valid),.A_ready(A_ready),
                  .B_data(B_data),.B_valid(B_valid),.B_ready(B_ready),
                  .C_data(C_data),.C_valid(C_valid),.C_ready(C_ready),
                  .D_data(D_data),.D_valid(D_valid),.D_ready(D_ready),
                  .m_data(m_data),.m_valid(m_valid),.m_ready(m_ready),
                  .OVERFLOW(OVERFLOW) );
                  
// Clock Generation
 initial 
    begin
        clk = 0;
        forever #10 clk = ~clk;
    end
     
//reset
initial begin
      reset = 1'b1;
      #30;
      reset = 1'b0;
      
end
initial begin
     A_data = 0;
     repeat(4)@(posedge clk);
     A_data = 3;
    // Assuming clk is defined and s_data is an output
    repeat(10) begin
        repeat(3)@(posedge clk);
        A_data = A_data + 3;
    end
    A_data = 0;
end
initial begin
     B_data = 0;
     repeat(4)@(posedge clk);
     B_data = 2;
    // Assuming clk is defined and s_data is an output
    repeat(10) begin
        repeat(3)@(posedge clk);
        B_data = B_data + 2;
    end
    B_data = 0;
end
initial begin
     C_data = 0;
     repeat(4)@(posedge clk);
     C_data = 1;
    // Assuming clk is defined and s_data is an output
    repeat(10) begin
        repeat(3)@(posedge clk);
        C_data = C_data + 1;
    end
    C_data = 0;
end

initial begin
     D_data = 0;
     repeat(4)@(posedge clk);
     D_data = 2;
    // Assuming clk is defined and s_data is an output
    repeat(10) begin
        repeat(3)@(posedge clk);
        D_data = D_data + 2;
    end
    D_data = 0;
end
/*initial begin
    repeat(5)@(posedge clk) A_valid=1'b1; 
    repeat(5)@(posedge clk) A_valid=1'b0; 
    repeat(5)@(posedge clk) A_valid=1'b1;
    repeat(4)@(posedge clk) A_valid=1'b0; 
    repeat(4)@(posedge clk) A_valid=1'b1;
    repeat(4)@(posedge clk) A_valid=1'b1; 
    repeat(5)@(posedge clk) A_valid=1'b0; 
    repeat(5)@(posedge clk) A_valid=1'b1;
    repeat(4)@(posedge clk) A_valid=1'b0; 
    repeat(4)@(posedge clk) A_valid=1'b1;
end*/

initial begin
    A_valid = 1'b0;
    B_valid = 1'b0;
    C_valid = 1'b0;
    D_valid = 1'b0;
    repeat(4)@(posedge clk);
    A_valid = 1'b1;
    B_valid = 1'b1;
    C_valid = 1'b1;
    D_valid = 1'b1;
    repeat(30)@(posedge clk);
    A_valid = 1'b0;
    B_valid = 1'b0;
    C_valid = 1'b0;
    D_valid = 1'b0;
end

initial begin
    //@(posedge clk) m_ready=1'b0;
    @(posedge clk) m_ready=1'b1;
    /*repeat(5)@(posedge clk) m_ready = 1'b1;
    repeat(2)@(posedge clk) m_ready = 1'b0;
    repeat(5)@(posedge clk) m_ready = 1'b1;
    repeat(3)@(posedge clk) m_ready = 1'b0;
    repeat(8)@(posedge clk) m_ready = 1'b1;
    repeat(2)@(posedge clk) m_ready = 1'b0; 
    repeat(8)@(posedge clk) m_ready = 1'b1;
    repeat(4)@(posedge clk) m_ready = 1'b0;
    repeat(6)@(posedge clk) m_ready = 1'b1;
    repeat(4)@(posedge clk) m_ready = 1'b0;
    repeat(4)@(posedge clk) m_ready = 1'b1;*/
end
endmodule

