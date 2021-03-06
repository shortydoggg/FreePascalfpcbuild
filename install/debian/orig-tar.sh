#!/bin/sh -xe

PACKAGE_NAME=fpc
TMP_DIR=`/bin/mktemp -d -t ${PACKAGE_NAME}.XXXXXX` || exit 1
ORIG_PATH=$(pwd)

while test $# -gt 0
do
	case $1 in
		--upstream-version)
			shift
			VERSION=$1
			;;
		*)
			ORIG_SRC_TAR=$(readlink -m $1)
			;;
	esac
	shift
done

ORIG_SRC_DIR=${PACKAGE_NAME}
DEB_SRC_DIR=${PACKAGE_NAME}-${VERSION}+dfsg
DEB_SRC_TAR=${PACKAGE_NAME}_${VERSION}+dfsg.orig.tar.gz

cd ${TMP_DIR}
tar -axf ${ORIG_SRC_TAR}
mv ${ORIG_SRC_DIR}* ${DEB_SRC_DIR}
cd ${DEB_SRC_DIR}
find -name Makefile.fpc -execdir sh -c 'rm $(basename {} .fpc)' ';'
find -regex '.*\.\(a\|or?\|so\.*\|ppu\|compiled\|exe\|dll\)' -delete
find -name '*.pp' -exec chmod a-x {} ';'
cd ..
tar -acf ${DEB_SRC_TAR} ${DEB_SRC_DIR}
cd ${ORIG_PATH}
mv ${TMP_DIR}/${DEB_SRC_TAR} ../
rm -rf ${TMP_DIR}
