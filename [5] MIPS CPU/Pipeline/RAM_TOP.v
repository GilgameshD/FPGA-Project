module RAM_TOP(xx,      clk_hehe,   clk,      reset,  read,  write,
               address, writedata,  readdata, irqout, TX,    RX,
               digi,    led,        switch);

    input xx;
    input clk_hehe;
    input clk;
    input reset;
    input read;
    input write;
    input [31 : 0] address;
    input [31 : 0] writedata;
    input [7  : 0] switch;
    input RX;

    output [31 : 0] readdata;
    output irqout;
    output TX;
    output [11 : 0] digi;
    output [7  : 0] led;

    wire [31 : 0] readdata0;
    wire [31 : 0] readdata1;
    RAM_DataMem R1(clk,
                   read,
                   write,
                   address,
                   writedata,
                   readdata0,
                   reset);

    RAM_Peripheral R2(xx,
                      clk_hehe,
                      clk,
                      reset,
                      read,
                      write,
                      address,
                      writedata,
                      readdata1,
                      irqout,
                      TX,
                      RX,
                      digi,
                      led,
                      switch);
    assign readdata = readdata0 | readdata1;
endmodule
