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
    #git pull
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
  zst=$(echo *.pkg.tar.zst)
  echo "zst: $zst"
  if [[ ! -e /repo/$zst ]]; then
    echo "adding package $zst"
    mv *.pkg.* /repo
    repo-add --nocolor -s -R /repo/repo.db.tar.gz /repo/$zst
  fi
  popd
done
