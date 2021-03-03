/*
    opcodes.cpp
    Copyright (C) 2021 Richard Knight


    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 3 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program; if not, write to the Free Software Foundation,
    Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 
 */


#include "csdl.h"

// struct for numeric opcode
typedef struct _nstrexists_t {
	OPDS h;
	MYFLT *out;
	MYFLT *in;
} nstrexists_t;


// numeric opcode
int nstrexists(CSOUND *csound, nstrexists_t *p) {
	if (NULL != csound->GetInstrument(csound, (int)*p->in, NULL)) {
		*(p->out) = FL(1);
	} else {
		*(p->out) = FL(0);
	}
	return OK;
}


static OENTRY localops[] = {
	{"nstrexists", sizeof(nstrexists_t), 0, 1, "i", "i", (SUBR) nstrexists, NULL, NULL},
	{"nstrexists.k", sizeof(nstrexists_t), 0, 3, "k", "k", (SUBR) nstrexists, (SUBR) nstrexists, NULL},
};

LINKAGE
