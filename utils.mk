#
# Copyright (C) 2014 Async Open Source <http://www.async.com.br>
# All rights reserved
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., or visit: http://www.gnu.org/.
#
# Author(s): Stoq Team <stoq-devel@async.com.br>
#

# This needs to be updated when a new Ubuntu release is out or
# one of those reaches EOL
SUPPORTED_DISTROS=precise quantal saucy trusty

check-source:
	@utils/source-tests.sh --modified

check-source-all:
	@utils/source-tests.sh

dist:
	python setup.py sdist
	tar -zxvf dist/*.tar.gz -C dist

debsource: dist
	cd dist/* && \
	for dist in ${SUPPORTED_DISTROS}; do \
		sed -i "1 s/~[a-z0-9]\+)/)/g" debian/changelog; \
		sed -i "1 s/) .\+;/~$${dist}$${EXTRA_VERSION}) $${dist};/g" debian/changelog; \
		debuild --preserve-env -S; \
	done
	@echo "To upload the sources to the ppa you can run:"
	@echo
	@echo "    dput <ppa_name> dist/*.changes"
	@echo

.PHONY: check-source check-source-all
