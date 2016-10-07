 #!/usr/local/bin/tclsh8.4
package require Oratcl
####UPDATE THE CONNECT STRING BELOW###
set connect user/password@rac1
set lda [oralogon $connect]
set curn1 [oraopen $lda ]
set sql1 "ALTER SESSION SET EVENTS '10046 trace name context forever, level 4' "
orasql $curn1 $sql1
set curn2 [oraopen $lda ]
set sql2 "SELECT time_id, channel_id, prod_id, ROUND
(SUM(amount_sold)) AS TOTAL FROM SALES WHERE time_id BETWEEN TO_DATE(:t_id1) AND TO_DATE(:t_id2) AND prod_id IN (SELECT prod_id FROM products WHERE prod_name IN (:pname1,:pname2,:pname3,:pname4,:pname5)) GROUP BY ROLLUP (time_id, (channel_id, prod_id)) "
orasql $curn2 $sql2 -parseonly
orabindexec $curn2 :pname3 {Envoy 256MB - 40GB} :pname4 {Y Box} :t_id1 {01-JAN-98} :pname5 {Mini DV Camcorder with 3.5" Swivel LCD} :pname1 {5MP Telephoto Digital Camera} :t_id2 {31-JAN-98} :pname2 {17" LCD w/built-in HDTV Tuner}
set row [orafetch $curn2 -datavariable output ]
while { [ oramsg $curn2 ] == 0 } {
puts $output
set row [orafetch $curn2 -datavariable output ]
}
oraclose $curn1
set curn1 [oraopen $lda ]
set sql1 "ALTER SESSION SET EVENTS '10046 trace name context off' "
orasql $curn1 $sql1
oraclose $curn1
oralogoff $lda

