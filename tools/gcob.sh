#/bin/bash

branches=( $(git branch | sed '/^*/d; /^  master$/d; /^  develop$/d' | tr -d '\n') )
i=0

for branch in "${branches[@]}"; do
  ((i=i+1))
  echo "$i: $branch\n"
done

[ ${#branches[@]} -eq 0 ] && echo "There is no or only the current local feature branch" && exit 0

while [ -z $branch_found ]; do
  read -p "Put a number of a branch or a pattern to search for: " branch_number_or_search_pattern

  [ -z $branch_number_or_search_pattern ] && echo "Please make an input"

  if [ -n "$branch_number_or_search_pattern" ]; then
    if [ $branch_number_or_search_pattern -eq $branch_number_or_search_pattern ] 2>/dev/null; then
      if [ $branch_number_or_search_pattern -le $i ]; then
        branch_index=$((branch_number_or_search_pattern-1))
      else
        number_of_matching_branches=$(git branch | grep $branch_number_or_search_pattern | awk '{print $1}' | wc -l)
      fi
    else
      number_of_matching_branches=$(git branch | grep $branch_number_or_search_pattern | awk '{print $1}' | wc -l)
    fi
  fi

  if [ -n "$branch_index" ]; then
    branch_found=true
  else
    if [ -n "$number_of_matching_branches" ]; then
      [ $number_of_matching_branches -eq 0 ] && echo "there is no matching branch"
      [ $number_of_matching_branches -gt 1 ] && echo "there is more than one matching branch"
      [ $number_of_matching_branches -eq 1 ] && branch_search_pattern=$branch_number_or_search_pattern && branch_found=true
      number_of_matching_branches=""
    fi
  fi
done

[ -n "$branch_search_pattern" ] && git branch | grep $branch_search_pattern | awk '{print $1}' | xargs -n1 git checkout
[ -n "$branch_index" ] && git checkout ${branches[$branch_index]}
