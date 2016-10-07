 #!/usr/local/bin/tclsh8.4
package require Oratcl
####UPDATE THE CONNECT STRING BELOW###
set connect sh/sh@rac
set lda [oralogon $connect]
set curn1 [oraopen $lda]
set sql1 "SELECT time_id, channel_id, prod_id, ROUND (SUM(amount_sold)) AS TOTAL FROM SALES WHERE time_id BETWEEN TO_DATE(:t_id1) AND TO_DATE(:t_id2) AND prod_id IN (SELECT prod_id FROM products WHERE prod_name IN (:pname1,:pname2,:pname3,:pname4,:pname5)) GROUP BY ROLLUP (time_id, (channel_id, prod_id)) "
orasql $curn1 $sql1 -parseonly
set fd [ open /home/oracle/input1.txt r ]
set flbuff [read $fd]
close $fd
set filelist [split $flbuff "\n"]
unset flbuff
foreach line $filelist {
set params [ split [ regsub -all {(\ \ )} $line {} ] ":" ]
set startdate [ string trim [ lindex $params 0 ] ]
set enddate [ string trim [ lindex $params 1 ] ]
set pname1 [ string trim [ lindex $params 2] ]
set pname2 [ string trim [ lindex $params 3] ]
set pname3 [ string trim [ lindex $params 4 ] ]
set pname4 [ string trim [ lindex $params 5 ] ]
set pname5 [ string trim [ lindex $params 6 ] ]
set value [ time { orabindexec $curn1 :t_id1 $startdate :t_id2 $enddate :pname1 $pname1 :pname2 $pname2 :pname3 $pname3 :pname4 $pname4 :pname5 $pname5
set row [orafetch $curn1 -datavariable output ]
while { [ oramsg $curn1 ] == 0 } {
set row [orafetch $curn1 -datavariable output ] } } ]
regexp {([0-9]+)} $value all tim
lappend microsecs $tim
}
oraclose $curn1
oralogoff $lda
set max 0
foreach val $microsecs {
if { $val > $max } { set max $val }
}
puts "Maximum user response time was $max microseconds"
set sum 0
foreach val $microsecs {
set sum [ expr { $sum+$val } ]
}
puts "Total user response time was $sum microseconds"
set N [ expr { [ llength $microsecs ] + 1 } ]
set average [ expr { $sum/$N } ]
puts "Average response time was $average microseconds"
