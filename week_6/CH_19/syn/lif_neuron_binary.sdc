set clk_period 1.0
create_clock -name "clk" -period $clk_period  clk
set_clock_uncertainty -setup 0.025 clk
set_clock_uncertainty -hold 0.025 clk
set_clock_latency 0.23 clk
set_clock_transition 0.025 clk


#group_path -name INTERNAL -from [all_clocks] -to [all_clocks ]
group_path -name INPUTS -from [ get_ports -filter "direction==in&&full_name!~*clk*" ]
group_path -name OUTPUTS -to [ get_ports -filter "direction==out" ]
