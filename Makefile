# Makefile for CRM114 library
#
# Copyright 2010 Kurt Hackenberg & William S. Yerazunis, each individually
# with full rights to relicense.
#
#   This file is part of the CRM114 Library.
#
#   The CRM114 library is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Lesser General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   The CRM114 Library is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Lesser General Public License for more details.
#
#   You should have received a copy of the GNU Lesser General Public License
#   along with the CRM114 Library.  If not, see <http://www.gnu.org/licenses/>.

# GNU Standard Installation Variables

INSTALL      = install
INSTALL_DATA = $(INSTALL) -m 644
INSTALL_DIR  = $(INSTALL) -d

prefix     = /usr/local
includedir = $(prefix)/include
libdir	   = $(prefix)/lib

# CRM114 Installation Directories

includesubdir = $(includedir)/crm114

# Compiler / Linker Options

ifndef CFLAGS
CFLAGS  = -O3
endif
CFLAGS += -fpic -Iinclude -pedantic -std=c99
CFLAGS += -Wall -Wextra -Wpointer-arith -Wstrict-prototypes
CFLAGS += -Wno-sign-compare -Wno-overlength-strings

LDFLAGS += -Llib -lcrm114 -lm -ltre

# Source / Target Files

LIBNAME = libcrm114.a
LIB     = lib/$(LIBNAME)
LIBHDRS = $(wildcard include/*.h)
LIBSRCS = $(wildcard lib/*.c)
LIBOBJS = $(patsubst %.c,%.o,$(LIBSRCS))

TESTHDRS = $(wildcard test/*.h)
TESTSRCS = $(wildcard test/*.c)
TESTTGTS = $(patsubst %.c,%.t,$(TESTSRCS))

.PHONY:	all clean lib lib-clean test test-clean install uninstall

all:	lib test

clean:	lib-clean test-clean

lib:	$(LIB)

lib-clean:
	rm -f $(LIB) $(LIBOBJS)

test:	$(TESTTGTS)

test-clean:
	rm -f $(TESTTGTS)

install: lib
	$(INSTALL_DIR) $(DESTDIR)$(includesubdir)
	$(INSTALL_DATA) $(LIBHDRS) $(DESTDIR)$(includesubdir)
	$(INSTALL_DATA) $(LIB) $(DESTDIR)$(libdir)/$(LIBNAME)

uninstall:
	rm -rf $(DESTDIR)$(includesubdir)
	rm -f  $(DESTDIR)$(libdir)/$(LIBNAME)

$(LIB): $(LIBOBJS)
	$(AR) -rs $@ $(LIBOBJS)

lib/%.o: lib/%.c $(LIBHDRS)
	$(CC) $(CFLAGS) -c -o $@ $<

test/%.t: test/%.c $(TESTHDRS)
	$(CC) $(CFLAGS) $(LDFLAGS) $< -o $@
