#!/usr/local/bin/tclsh8.4
package require Oratcl
#EDITABLEOPTIONS##################################################
set connect system/manager@rac1
set rampup 2;  #rampup time in minutes
set duration 10;  #duration in minutes
#EDITABLEOPTIONS##################################################
set ramptime 0
puts "Beginning rampup time of $rampup minutes"
set rampup [ expr $rampup*60000 ]
while {$ramptime != $rampup} {
after 60000
set ramptime [ expr $ramptime+60000 ]
puts "Rampup [ expr $ramptime / 60000 ] minutes complete ..."
}
puts "Rampup complete, Taking start AWR snapshot."
set lda [oralogon $connect]
oraautocom $lda on
set curn1 [oraopen $lda ] 
set sql1 "BEGIN dbms_workload_repository.create_snapshot(); END;"
oraparse $curn1 $sql1
if {[catch {oraplexec $curn1 $sql1} message]} { error "Failed to create snapshot : $message" }
set sql2 "SELECT INSTANCE_NUMBER, INSTANCE_NAME, DB_NAME, DBID, SNAP_ID, TO_CHAR(END_INTERVAL_TIME,'DD MON YYYY HH24:MI') FROM ( SELECT DI.INSTANCE_NUMBER, INSTANCE_NAME, DB_NAME, DI.DBID, SNAP_ID, END_INTERVAL_TIME FROM DBA_HIST_SNAPSHOT DS, DBA_HIST_DATABASE_INSTANCE DI ORDER BY SNAP_ID DESC ) WHERE ROWNUM = 1"
if {[catch {orasql $curn1 $sql2} message]} {
error "SQL statement failed: $sql2 : $message"
} else {
orafetch  $curn1 -datavariable firstsnap
split  $firstsnap " "
puts "Start Snapshot [ lindex $firstsnap 4 ] taken at [ lindex $firstsnap 5 ] of instance [ lindex $firstsnap 1 ] ([lindex $firstsnap 0]) of database [ lindex $firstsnap 2 ] ([lindex $firstsnap 3])"
}
puts "Timing test period of $duration in minutes"
set testtime 0
set duration [ expr $duration*60000 ]
while {$testtime != $duration} {
after 60000
set testtime [ expr $testtime+60000 ]
puts -nonewline  "[ expr $testtime / 60000 ]  ...,"
}
puts "Test complete, Taking end AWR snapshot."
oraparse $curn1 $sql1
if {[catch {oraplexec $curn1 $sql1} message]} { error "Failed to create snapshot : $message" }
if {[catch {orasql $curn1 $sql2} message]} {
error "SQL statement failed: $sql2 : $message"
} else {
orafetch  $curn1 -datavariable endsnap
split  $endsnap " "
puts "End Snapshot [ lindex $endsnap 4 ] taken at [ lindex $endsnap 5 ] of instance [ lindex $endsnap 1 ] ([lindex $endsnap 0]) of database [ lindex $endsnap 2 ] ([lindex $endsnap 3])"
puts "Test complete: view report from SNAPID  [ lindex $firstsnap 4 ] to [ lindex $endsnap 4 ]"
}
