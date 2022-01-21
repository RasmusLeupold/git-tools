#!/bin/bash

git remote prune origin > /dev/null

gone_branches=( $(git branch -v | sed '/^*/d' | awk '{print $3 " " $1}' | grep '^\[gone\]' | awk '{print $2 }') )

if [ ${#gone_branches[@]} -eq 0 ]; then
  echo "There is no gone branch to be deleted"
  exit 0
fi

( IFS=$'\n'; echo "${gone_branches[*]}" )

read -p $'\n'"Are you sure to delete branches listed above [y/N]: " confirm

if [[ "$confirm" =~ ^(Y|y|yes|Yes|YES)$ ]]; then
  echo ${gone_branches[@]} | sed 's/ /\n/g' | xargs git branch -D
fi
