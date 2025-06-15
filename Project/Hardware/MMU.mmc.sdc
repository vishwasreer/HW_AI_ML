if { [info exists synopsys_program_name ] && ($synopsys_program_name == "icc2_shell") } {
    puts " Creating ICC2 MCMM "
    create_mode func
    create_corner slow
    create_scenario -mode func -corner slow -name func_slow
    current_scenario func_slow
    set_operating_conditions ss0p75v125c
    read_parasitic_tech -tlup $tlu_dir/saed32nm_1p9m_Cmax.tluplus -layermap $tlu_dir/saed32nm_tf_itf_tluplus.map -name Cmax
    read_parasitic_tech -tlup $tlu_dir/saed32nm_1p9m_Cmin.tluplus -layermap $tlu_dir/saed32nm_tf_itf_tluplus.map -name Cmin
    set_parasitic_parameters -early_spec Cmax -early_temperature 125
    set_parasitic_parameters -late_spec Cmax -late_temperature 125
    #set_parasitic_parameters -early_spec 1p9m_Cmax -early_temperature 125 -corner default
    #set_parasitic_parameters -late_spec 1p9m_Cmax -late_temperature 125 -corner default

    #set_scenario_status  default -active false
    set_scenario_status func_slow -active true -hold true -setup true
}
set clk_period 2.0


create_clock -name "clk" -period $clk_period  clk
set_clock_uncertainty -setup 0.025 clk
set_clock_uncertainty -hold 0.025 clk
set_clock_latency 0.23 clk
set_clock_transition 0.025 clk
# Add input/output delays in relation to related clocks
# Can tell the related clock by doing report_timing -group INPUTS  or -group OUTPUTS after using group_path
# External delay should be some percentage of clock period.
# Tune/relax if violating; most concerned about internal paths.

# I like set_driving_cell to a std cell from the library.  set_drive works to.

# set_load

#group_path -name INTERNAL -from [all_clocks] -to [all_clocks ]
group_path -name INPUTS -from [ get_ports -filter "direction==in&&full_name!~*clk*" ]
group_path -name OUTPUTS -to [ get_ports -filter "direction==out" ]

