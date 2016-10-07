set mythread [thread::id]
set allthreads [split [thread::names]]
set totalvirtualusers [expr [llength $allthreads] - 1]
set myposition [expr $totalvirtualusers - [lsearch -exact $allthreads $mythread]]
switch $myposition {
1 { puts "I am the first virtual user, I'll be inserting" }
2 { puts "I am the second virtual user, I'll be deleting" }
default { puts "I am a default virtual user, I'll be selecting" }
}
