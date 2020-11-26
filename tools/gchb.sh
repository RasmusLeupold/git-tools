#/bin/bash

branches=( $(git branch | sed '/^*/d; /^  master$/d; /^  develop$/d' | tr -d '\n') )
i=0

for branch in "${branches[@]}"; do
  ((i=i+1))
  echo "$i: $branch"
done

[ ${#branches[@]} -eq 0 ] && echo "There is only the current local feature branch." && exit 0

while [ -z $branch_number ] || ! [ $branch_number -eq $branch_number ] 2>/dev/null || ! [ $branch_number -le $i ]; do
  read -p "Number of the branch to switch to: " branch_number

  if [ -n $branch_number ] && ! [ $branch_number -eq $branch_number ] 2>/dev/null; then
    echo "Please put in a number between 1 and $i!"
  else
    [ $branch_number -le $i ] || echo "Please put in a number between 1 and $i!"
  fi
done

branch_index=$((branch_number-1))
git checkout ${branches[$branch_index]}
