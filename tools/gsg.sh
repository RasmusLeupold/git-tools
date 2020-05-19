#!/bin/bash

git remote prune origin
git branch -v | grep "gone" || echo "  no [gone] branches"
