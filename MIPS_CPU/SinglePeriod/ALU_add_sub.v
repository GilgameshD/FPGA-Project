module ALU_add_sub(Sign,a,b,fun,out,Z,V,N);

     input Sign;
     input [31:0] a;
     input [31:0] b;
     input fun;

    output [31:0] out;
    output Z;
    output V;
    output N;

     wire [31:0] s_1;
     wire [31:0] s_2;

     wire V_1,V_2,V_3,V_4;
     wire Z_1,Z_2,Z_3,Z_4;
     wire N_1,N_2,N_3,N_4;
    
     ALU_add_32_bits p_p(a,b,1'b0,s_1,V_1,N_1,Z_1,V_2,N_2,Z_2);
     ALU_sub_32_bits q_q(a,b,s_2,V_3,N_3,Z_3,V_4,N_4,Z_4);

     ALU_big_two_path_mux r_r(s_1,s_2,fun,out);

     ALU_four_path_mux m_1(V_2,V_4,V_1,V_3,Sign,fun,V);
     ALU_four_path_mux m_2(Z_2,Z_4,Z_1,Z_3,Sign,fun,Z);
     ALU_four_path_mux m_3(N_2,N_4,N_1,N_3,Sign,fun,N);
endmodule 

     
