set start [ clock seconds ]
...
set end [ clock seconds ]
set wall [ expr $end - $start ]
puts "Wall time elapsed was $start to $end = $wall seconds"
