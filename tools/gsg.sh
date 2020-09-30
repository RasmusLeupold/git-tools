#!/bin/bash

git remote prune origin > /dev/null
git branch -v | grep "gone" || echo "  no [gone] branches"
