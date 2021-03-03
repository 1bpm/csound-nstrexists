<CsoundSynthesizer>
<CsOptions>
-n ; no audio
</CsOptions>
<CsInstruments>
/*
	Demonstration of nstrexists.
	Check through a range of instrument numbers and report if they are
	known to the Csound engine.

*/
sr = 44100
ksmps = 1
nchnls = 2
0dbfs = 1

/* 
	Empty instruments to test for existence 
*/
instr 92
endin

instr 93
endin

instr 95
endin

instr testinstr1
endin

instr testinstr3
endin

instr testinstr4
endin


/*
	Go through instrument numbers 1 to 10 and check for existence
*/
instr 98

	; test the numeric i-rate opcode: look for instruments numbered between 91 and 98
	inum = 91
loop:
	prints(sprintf("(i-rate) Instr %d : %d\n", inum, nstrexists(inum)))
	loop_lt inum, 1, 99, loop
	turnoff
endin


instr 99

	; test the numeric k-rate opcode: look for instruments numbered between 91 and 98
	knum = 91
loop:
	printks2(sprintfk("(k-rate) Instr %d: %d\n", knum, nstrexists(knum)), knum)
	loop_lt knum, 1, 99, loop
	turnoff
endin

</CsInstruments>
<CsScore>
i98 0 1
i99 1 1
</CsScore>
</CsoundSynthesizer>

