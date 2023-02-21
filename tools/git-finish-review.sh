#/bin/bash

has_one_matching_branch() {
  local search_term=$1

  count=$(git branch | grep $search_term | wc -l)

  [[ $count -lt 1 ]] && echo "No branch found" && return 1
  [[ $count -gt 1 ]] && echo "More then one branch found" && return 1

  return 0
}

get_branch_name() {
  local search_term=$1
  echo $(git branch | grep $search_term)
}

search_term=$1

[[ -z $search_term ]] && echo "No branch selects to swich to" && exit 1

has_one_matching_branch $search_term || exit 1

review_barch=$(git rev-parse --abbrev-ref HEAD)
git checkout $(get_branch_name $search_term)
git branch -D $review_barch

