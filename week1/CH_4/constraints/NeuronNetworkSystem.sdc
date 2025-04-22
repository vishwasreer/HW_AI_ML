
set clk_period 1.0
set sclk_period 1.0

create_clock -name "clk" -period $clk_period  clk

set_clock_uncertainty -setup 0.025 clk
set_clock_uncertainty -hold 0.025 clk
set_clock_latency 0.23 clk
set_clock_transition 0.02 clk

create_clock -name "sclk" -period $sclk_period sclk

set_clock_uncertainty -setup 0.025 sclk
set_clock_uncertainty -hold 0.025 sclk
set_clock_latency 0.23 sclk
set_clock_transition 0.02 sclk


#set_false_path -from [get_clocks wclk ] -to [get_clocks rclk]
#set_false_path -from [get_clocks rclk ] -to [ get_clocks wclk]

# Add input/output delays in relation to related clocks
# Can tell the related clock by doing report_timing -group INPUTS  or -group OUTPUTS after using group_path
# External delay should be some percentage of clock period.
# Tune/relax if violating; most concerned about internal paths.

# I like set_driving_cell to a std cell from the library.  set_drive works to.

# set_load

#group_path -name INTERNAL -from [all_clocks] -to [all_clocks ]
group_path -name INPUTS -from [ get_ports -filter "direction==in&&full_name!~*clk*" ]
group_path -name OUTPUTS -to [ get_ports -filter "direction==out" ]


#set_input_delay 0.1 wdata_in* -clock wclk
#set_input_delay -clock wclk 0.0 [get_ports winc]
#set_input_delay -clock rclk 0.0 [get_ports rinc]
#set_input_delay -clock rclk 0.0 [get_ports rrst_n]
#set_input_delay 0.0 rrst_n -clock wclk -add_delay
#set_input_delay 0.0 rrst_n -clock wclk2x -add_delay


#set_output_delay -0.5 rdata* -clock rclk
#set_output_delay -clock rclk 0.28 [get_ports rdata*]
#set_output_delay -clock rclk 0.28 [get_ports rempty]
#set_output_delay -clock wclk 0.28 [get_ports wfull]

