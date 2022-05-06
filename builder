#!/bin/bash
urlpkglist=(`cat /config/packagelist`)
pkglist=()

for url in $urlpkglist; do
  name=$(basename "$url")
  name=${name%.git}
  pkglist+=($name)
done

cd /build

# update git repos
iter=0
for url in $urlpkglist; do
  pkgname=${pkglist[$iter]}
  echo $pkgname $url
  if [[ -d $pkgname ]]; then
    pushd $pkgname
    git pull
    popd
  else
    git clone $url $pkgname
  fi
  ((iter++))
done

# build
for pkg in $pkglist; do
  pushd $pkg
  makepkg -s --noconfirm
  popd
done

# add to repo
cd /repo
repo-add repo.db.tar.gz *.pkg.tar.zst
