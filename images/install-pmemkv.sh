#!/usr/bin/env bash
# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2019-2021, Intel Corporation

#
# install-pmemkv.sh [package_type] - installs PMEMKV
#		from DEB/RPM packages if possible.
#

set -e

if [ "${SKIP_PMEMKV_BUILD}" ]; then
	echo "Variable 'SKIP_PMEMKV_BUILD' is set; skipping building PMEMKV"
	exit
fi

PACKAGE_TYPE=${1}
PREFIX=${2:-/usr}

# master: 1.5.0, 27.07.2021
PMEMKV_VERSION="a92abed550ece9c5c70b6be17db8e9cb19e328e4"

git clone https://github.com/pmem/pmemkv
cd pmemkv
git checkout ${PMEMKV_VERSION}

if [ "${PACKAGE_TYPE}" = "" ]; then
  mkdir ./build
  cd ./build
  cmake .. -DBUILD_TESTS=OFF -DCMAKE_BUILD_TYPE=Debug -DBUILD_DOC=OFF -DTESTS_JSON=OFF
	make -j$(nproc) install prefix=${PREFIX}
else
	make -j$(nproc) BUILD_PACKAGE_CHECK=n ${PACKAGE_TYPE}
	if [ "${PACKAGE_TYPE}" = "dpkg" ]; then
		sudo dpkg -i dpkg/libpmem_*.deb dpkg/libpmem-dev_*.deb \
			dpkg/libpmemobj_*.deb dpkg/libpmemobj-dev_*.deb \
			dpkg/pmreorder_*.deb dpkg/libpmempool_*.deb dpkg/libpmempool-dev_*.deb \
			dpkg/libpmemblk_*.deb dpkg/libpmemlog_*.deb dpkg/pmempool_*.deb
	elif [ "${PACKAGE_TYPE}" = "rpm" ]; then
		sudo rpm -i rpm/*/pmdk-debuginfo-*.rpm \
			rpm/*/libpmem*-*.rpm \
			rpm/*/pmreorder-*.rpm \
			rpm/*/pmempool-*.rpm
	fi
fi

cd ../..
rm -r pmemkv
