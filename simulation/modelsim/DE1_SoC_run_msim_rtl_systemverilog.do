transcript on
if ![file isdirectory DE1_SoC_iputf_libs] {
	file mkdir DE1_SoC_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vlog "D:/Documents/ee_371_lab6/CLOCK25_PLL_sim/CLOCK25_PLL.vo"

vlog -vlog01compat -work work +incdir+D:/Documents/ee_371_lab6 {D:/Documents/ee_371_lab6/altera_up_avalon_video_vga_timing.v}
vlog -sv -work work +incdir+D:/Documents/ee_371_lab6 {D:/Documents/ee_371_lab6/incrementor.sv}
vlog -sv -work work +incdir+D:/Documents/ee_371_lab6 {D:/Documents/ee_371_lab6/chunk_drawer.sv}
vlog -sv -work work +incdir+D:/Documents/ee_371_lab6 {D:/Documents/ee_371_lab6/chunk_memory.sv}
vlog -sv -work work +incdir+D:/Documents/ee_371_lab6 {D:/Documents/ee_371_lab6/chunk_ctrl.sv}
vlog -sv -work work +incdir+D:/Documents/ee_371_lab6 {D:/Documents/ee_371_lab6/video_driver.sv}
vlog -sv -work work +incdir+D:/Documents/ee_371_lab6 {D:/Documents/ee_371_lab6/DE1_SoC.sv}

