module ALU(A,B,ALUFun,Sign,S);

     input [31:0] A;
     input [31:0] B;
     input [5:0] ALUFun;
     input Sign;
 
    output [31:0] S;

     wire Z,V,N;
     wire [31:0] S_1,S_2,S_3,S_4;

     ALU_add_sub      ALU_add_sub_v(Sign,A,B,ALUFun[0],S_1,Z,V,N);
     ALU_logic        ALU_logic_v(A,B,ALUFun[3:0],S_2);
     ALU_shift        ALU_shift_v(A,B,ALUFun[1:0],S_3);
     ALU_CMP          ALU_CMP(Z,V,N,ALUFun[3:1],S_4);

     ALU_big_four_path_mux b_m_v_v(S_1,S_2,S_3,S_4,ALUFun[5:4],S);
endmodule
  

