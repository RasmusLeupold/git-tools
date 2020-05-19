#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"

bin_user_path=$HOME/bin
echo $PATH | grep $bin_user_path > /dev/null

if ! [[ $? -eq 0 ]]; then
  echo "'$bin_user_path' is not in your PATH variable"
  echo "ERROR: installation failed"
  exit 1
fi

for tool_script in $(find $(pwd)/tools -name '*.sh'); do
  file_name=$(basename $tool_script)

  ln -s $tool_script $bin_user_path/${file_name%.*} 2> /dev/null

  if ! [[ $? -eq 0 ]]; then
    echo "the file/link '${file_name%.*}' already existis in '$bin_user_path'"
  fi
done
