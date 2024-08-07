


module FSM2(input clk,
            input arst,
            //slave
            input [15:0]s_data,
            input s_valid,
            input s_last,
            output  s_ready,
            input [7:0]s_keep,
            //master
            output  reg [15:0] m_data,
            output reg m_valid,
            output reg m_last,
            input  m_ready,
            output reg [7:0]m_keep,
            input [11:0]k,
            output reg last
            
                );
    
    
    reg [6:0]temp=0;
    reg [3:0]fifo[0:128];
    reg [6:0]wr_ptr,rd_ptr;
    
    reg [3:0]state,next_state;
    parameter s0=3'd0,s1=3'd1,s2=3'd2,s3=3'd3,s4=3'd4,idle=3'd5;
    
    reg rd_en = 0;
    reg  [7:0]count1= 'd0;
    
    always@(posedge clk) begin
        if(~arst) begin
            count1 <= 0;
            rd_en <=0;
        end
        else begin
            count1 <= count1 + 1;
            if(count1 == 10) rd_en <= 1;
        end
    end     
    
    assign s_ready = (~arst)?'d0:m_ready;
    

    
    integer i;
    always@(posedge clk) begin
        if(~arst) state<=idle;
        else state<=next_state;
    end
    
    always@(*) begin
        case(state)
            idle:begin
                   if(s_valid & s_ready) begin
                        if(s_keep==7'd0) next_state=s0;
                        else if(s_keep==7'd4) next_state=s1;
                        else if(s_keep==7'd8) next_state=s2;
                        else if(s_keep==7'd12) next_state=s3;
                        else if(s_keep==7'd16) next_state=s4;
                      end
                 end
            s0:begin
                  if(s_valid & s_ready) begin
                        if(s_keep==7'd0) next_state=s0;
                        else if(s_keep==7'd4) next_state=s1;
                        else if(s_keep==7'd8) next_state=s2;
                        else if(s_keep==7'd12) next_state=s3;
                        else if(s_keep==7'd16) next_state=s4;
                      end
                end
            s1:begin
                   if(s_valid & s_ready) begin
                        if(s_keep==7'd0) next_state=s0;
                        else if(s_keep==7'd4) next_state=s1;
                        else if(s_keep==7'd8) next_state=s2;
                        else if(s_keep==7'd12) next_state=s3;
                        else if(s_keep==7'd16) next_state=s4;
                      end
                end
            s2:begin
                 if(s_valid & s_ready) begin
                       if(s_keep==7'd0) next_state=s0;
                       else if(s_keep==7'd4) next_state=s1;
                       else if(s_keep==7'd8) next_state=s2;
                       else if(s_keep==7'd12) next_state=s3;
                       else if(s_keep==7'd16) next_state=s4;
                     end
                 end
             s3:begin
                if(s_valid & s_ready) begin
                        if(s_keep==7'd0) next_state=s0;
                        else if(s_keep==7'd4) next_state=s1;
                        else if(s_keep==7'd8) next_state=s2;
                        else if(s_keep==7'd12) next_state=s3;
                        else if(s_keep==7'd16) next_state=s4;
                     end 
                end      
            s4:begin
                if(s_valid & s_ready) begin
                        if(s_keep==7'd0) next_state=s0;
                        else if(s_keep==7'd4) next_state=s1;
                        else if(s_keep==7'd8) next_state=s2;
                        else if(s_keep==7'd12) next_state=s3;
                        else if(s_keep==7'd16) next_state=s4;
                      end
               end          
        endcase
    end
    
    
    always@(posedge clk) begin
        if(~arst) begin
            wr_ptr<='d0;
            
            for(i=0;i<=128;i=i+1)begin
                fifo[i] <= 4'd0;
            end
        end
        else begin
            
            case(next_state)
                s0:begin
                    wr_ptr<=wr_ptr + 0;
                   end
                s1:begin
                    if(s_valid & s_ready ) begin
                       fifo[wr_ptr]<=s_data[3:0];
                       wr_ptr<=wr_ptr+1;   
                    end
                   end
                s2:begin
                    if(s_valid & s_ready ) begin
                       fifo[wr_ptr]<=s_data[3:0];
                       fifo[wr_ptr+1]<=s_data[7:4];
                       wr_ptr<=wr_ptr+2;
                    end
                   end
                s3:begin
                    if(s_valid & s_ready ) begin
                       fifo[wr_ptr]<=s_data[3:0];
                       fifo[wr_ptr+1]<=s_data[7:4];
                       fifo[wr_ptr+2]<=s_data[12:8];
                       wr_ptr<=wr_ptr+3;
                    end 
                   end
                s4:begin 
                    if(s_valid & s_ready ) begin
                       fifo[wr_ptr]<=s_data[3:0];
                       fifo[wr_ptr+1]<=s_data[7:4];
                       fifo[wr_ptr+2]<=s_data[11:8];
                       fifo[wr_ptr+3]<=s_data[15:12];
                       wr_ptr<=wr_ptr+4;
                    end 
                end
        endcase
    end 
    
    end
 
 reg [11:0]count=0;  
 
       
always@(posedge clk) begin
        
        if(s_last==1) begin
                 temp <=wr_ptr+next_state;
        end
        
        if(~arst) begin
            rd_ptr<=0;
            temp <= 0;
            last <= 0;
            count <= 0;
            m_data <= 0;
            m_valid <= 0;
            m_keep <= 0;
            m_last <= 0;
        end
        
        else if(rd_en && m_ready) begin
                if(temp == rd_ptr+4)
                   begin                   
                       m_data <= {{fifo[rd_ptr+3],{fifo[rd_ptr+2]},{fifo[rd_ptr+1]},{fifo[rd_ptr]}}};
                       rd_ptr <=rd_ptr+4;
                       m_keep <=8'd16;
                       m_valid <=1;
                       m_last <=1;
                       last <= 0;
                       count <= 'd0;
                   end
               else begin
                 if(temp==rd_ptr+1)
                    begin
                        m_data<={{4'b0},{4'b0},{4'b0},{fifo[rd_ptr]}};
                        rd_ptr<=rd_ptr+1;
                        m_keep <=8'd4;
                        m_valid <=1;
                        m_last <=1;
                        last <= 0;  
                        count <= 'd0;   
                    end
                 else if(temp==rd_ptr+2)
                   begin
                       m_data<={{4'b0},{4'b0},{fifo[rd_ptr+1]},{fifo[rd_ptr]}};
                       rd_ptr<=rd_ptr+2;
                       m_keep<=8'd8;
                       m_valid<=1;
                       m_last <=1; 
                       last <= 0;
                       count <= 'd0; 
                  end
                else if(temp==rd_ptr+3)
                   begin          
                      m_data<={{4'b0},{fifo[rd_ptr+2]},{fifo[rd_ptr+1]},{fifo[rd_ptr]}};
                      rd_ptr<=rd_ptr+3;
                      m_keep<=8'd12;
                      m_valid<=1;
                      m_last<=1;
                      last <= 0;
                      count <= 'd0; 
                   end 
         
                else begin                  
                       if(count+4==k )
                       begin
                          m_data<={{4'b0},{4'b0},{4'b0},{fifo[rd_ptr]}};
                          rd_ptr<=rd_ptr+1;
                          m_keep<=7'd4;
                          m_valid<=1;
                          count<=0;
                          last<=1; 
                       end
                       else if(count+8==k)
                          begin
                            m_data<={{4'b0},{4'b0},{fifo[rd_ptr+1]},{fifo[rd_ptr]}};
                            rd_ptr<=rd_ptr+2;
                            m_keep<=7'd8;
                            m_valid<=1;
                            count<=0;
                            last<=1; 
                          end
                       else if(count+12==k )
                          begin
                            m_data<={{4'b0},{fifo[rd_ptr+2]},{fifo[rd_ptr+1]},{fifo[rd_ptr]}};
                            rd_ptr<=rd_ptr+3;
                            m_keep<=7'd12;
                            m_valid<=1;
                            count<=0;
                            last<=1; 
                          end
                       else if(count<k)
                          begin
                            m_data<={{fifo[rd_ptr+3],{fifo[rd_ptr+2]},{fifo[rd_ptr+1]},{fifo[rd_ptr]}}};
                            rd_ptr<=rd_ptr+4;
                            m_keep <=7'd16;
                            m_valid <=1;
                            m_last <=0;
                            count <=count+16;
                            last <= 0;
                          end
                end
               end
               
                       
       
        end
        else
            begin
                m_data<=0;
                m_valid<=0;
                m_last<=0;
                m_keep<=0;
            end
end


endmodule
