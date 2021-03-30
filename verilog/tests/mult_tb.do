onerror {resume}
quietly virtual function -install /mult_tb -env /mult_tb { 0.00001} virtual_000001
quietly virtual function -install /mult_tb -env /mult_tb { 0.00001} virtual_000002
quietly virtual function -install /mult_tb -env /mult_tb { 0.00001} virtual_000003
quietly virtual function -install /mult_tb -env /mult_tb { 0.00001} virtual_000004
quietly virtual function -install /mult_tb -env /mult_tb { 0.00001} virtual_000005
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group CONTROL -label Clock /mult_tb/clock
add wave -noupdate -expand -group CONTROL -label {Reset N} /mult_tb/resetn
add wave -noupdate -expand -group INPUTS -label {Input A} -radix float32 /mult_tb/value_a
add wave -noupdate -expand -group INPUTS -label {Input B} -radix float32 /mult_tb/value_b
add wave -noupdate -expand -group RESULTS -label Gold -radix float32 -radixshowbase 0 /mult_tb/gold
add wave -noupdate -expand -group RESULTS -label Fpga -radix float32 -radixshowbase 0 /mult_tb/fpga
add wave -noupdate -expand -group RESULTS -color Red -format Analog-Step -height 92 -label Error -max 0.001 -min -0.0048668599999999998 -radix float32 -radixshowbase 0 /mult_tb/error
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11509153 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 272
configure wave -valuecolwidth 299
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {21 us}
