dnl Process this file with autoconf
AC_INIT([project-name],
        [0.0.1],
        [yewscion@gmail.com],
        [project-name],
        [project-homepage])

dnl General Project Variables
AC_SUBST(LICENSE, ["Copyright (C) 2022 Christopher Rodriguez

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

"])
_AM_SUBST_NOTMAKE([LICENSE])
AC_CONFIG_SRCDIR([README.md])
AC_CONFIG_AUX_DIR([build-aux])

dnl Set Up Automake
AM_INIT_AUTOMAKE([-Wall -Werror -Wportability gnu check-news dist-bzip2
filename-length-max=99 std-options])

dnl Set Up Guile 3.0
GUILE_PKG([3.0])
GUILE_PROGS
if test "x$GUILD" = "x"; then
   AC_MSG_ERROR(['guild' binary not found;
   please check Your guile installation.])
fi
GUILE_SITE_DIR

dnl Set Up Java
AC_PROG_CC
AX_CHECK_CLASSPATH
AX_PROG_JAVA_CC
AX_PROG_JAVAC
AX_PROG_JAVA
AX_PROG_JAR
AX_PROG_JAVADOC
AC_SUBST(MYJAVAPKG, [project-name])

AC_SUBST(JAVA_CC_OPTS, ["-encoding UTF-8"])

dnl Checks for classes
dnl AX_CHECK_RQRD_CLASS(org.whatever)

dnl Installation directories for .scm and .go files.
guilemoduledir="${datarootdir}/guile/site/$GUILE_EFFECTIVE_VERSION"
guileobjectdir="${libdir}/guile/$GUILE_EFFECTIVE_VERSION/site-ccache"
AC_SUBST([guilemoduledir])
AC_SUBST([guileobjectdir])

dnl Set Up OCaml
AC_PROG_OCAML

dnl Finishing Up
AC_PROG_LN_S
AC_PROG_MKDIR_P
AC_CONFIG_FILES([Makefile])
AC_CONFIG_FILES([pre-inst-env], [chmod +x pre-inst-env])
AC_CONFIG_FILES([bin/project-name-info],[chmod +x bin/project-name-info])
AC_CONFIG_FILES([doc/version.texi])
AC_OUTPUT
