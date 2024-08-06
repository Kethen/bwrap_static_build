set -xe

for arch in amd64 arm64
do

podman run \
    --rm -it \
    --arch $arch \
    --security-opt label=disable \
    -v ./:/work_dir \
    -w /work_dir \
    --entrypoint /bin/bash \
    docker.io/fedora:40 \
    -c "
dnf install -y autoconf automake gcc libcap-static libcap-devel libselinux-static libselinux-devel glibc-static glibc-devel git
set -xe
if ! [ -e bubblewrap ]
then
    git clone https://github.com/containers/bubblewrap.git -b v0.9.0
fi
cd bubblewrap
CFLAGS="-static" ./autogen.sh
make
cp bwrap ../bwrap_static_$arch
"

done
