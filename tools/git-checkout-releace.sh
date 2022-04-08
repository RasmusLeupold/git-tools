#!/bin/bash

if [[ -n $1 ]]; then
  if [[ "$1" =~ ^-$|^-[0-9]+$|^[0-9]+$ ]]; then
    [[ "$1" =~ ^-$ ]] || delta_days=$1
  else
    echo "error"
    exit 1
  fi
fi

if [[ -n $2 ]]; then
  if [[ "$2" =~ ^[0-9]+$ ]]; then
    version_number=$2
  else
    echo "error"
    exit 1
  fi
fi

[[ -z $version_number ]] && version_number=1

if [[ -z $delta_days ]]; then
    version_string="$(date +%Y%m%d)-${version_number}"
  else

    version_string="$(date -v${delta_days}d +%Y%m%d)-${version_number}"
fi

git checkout -b release/${version_string}
