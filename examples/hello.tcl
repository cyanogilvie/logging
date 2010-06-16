#!/usr/bin/env tclsh8.6

set here	[file dirname [file normalize [info script]]]
set base	[file dirname $here]
tcl::tm::path add [file join $base tm tcl]

package require logging

logging::logger ::log notice

foreach lvl {
	trivia
	debug
	notice
	warn
	error
	fatal
} {
	log $lvl "hello, $lvl"
}
