# Switches
#set_property PACKAGE_PIN P19 [get_ports {DUTY_CYCLE[5]}]
#set_property PACKAGE_PIN N19 [get_ports {DUTY_CYCLE[4]}]
#set_property PACKAGE_PIN K19 [get_ports {DUTY_CYCLE[3]}]
#set_property PACKAGE_PIN H24 [get_ports {DUTY_CYCLE[2]}]
#set_property PACKAGE_PIN G25 [get_ports {DUTY_CYCLE[1]}]
#set_property PACKAGE_PIN G19 [get_ports {DUTY_CYCLE[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {DUTY_CYCLE[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {DUTY_CYCLE[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {DUTY_CYCLE[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {DUTY_CYCLE[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {DUTY_CYCLE[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {DUTY_CYCLE[0]}]

# Clock
set_property PACKAGE_PIN AD12 [get_ports CLK_P]
set_property PACKAGE_PIN AD11 [get_ports CLK_N]
set_property IOSTANDARD LVDS [get_ports CLK_N]
set_property IOSTANDARD LVDS [get_ports CLK_P]

# LED
set_property PACKAGE_PIN T28 [get_ports LED]
set_property IOSTANDARD LVCMOS33 [get_ports LED]

set_property PACKAGE_PIN R19 [get_ports GRST]
set_property IOSTANDARD LVCMOS33 [get_ports GRST]

# JC Pin 1
set_property PACKAGE_PIN AC26 [get_ports SPY]
set_property IOSTANDARD LVCMOS33 [get_ports SPY]





