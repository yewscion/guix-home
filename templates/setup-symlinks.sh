#!/bin/sh

ln -sv Changelog.md ChangeLog
ln -sv README.md README
ln -sv LICENSE COPYING
ln -sv AUTHORS THANKS
chmod -v +x *.sh bootstrap
rm -v ./setup-symlinks.sh
