#!/bin/bash

set -ex

QUILT=/usr/bin/quilt
BASENAME=/usr/bin/basename
PATCH=/usr/bin/patch
CP=/bin/cp
DCH=/usr/bin/dch

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

DEBEMAIL="$GITLAB_USER_EMAIL" DEBFULLNAME="$GITLAB_USER_NAME" $DCH --local local 'Add --no-legacy patch'
DEBEMAIL="$GITLAB_USER_EMAIL" DEBFULLNAME="$GITLAB_USER_NAME" $DCH --release ""