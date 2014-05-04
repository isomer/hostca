Host CA
=======

An extremely simplistic CA for managing ssh host keys.  Do you have a large
number of admins who log into a large number of machines?  Are you sick of
seeing:

    The authenticity of host 'example.org (192.0.2.1)' can't be established.
    ECDSA key fingerprint is 49:20:68:61:74:65:20:74:68:69:73:20:6d:73:67:0a
    Are you sure you want to continue connecting (yes/no)?

Or, even worse, someone has reinstalled one of your machines and you get the
dreaded:

    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
    Someone could be eavesdropping on you right now (man-in-the-middle attack)!
    It is also possible that a host key has just been changed.
    The fingerprint for the RSA key sent by the remote host is
    49:20:68:61:74:65:20:74:68:69:73:20:74:6f:6f:0a
    Please contact your system administrator.
    Add correct host key in /home/user/.ssh/known_hosts to get rid of this message.
    Offending RSA key in /home/user/.ssh/known_hosts:1
    RSA host key for 192.0.2.1 has changed and you have requested strict checking.
    Host key verification failed.

There must be a better way.  And that's where hostca comes in.  By signing
your ssh host keys with a CA, your client can automatically validate them
without ever having logged into the machine before.

Creating the CA
===============

Run `create-hostca` as root on the machine you trust to become the CA.  It will
create a `/etc/ssh/hostca` key, and will create a "hostca" unix group, and
suggest you add yourself to it.  Easy.  create-hostca is a very simple
shellscript if you want to audit it.  You probably want to back up the ca key
file.

Using the CA
============

On a machine that has host keys that you want to sign, run
`enroll-host ca-host`.  This will copy the keys to ca-host, sign them, copy
the certificates back, and update the `sshd_config` to use them.  It will also
create a `ssh_known_hosts` file that refers to the CA's public key so that
logins from this machine will use the CA.


Enrolling a client machine
==========================

If you have a machine that doesn't run an ssh server, but needs to be able to
verify host keys (eg a laptop or desktop), you can use `enroll-client` to
add the required CA public keys.  enroll-client takes one parameter, the name
of a machine you can login to to fetch the CA's public key from.


Enrolling a user
================

`enroll-client` is all well and good if you're an administrator on a machine,
but if you don't have access to sudo, and you want to validate other machines
you can use `enroll-user`, which will update `~/.ssh/known_hosts` with the CA
public key for you.  Once again, enroll-user takes the hostname of an existing
machine that has the CA installed on it.
