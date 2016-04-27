module FSM(x, clk, rst, z, state);
  input x, clk, rst;
  output z;
  output [2 : 0] state;
  reg [2 : 0] state;
  reg z;
  parameter init   = 3'b000, //000
            stateA = 3'b001, //001
            stateB = 3'b010, //010
            stateC = 3'b011, //011
            stateD = 3'b100, //100
            stateE = 3'b101; //101

  always @(posedge clk or negedge rst) begin
    // reset the state
    if(rst) begin
      state <= init;
      z = 0;
    end
    else begin
      z = 0;
      casex(state)
          init:
             if(x == 1) 
              state <= stateA; 
             else
              state <= init; 
          stateA:
             if(x == 0)
              state <= stateB; 
             else
              state <= stateA; // go to the stateA
          stateB:
             if(x == 1)
              state <= stateC;  
             else
              state <= init;
          stateC:
             if(x == 0)
              state <= stateD;  
             else
              state <= stateA; // go to the stateA
          stateD:
             if(x == 1)
              state <= stateE;  
             else
              state <= init; 
          stateE:
             if(x == 1) begin
              state <= stateA;  
              z = 1;           // get the right serial and output 1
             end
             else
              state <= stateB; // we have already have "10"
        default:
              state <= init;
      endcase
    end
  end
endmodule         