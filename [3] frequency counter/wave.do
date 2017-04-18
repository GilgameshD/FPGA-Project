onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TB/testmode
add wave -noupdate /TB/modecontrol
add wave -noupdate /TB/highfreq
add wave -noupdate /TB/t/freq/sc/clkControl
add wave -noupdate /TB/t/freq/sc/clkScan
add wave -noupdate /TB/t/freq/cs/enable
add wave -noupdate /TB/t/freq/cs/clear
add wave -noupdate /TB/t/freq/cs/latch
add wave -noupdate /TB/t/freq/dec/num
add wave -noupdate /TB/t/freq/l/outData
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2341269685 ns} 0}
configure wave -namecolwidth 181
configure wave -valuecolwidth 57
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
configure wave -timelineunits ns
update
WaveRestoreZoom {691677184 ns} {2075031552 ns}
