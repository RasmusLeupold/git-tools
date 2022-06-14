#!/bin/bash

display_error () {
  echo "ERROR: $1"
  exit 1
}

current_branch=$(git rev-parse --abbrev-ref HEAD)

[[ ! $current_branch == "develop" ]] && display_error "checkout develop first"

if [[ -n $1 ]]; then
  if [[ "$1" =~ ^-$|^[1-9][0-9]*$ ]]; then
    [[ "$1" =~ ^-$ ]] || version_number=$1
  else
    display_error "Your first argument was not a valid version number"
  fi
fi

if [[ -n $2 ]]; then
  if [[ "$2" =~ ^-[1-9][0-9]*$|^[1-9][0-9]*$ ]]; then
    [[ "$2" =~ ^-[1-9][0-9]*$ ]] && delta_days=$2 || delta_days="+$2"
  else
    display_error "Your second argument was not a valid delta of days"
  fi
fi

[[ -z $version_number ]] && version_number=1

if [[ -z $delta_days ]]; then
    version_string="$(date +%Y%m%d)-${version_number}"
  else
    version_string="$(date -v${delta_days}d +%Y%m%d)-${version_number}"
fi

git checkout -b release/${version_string}
