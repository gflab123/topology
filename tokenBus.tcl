set ns [new Simulator]
set nf [open tokenBus.nam w]

$ns namtrace-all $nf

proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam tokenBus.nam &
	exit 0
}

for { set i 0 } { $i < 5 } { incr i} {
    set n($i) [$ns node]
}

set lan0 [$ns newLan "$n(0) $n(1) $n(2) $n(3) $n(4)" 0.5Mb 40ms LL Queue/DropTail/MAC/CsmaCd Channel]


set tcp [new Agent/TCP]
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
$ns at 5 "finish"

$ns run
