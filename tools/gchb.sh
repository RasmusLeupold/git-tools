#/bin/bash

branches=( $(git branch | sed '/^*/d' | tr -d '\n') )
i=1

for branch in "${branches[@]}"; do
  echo "$i: $branch"
  ((i=i+1))
done

if [ $i -eq 1 ]; then
  echo "There is only the current local branch."
  exit 0
fi

((i=i-1))

while [ -z $branch_number ] || ! [ $branch_number -eq $branch_number ] 2>/dev/null || ! [ $branch_number -le $i ]; do
  read -p "number of the branch: " branch_number

  if [ -n $branch_number ] && ! [ $branch_number -eq $branch_number ] 2>/dev/null; then
    echo "put in a number, plz"
  else
    [ $branch_number -le $i ] || echo "put in a number between 1 and $i, plz"
  fi
done

((branch_number=branch_number-1))

git checkout ${branches[$branch_number]}
