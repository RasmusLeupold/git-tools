#!/bin/bash

branches=( $(git branch | sed '/^*/d' | tr -d '\n') )

release_branches=()

for branch in "${branches[@]}"; do
  if [[ "$branch" =~ release/ ]]; then
    release_branches+=($branch)
  fi
done

if [ ${#release_branches[@]} -eq 0 ]; then
  echo "There are no release branches to be deleted."
  exit 0
fi

echo ${release_branches[@]} | sed 's/ /\n/g' | xargs git branch -d
