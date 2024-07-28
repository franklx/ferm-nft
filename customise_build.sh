#!/bin/bash

set -ex

QUILT=/usr/bin/quilt
BASENAME=/usr/bin/basename
PATCH=/usr/bin/patch
CP=/bin/cp
DCH=/usr/bin/dch
CURL=/usr/bin/curl
TAR=/usr/bin/tar

$CURL -o /tmp/ferm.tar.xz https://deb.debian.org/debian/pool/main/f/ferm/ferm_2.5.1.orig.tar.xz
$CURL -o /tmp/ferm-debian.tar.xz https://deb.debian.org/debian/pool/main/f/ferm/ferm_2.5.1-1.1.debian.tar.xz

$TAR Jxvf /tmp/ferm.tar.xz
cd ferm-2.5.1
$TAR Jxvf /tmp/ferm-debian.tar.xz

# Add code patch

$QUILT import -P 0002-Add-no-legacy-parameter.patch ../0002-Add-no-legacy-parameter.patch
$QUILT push

# In the original Debian package, /etc/default/ferm is written to in debian.postinst.
# It is only written to when the file does not exist. However, we must alter /etc/default/ferm
# (add --no-legacy to OPTIONS) on systems on which /etc/default/ferm exists. By installing the
# file using dh_installinit, it will be automatically handled by dpkg.

$PATCH debian/ferm.postinst ../ferm.postinst.patch
$CP ../ferm.default debian/ferm.default

# Update changelog

export DEBEMAIL="flucchini@gmail.com"
export DEBFULLNAME="Franco Lucchini"

$DCH --local frk 'Add --no-legacy patch'
$DCH --release ""

rm /tmp/ferm*.tar.xz
