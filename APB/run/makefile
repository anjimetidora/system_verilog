
clean :
	    rm -rf work *.cfg *.asdb* *.tmp *.log *.asdbw *.acdb compile

veri:clean
	  vlib work
		vlog -dbg -f flist
		vsim -c apb_top -do "run -all;quit" -l sim.log
veri_gui:
	  vlib work
		vlog -dbg -f flist
		vsim +access +r apb_top -do "wave -var dut_insta/* sim:/apb_top/*;run -all" -l sim_gui.log
veri_fc:
	  vlib work
		vlog -dbg -f flist
	  vsim -c apb_top -do "run -all;fcover report-html;quit" -l sim.log
veri_assert:
	  vlib work
		vlog -dbg -f flist
		vsim -assert_debug +access +r apb_top -do "wave -rec sim:/apb_top/*;run -all" -l sim.log
veri_cc:
	  vlib work
		vlog -dbg -f flist
		vsim -c -cc apb_top -do "run; coverage report -txt code -coverage.txt; quit"


