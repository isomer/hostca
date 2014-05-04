PREFIX=/usr/local
all:
	true

install:
	cp enroll-host $(PREFIX)/bin
	cp enroll-host-internal $(PREFIX)/sbin
	cp create-hostca $(PREFIX)/sbin
