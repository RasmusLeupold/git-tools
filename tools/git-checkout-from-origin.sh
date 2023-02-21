#!/bin/bash

has_one_matching_branch() {
  local search_term=$1

  count=$(git branch --remote | grep $search_term | wc -l)

  [[ $count -lt 1 ]] && echo "No branch found" && return 1
  [[ $count -gt 1 ]] && echo "More then one branch found" && return 1

  return 0
}

get_remote_branch_name() {
  local search_term=$1
  local remote_branch_name=$(git branch --remote | grep $search_term)

  echo $(echo $remote_branch_name | sed -E "s|origin/||")
}

search_term=$1

[[ -z $search_term ]] && echo "No search term provided" && exit 1

has_one_matching_branch $search_term || exit 1

git checkout $(get_remote_branch_name $search_term)
