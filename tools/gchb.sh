#/bin/bash

branches=( $(git branch | sed '/^*/d' | tr -d '\n') )
i=0

for branch in "${branches[@]}"; do
  echo "$(($i+1)): $branch"
  ((i=i+1))
done

[ $i -eq 0 ] && echo "There is only the current local branch." && exit 0

while [ -z $branch_number ] || ! [ $branch_number -eq $branch_number ] 2>/dev/null || ! [ $branch_number -le $i ]; do
  read -p "number of the branch: " branch_number

  if [ -n $branch_number ] && ! [ $branch_number -eq $branch_number ] 2>/dev/null; then
    echo "put in a number, plz"
  else
    [ $branch_number -le $i ] || echo "put in a number between 1 and $i, plz"
  fi
done

branch_index=$((branch_number-1))
git checkout ${branches[$branch_index]}
