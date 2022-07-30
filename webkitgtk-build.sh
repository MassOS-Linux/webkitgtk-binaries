#!/bin/bash
set -e

test -e /etc/massos-release || (echo "Must be run on MassOS." >&2; exit 1)
MASSOS_RELEASE="$(cat /etc/massos-release)"

. webkitgtk-version.conf

savedir="$(pwd)"
workdir="$(pwd)/workdir"
test ! -e "${workdir}" || (echo "Remove existing directory ${workdir} first." >&2; exit 1)
mkdir -p "${workdir}"; cd "${workdir}"

unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS

ICU_VER="$(readlink /usr/lib/libicuuc.so | cut -d. -f3-4)"

wget https://webkitgtk.org/releases/webkitgtk-${WEBKITGTK_VERSION}.tar.xz

tar -xf webkitgtk-${WEBKITGTK_VERSION}.tar.xz
cd webkitgtk-${WEBKITGTK_VERSION}
mkdir webkitgtk-build; cd webkitgtk-build
cmake -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_SKIP_RPATH=ON -DPORT=GTK -DLIB_INSTALL_DIR=/usr/lib -DENABLE_GAMEPAD=OFF -DENABLE_GLES2=ON -DENABLE_GTKDOC=ON -DENABLE_MINIBROWSER=ON -DUSE_ANGLE_WEBGL=OFF -DUSE_AVIF=OFF -DUSE_GTK4=OFF -DUSE_JPEGXL=OFF -DUSE_LIBHYPHEN=OFF -DUSE_SOUP2=ON -DUSE_WOFF2=ON -DUSE_WPE_RENDERER=ON -Wno-dev -G Ninja ..
ninja -j$(nproc)
DESTDIR="${workdir}"/out ninja install
install -dm755 "${workdir}"/usr/share/licenses/webkitgtk
find ../Source -name 'COPYING*' -or -name 'LICENSE*' -print0 | sort -z | while IFS= read -d $'\0' -r _f; do echo "### $_f ###"; cat "$_f"; echo; done > "${workdir}"/usr/share/licenses/webkitgtk/LICENSE

cd "${workdir}"/out
tar -cJf "${savedir}/webkitgtk-${WEBKITGTK_VERSION}-MassOS${MASSOS_RELEASE}-icu${ICU_VER}-$(uname -m).tar.xz" *
cd "${savedir}"
rm -rf "${workdir}"
