#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"

user_bin_path=$HOME/bin

if ! [[ -d $user_bin_path ]]; then
  echo "'$user_bin_path/' does not exists"
  exit 1
fi

echo $PATH | grep $user_bin_path > /dev/null

if ! [[ $? -eq 0 ]]; then
  echo "'$user_bin_path' is not in your PATH variable"
  echo "ERROR: installation failed"
  exit 1
fi

for tool_script in $(find $(pwd)/tools -name '*.sh'); do
  command_str=$(echo $(basename $tool_script) | cut -d . -f 1)

  ln -s $tool_script $user_bin_path/$command_str 2> /dev/null

  if ! [[ $? -eq 0 ]]; then
    if [[ -L $user_bin_path/$command_str ]]; then
      if [[ $(readlink $user_bin_path/$command_str) ==  $tool_script ]]; then
        echo "link for '$command_str' already exists"
      else
        echo "link for '$command_str' already exists, but point to a different file"
      fi
    else
      echo "there is da different file with the same name of '$command_str' in the '$user_bin_path/' directory"
    fi
  else
    echo "link for '$command_str' created"
  fi
done
