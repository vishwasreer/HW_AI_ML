
echo > ${top_design}.io
echo \(globals >> ${top_design}.io
echo version = 3 >> ${top_design}.io
echo io_order = default >> ${top_design}.io
echo \) >> ${top_design}.io
echo \(iopad >> ${top_design}.io
echo \(left >> ${top_design}.io
foreach_in_collection i [ get_cells io_l* ] {
  echo \(inst name=[get_db $i .name] \) >> ${top_design}.io
}
echo \) >> ${top_design}.io
echo \(top >> ${top_design}.io
foreach_in_collection i [ get_cells io_t* ] {
  echo \(inst name=[get_db $i .name] \) >> ${top_design}.io
}
echo \) >> ${top_design}.io
echo \(right >> ${top_design}.io
foreach_in_collection i [ get_cells io_r* ] {
  echo \(inst name=[get_db $i .name] \) >> ${top_design}.io
}
echo \) >> ${top_design}.io
echo \(bottom >> ${top_design}.io
foreach_in_collection i [ get_cells io_b* ] {
  echo \(inst name=[get_db $i .name] \) >> ${top_design}.io
}
echo \) >> ${top_design}.io
echo \) >> ${top_design}.io

if [ is_common_ui_mode ] {
   read_io_file ${top_design}.io
} else {
   loadIoFile ${top_design}.io
}
