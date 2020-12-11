#/bin/bash

function checkout_by_search_pattern {
  git branch | grep $1 | awk '{print $1}' | xargs -n1 git checkout
  exit 0
}

function number_of_matching_branches {
  echo $(git branch | grep $1 | awk '{print $1}' | wc -l)
}

function distinct_branch {
  local number_of_matches=$1

  [ $number_of_matches -eq 0 ] && echo "There is no matching branch" && return 1
  [ $number_of_matches -gt 1 ] && echo "There is more than one matching branch" && return 1
  [ $number_of_matches -eq 1 ]
}

function branch_number_selected {
  local number_or_pattern=$1

  [ $number_or_pattern -eq $number_or_pattern ] 2>/dev/null && [ $number_or_pattern -le $i ]
}

[ -n "$1" ] && distinct_branch $(number_of_matching_branches $1) && checkout_by_search_pattern $1

branches=( $(git branch | sed '/^*/d; /^  master$/d; /^  develop$/d' | tr -d '\n') )
i=0

for branch in "${branches[@]}"; do
  ((i=i+1))
  echo "$i: $branch"
done

[ ${#branches[@]} -eq 0 ] && echo "There is no or only the current local feature branch" && exit 0

while true; do
  read -p "Put a number of a branch or a pattern to search for: " branch_number_or_search_pattern

  [ -z $branch_number_or_search_pattern ] && echo "Please make an input"

  if [ -n "$branch_number_or_search_pattern" ]; then
    branch_number_selected $branch_number_or_search_pattern && branch_index=$((branch_number_or_search_pattern-1))
    [ -n "$branch_index" ] && git checkout ${branches[$branch_index]} && exit 0

    distinct_branch $(number_of_matching_branches $branch_number_or_search_pattern) && checkout_by_search_pattern $branch_number_or_search_pattern
  fi
done
