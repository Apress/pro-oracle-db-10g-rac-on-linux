set filelist [ list /home/oracle/input1.txt /home/oracle/input2.txt /home/oracle/input3.txt /home/oracle/input4.txt /home/oracle/input5.txt ]
set choice [ RandomNumber 0 [ expr $ll - 1 ] ]
set fc [ lindex $filelist $choice ]
set fd [ open $fc r ]
