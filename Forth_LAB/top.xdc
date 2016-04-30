set_property PACKAGE_PIN B18 [get_ports UART_RXD]
set_property PACKAGE_PIN A18 [get_ports UART_TXD]

#clock pulse enable
#----------------------------------------------------------
set_property PACKAGE_PIN W5 [get_ports clk]
create_clock -period 10.000 -name CLK -waveform {0.000 5.000} [get_ports clk]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets CLOCK_50]

set_property IOSTANDARD LVCMOS33 [get_ports UART_RXD]
set_property IOSTANDARD LVCMOS33 [get_ports UART_TXD]
set_property IOSTANDARD LVCMOS33 [get_ports clk]