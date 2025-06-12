if { [info exists synopsys_program_name ] } {
    source -echo -verbose ../scripts/fix_macro_outputs_place.tcl
    echo READING SCANDEF
    read_def ../../syn/outputs/ORCA_TOP.dct.scan.def
    echo FINISHED READING SCANDEF

    # Creating seperate voltage area for core area. 
    remove_voltage_areas *
    create_voltage_area -power_domains PD_RISC_CORE -region {{11 400} {450 640}}
    # Commit the UPF settings for ORCA.
    commit_upf
} else {
  source ../scripts/update_vddh_libs.tcl

  if { [ is_common_ui_mode ] } {  set_db eco_batch_mode true
  } else { setEcoMode -batchMode true }

  foreach_in_collection i [ get_cells -hier -filter "ref_name=~LSD*||ref_name==LSUP" ] {
     set vt [regsub  ".VT" [get_db $i .base_cell.base_name ] LVT ] 
     if { [ is_common_ui_mode ] } {  eco_update_cell -insts [get_db $i .name ] -cells $vt   
     } else { ecoChangeCell -inst [get_db $i .name ] -cell $vt  }
  }
  if { [ is_common_ui_mode ] } {  set_db eco_batch_mode false
  } else { setEcoMode -batchMode false  }
}

