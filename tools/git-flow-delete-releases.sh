#!/bin/bash

if [ $(git branch | grep release/ | wc -l) -eq 0 ]; then
  echo "  no release/ branches to delete"
  exit 0
fi

git branch | grep "release/" | awk '{print $1}' | xargs git branch -d
