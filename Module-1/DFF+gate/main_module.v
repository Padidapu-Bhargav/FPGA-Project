module D_G (
    input clk,
    input in, 
    output reg out);
    
    always @(posedge clk) begin
        //out =0;
        out <= out ^ in;
    end
    
endmodule
