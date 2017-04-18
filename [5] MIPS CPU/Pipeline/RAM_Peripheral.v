module RAM_Peripheral(xx,      clk_hehe,  clk,      reset,  read, write,
                       address, writedata, readdata, irqout, TX,   RX,
                       digi,    led,       switch);

      input xx;
      input clk_hehe;
      input clk;
      input reset;
      input read;
      input write;
      input [31:0] address;
      input [31:0] writedata;
      input RX;
      input [7:0] switch;
      output reg [31:0] readdata;
      output irqout;
      output reg TX;
      output reg [11:0] digi;
      output reg [7:0] led;
      reg [4:0] UART_CON;

      reg [7:0] UART_TXD;
      reg [7:0] UART_RXD;
      reg [3:0] cnt_1;
      reg [3:0] cnt_2;
      reg [3:0] num_1;
      reg [3:0] num_2;
      reg [7:0] temp_1;
      reg [7:0] temp_2;
      reg [31:0] TH;
      reg [31:0] TL;
      reg [2:0] TCON;
      reg new;
      reg sender;
      reg flg;

      assign irqout = TCON[2];

      always @(*) begin
        if(read == 1) begin 
          case(address)
            32'h40000000:readdata <= TH;
            32'h40000004:readdata <= TL;
            32'h40000008:readdata <= {29'b0, TCON};
            32'h4000000C:readdata <= {24'b0, led};
            32'h40000010:readdata <= {24'b0, switch};
            32'h40000014:readdata <= {20'b0, digi};
            32'h40000018:readdata <= {24'b0, UART_TXD};
            32'h4000001C:readdata <= {24'b0, UART_RXD};
            32'h40000020:readdata <= {27'b0, UART_CON}; 
            default:readdata      <= 32'b0;
          endcase
        end
        else begin
          readdata = 32'b0;
        end
      end

      always @(negedge reset or posedge clk) begin
        if(~reset) begin
          TH <= 32'b0;
          TL <= 32'b0;
          TCON <= 3'b0;
          sender<=0;
          UART_CON <= 5'b00100;
          flg <= 0;
        end
        else begin
        if(write == 1) begin
          case(address)
            32'h40000000:TH       <= writedata;
            32'h40000004:TL       <= writedata;
            32'h40000008:TCON     <= writedata [2:0];
            32'h4000000C:led      <= writedata [7:0];
            32'h40000014:digi     <= writedata [11:0];
            32'h40000018:UART_TXD <= writedata [7:0];
            32'h40000020:UART_CON <= writedata [4:0]; 
            default:;
          endcase
        end 

        if(TCON[0] == 1) begin
          if(TL == 32'hffffffff) begin
            TL <= TH;
            if((TCON[1] & ~xx) == 1) 
              TCON[2] <= 1'b1;
            end
            else begin
              if(TCON[2] == 1)
                TCON[2] <= 0;
                TL <= TL + 1;
            end
          end

          if(read && address == 32'h4000001C) begin
            flg <= 1;
            UART_CON[3] <= 0;
          end
          else if(num_1 > 8 && ~flg) begin
            UART_CON[3] <= 1;
            UART_RXD <= temp_1;
          end
          else if(num_1 == 0) begin
            flg <= 0;
          end
          if(write && address == 32'h40000018) begin
            UART_CON[2] <= 0;
            UART_CON[4] <= 1;
            sender <= 1;
          end
          else if(sender == 1) begin
            sender <= 0;
          end
          else if(num_2 == 10) begin
            UART_CON[2] <= 1;
            UART_CON[4] <= 0;
          end
        end
      end 

      always @(negedge reset or posedge clk_hehe)
        begin
          if(~reset) begin
              temp_1 <= 8'b1111_1111;
              cnt_1 <= 0;
              num_1 <= 0;
              new<=0;
          end
        else begin
            if(~new) begin
                if(~RX) begin
                  cnt_1<=0;
                  num_1<=0;
                  new<=1;
                end
            end
        else begin
            if(num_1==4'b0000) begin
              if(cnt_1==7) begin
                cnt_1<=0;
                num_1<=1;
              end
              else 
                cnt_1<=cnt_1+1;
            end
            else begin
              if(cnt_1==15) begin
                if(num_1<=8) begin
                  temp_1[0]<=temp_1[1];
                  temp_1[1]<=temp_1[2];
                  temp_1[2]<=temp_1[3];
                  temp_1[3]<=temp_1[4];
                  temp_1[4]<=temp_1[5];
                  temp_1[5]<=temp_1[6];
                  temp_1[6]<=temp_1[7];
                  temp_1[7]<=RX;
                  cnt_1<=0;
                  num_1<=num_1+1;
                end
                else
                  new<=0;
              end
              else  begin
                        cnt_1<=cnt_1+1;
                      end
                  end
              end
          end
      end

      always @(negedge reset or posedge clk_hehe or posedge sender) begin
          if(~reset) begin
              temp_2 <= 8'b1111_1111;
               cnt_2 <= 0;
               num_2 <= 0;
          end
          else begin
              if(sender == 1) begin
                   cnt_2  <= 0;
                   num_2  <= 0;
                   temp_2 <= UART_TXD;
                   TX     <= 0;
                end
              else begin
                  if(~UART_CON[2]) begin
                      if(cnt_2==15) begin                                    
                          TX<=temp_2[0];
                          temp_2[0]<=temp_2[1];
                          temp_2[1]<=temp_2[2];
                          temp_2[2]<=temp_2[3];
                          temp_2[3]<=temp_2[4];
                          temp_2[4]<=temp_2[5];
                          temp_2[5]<=temp_2[6];
                          temp_2[6]<=temp_2[7];
                          temp_2[7]<=1;
                              num_2<=num_2+1;
                              cnt_2<=0;
                        end
                      else
                        begin
                          cnt_2<=cnt_2+1;
                        end
                    end                         
                end
            end
        end
endmodule
