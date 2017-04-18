#---------------------------------------------------------
set_property PACKAGE_PIN T18 [get_ports {RESET}]
set_property PACKAGE_PIN U17 [get_ports {KEY_CLK}]
set_property PACKAGE_PIN V16 [get_ports {INDATA}]
set_property PACKAGE_PIN U16 [get_ports {OUTDATA}]
set_property PACKAGE_PIN U15 [get_ports {STATE[0]}]
set_property PACKAGE_PIN U14 [get_ports {STATE[1]}]
set_property PACKAGE_PIN V14 [get_ports {STATE[2]}]

#clock pulse enable
#----------------------------------------------------------
set_property PACKAGE_PIN W5 [get_ports clk]
create_clock -period 10.000 -name CLK -waveform {0.000 5.000} [get_ports clk]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk]

# set the voltage level
#-------------------------------------------------------------
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {RESET}]
set_property IOSTANDARD LVCMOS33 [get_ports {KEY_CLK}]
set_property IOSTANDARD LVCMOS33 [get_ports {INDATA}]
set_property IOSTANDARD LVCMOS33 [get_ports {OUTDATA}]
set_property IOSTANDARD LVCMOS33 [get_ports {STATE[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {STATE[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {STATE[2]}]