#/bin/bash

if [ $# -ne 1 ]; then
  git branch
  exit 0
fi

brach_name=$1

number_of_branches=$(git branch | grep $brach_name | awk '{print $1}' | wc -l)

if [ $number_of_branches -gt 1 ]; then
  echo "  [more] then one branch matches"
  echo ""
  echo "  which one are you looking for:"

  git branch | grep $brach_name
  exit 0
fi

if [ $number_of_branches -eq 0 ]; then
    echo "  [could not] find a matching branch"
    echo ""
    echo "  current local branches:"

    git branch
    exit 0
fi

git branch | grep $brach_name | awk '{print $1}' | xargs -n1 git checkout
