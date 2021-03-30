onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group CONTROL -label Clock /addersubtract_tb/clock
add wave -noupdate -expand -group CONTROL -label {Reset N} /addersubtract_tb/resetn
add wave -noupdate -expand -group OPERANDS -label {Input A} /addersubtract_tb/value_a
add wave -noupdate -expand -group OPERANDS -label {Input B} /addersubtract_tb/value_b
add wave -noupdate -expand -group RESULTS -label Gold /addersubtract_tb/gold
add wave -noupdate -expand -group RESULTS -label Fpga /addersubtract_tb/fpga
add wave -noupdate -expand -group RESULTS -color Red -format Analog-Step -height 60 -label {Error : Max = 1e-3} -max 0.001 -min -0.001 /addersubtract_tb/error
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {78680000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 472
configure wave -valuecolwidth 179
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
WaveRestoreZoom {0 ps} {735 us}
