PREFIX=/usr/local
all:
	true

install:
	cp enroll-host \
		enroll-host-internal \
		enroll-client \
		enroll-user \
		$(PREFIX)/bin
