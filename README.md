## Introduction
csound-nstrexists provides a simple way to check whether an instrument number exists in the orchestra, at i-rate or k-rate. An example csd is provided in the examples/ directory demonstrating i and k-rate operation.
This depends on changes in [a commit](https://github.com/csound/csound/commit/cca2bd90bffc5c36499c74734e37ec256dc60924) from  2019-09-12 so it will not work with builds older than that. The first stable Csound release with the relevant changes is 6.14.0

The opcode has only been tested on Linux as of writing.


## Requirements
 - Csound development libraries 6.14.0 or later
 - Cmake 3.8 or later


## Building
Create a build directory at the top of the source tree, execute *cmake ..*, *make* and optionally *make install* as root. If the latter is not used/possible then the resulting libnstrexists module can be used with the *--opcode-lib* flag in Csound. eg:
	
	cd csound-nstrexists
	mkdir build && cd build
	cmake ..
	make && sudo make install


## Opcode overview
### nstrexists
*iexists nstrexists instrnum*

*kexists nstrexists knstrnum*

Check if an instrument exists given the instrument number.

 - iexists | kexists : 1 if instrument is found, 0 if not
 - instrnum | knstrnum : the instrument number to check

