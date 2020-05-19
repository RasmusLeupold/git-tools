#!/bin/bash

if [ $(git branch -v | grep $gone | wc -l) -eq 0 ]; then
  echo "  no [gone] branches to delete"
  exit 0
fi

git branch -v | grep "gone" | awk '{print $1}' | xargs git branch -D
