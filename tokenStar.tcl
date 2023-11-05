set ns [new Simulator]
set nf [open tokenStar.nam w]

$ns namtrace-all $nf

proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam tokenStar.nam &
	exit 0
}

for {set i 0} {$i < 6} {incr i} {
	set n($i) [$ns node]
}

for {set i 1} {$i < 6} {incr i} {
	$ns duplex-link $n(0) $n([expr ($i)]) 1Mb 10ms DropTail
}

set tcp [new Agent/TCP]
$tcp set class_ 1
$ns attach-agent $n(1) $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n(3) $sink

$ns connect $tcp $sink

set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 500
$cbr set interval_ 0.01
$cbr attach-agent $tcp


$ns at 0.5 "$cbr start"
$ns at 4.5 "$cbr stop"


$ns at 5.0 "finish"

$ns run
