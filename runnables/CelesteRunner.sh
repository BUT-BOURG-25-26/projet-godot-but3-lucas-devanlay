#!/bin/sh
printf '\033c\033]0;%s\a' CelesteRunner
base_path="$(dirname "$(realpath "$0")")"
"$base_path/CelesteRunner.x86_64" "$@"
