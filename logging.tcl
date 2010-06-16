# vim: ft=tcl foldmethod=marker foldmarker=<<<,>>> ts=4 shiftwidth=4

namespace eval logging {
	proc logger {name loglevel} {
		set levelmap	{
			trivia		5
			debug		10
			notify		20
			notice		20
			warning		30
			warn		30
			error		40
			fatal		50
		}
		if {[dict exists $levelmap $loglevel]} {
			set loglevel	[dict get $levelmap $loglevel]
		}
		if {![string is integer -strict $loglevel]} {
			error "loglevel must be an integer or one of [join [dict keys $levelmap] {, }]"
		}
		namespace eval $name [list variable loglevel $loglevel]
		namespace eval $name [list variable levelmap $levelmap]
		namespace eval $name {
			namespace export *
			namespace ensemble create

			proc _n {l} { #<<<
				set fg	"bright white"
				if {$l >= 40} {
					set bg	red
				} elseif {$l >= 30} {
					set bg	purple
				} elseif {$l >= 20} {
					set bg	blue
				} elseif {$l >= 10} {
					set bg	blue
					set fg	yellow
				} else {
					set bg	none
				}
				concat bg_$bg $fg
			}

			#>>>
			proc _c {args} { #<<<
				set build	""
				set map {
					black		30
					red			31
					green		32
					yellow		33
					blue		34
					purple		35
					cyan		36
					white		37
					bg_black	40
					bg_red		41
					bg_green	42
					bg_yellow	43
					bg_blue		44
					bg_purple	45
					bg_cyan		46
					bg_white	47
					inverse		7
					bold		5
					underline	4
					bright		1
					norm		0
				}
				foreach t $args {
					if {[dict exists $map $t]} {
						append build "\\\[[dict get $map $t]m"
					}
				}
				set build
			}

			#>>>

			dict for {name int} $levelmap {
				if {$int >= $loglevel} {
					proc $name {msg args} \
							[format {puts %s${msg}%s} [_c {*}[_n $int]] [_c norm]]
				} else {
					proc $name {args} {}
				}
			}
		}
	}
}
