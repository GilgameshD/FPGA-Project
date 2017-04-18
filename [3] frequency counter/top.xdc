#---------------------------------------------------------
set_property PACKAGE_PIN V16 [get_ports {testmode[1]}]
set_property PACKAGE_PIN V17 [get_ports {testmode[0]}]
set_property PACKAGE_PIN W13 [get_ports {modecontrol}]
set_property PACKAGE_PIN V14 [get_ports {highfreq}]

set_property PACKAGE_PIN U7 [get_ports {cathodes[0]}]
set_property PACKAGE_PIN V5 [get_ports {cathodes[1]}]
set_property PACKAGE_PIN U5 [get_ports {cathodes[2]}]
set_property PACKAGE_PIN V8 [get_ports {cathodes[3]}]
set_property PACKAGE_PIN U8 [get_ports {cathodes[4]}]
set_property PACKAGE_PIN W6 [get_ports {cathodes[5]}]
set_property PACKAGE_PIN W7 [get_ports {cathodes[6]}]

set_property PACKAGE_PIN U2 [get_ports {AN[0]}]
set_property PACKAGE_PIN U4 [get_ports {AN[1]}]
set_property PACKAGE_PIN V4 [get_ports {AN[2]}]
set_property PACKAGE_PIN W4 [get_ports {AN[3]}]

#clock pulse enable
#----------------------------------------------------------
set_property PACKAGE_PIN W5 [get_ports clk]
create_clock -period 10.000 -name CLK -waveform {0.000 5.000} [get_ports clk]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk]

# set the voltage level
#-------------------------------------------------------------
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {testmode[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {testmode[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {modecontrol}]
set_property IOSTANDARD LVCMOS33 [get_ports {highfreq}]

set_property IOSTANDARD LVCMOS33 [get_ports {cathodes[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathodes[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathodes[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathodes[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathodes[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathodes[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathodes[6]}]

set_property IOSTANDARD LVCMOS33 [get_ports {AN[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AN[0]}]