#!/bin/tclsh
load tclrega.so

#set device_name "CUX4000001"

set device_name [lindex $argv 0]
set device_sysvar_name [lindex $argv 1]
set device_cmd [lindex $argv 2]
set device_remote_enc [lindex $argv 3]
set device_remote_id [lindex $argv 4]

# command-line for reading rolling counter sysvar
set cmd "var remote_counter = dom.GetObject(\"$device_sysvar_name\").Value();"
# read sysvar
array set values [rega_script  $cmd  ]
    
set remote_counter $values(remote_counter)
# convert to integer
set remote_counter [ expr int($remote_counter)]
#puts $remote_counter   
# convert to HEX
set remote_counter_hex [ format %04X $remote_counter ]
#puts $remote_counter_hex

switch $device_cmd {
   "OPEN" { set device_cmd_hex "20" }
   "1000" { set device_cmd_hex "20" }
   "CLOSE" { set device_cmd_hex "40" }
   "0" { set device_cmd_hex "40" }
   "PROG" { set device_cmd_hex "80" }
   "MY" { set device_cmd_hex "10" }
   "500" { set device_cmd_hex "10" }
   "STOP" { set device_cmd_hex "11" }
   default { puts "WRONG SOMFY COMMAND" }
}
set somfy_cmd "\"Ys$device_remote_enc$device_cmd_hex$remote_counter_hex$device_remote_id\""
puts $somfy_cmd
set cmd "dom.GetObject(\"CUxD.$device_name.SEND_CMD\").State($somfy_cmd);"
puts $cmd

#array set values [ rega_script  $cmd  ]

rega_script  $cmd

#rega_script { dom.GetObject("CUxD.CUX4000001:1.SEND_CMD").State("YsA0200018ABCDEF");}

set remote_counter [ expr $remote_counter + 1 ]
puts $remote_counter

set cmd ""
append cmd "var i = dom.GetObject('$device_sysvar_name');"
append cmd "i.State('$remote_counter');"

array set values [rega_script  $cmd  ]
