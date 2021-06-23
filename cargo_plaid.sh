#!/usr/bin/env bash

if [ $# -lt 1 ]; then
	>&2 echo "usage: ${0##*/} <path-to-rust-file>"
	exit 1

elif [ "${1: -3}" != ".rs" ]; then
	>&2 echo "file should be *.rs"
	exit 2
fi

fpath="$(realpath $1)"
dpath=$(dirname "$fpath")
fname=$(basename -- "$fpath")
fname="${fname%.*}"

wd="$(mktemp -d)"
pkg_name=hello_cargo

orig_pwd="$PWD"
cd "$wd"

cargo new -q "$pkg_name"
cd "$pkg_name"

cp "$fpath" src/main.rs
printf "\n[profile.release]\ndebug = false\nlto = true\n" >> Cargo.toml

RUSTFLAGS="-C link-arg=-s" cargo build --release

mv "target/release/$pkg_name" "$dpath/$fname"

cd "$orig_pwd"
rm -rf "$wd"
