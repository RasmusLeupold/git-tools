#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"

bin_user_path=$HOME/bin

if ! [[ -d $bin_user_path ]]; then
  echo "''/ does not exists"
  exit 1
fi

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
    if [[ -L $bin_user_path/${file_name%.*} ]]; then
      # echo "link already exists..."
      # echo $bin_user_path/${file_name%.*}
      if [[ $(readlink $bin_user_path/${file_name%.*}) ==  $tool_script ]]; then
        echo "link for ${file_name%.*} already exists"
      else
        echo "link for ${file_name%.*} exists but point to a different file"
      fi
    else
      echo "there is da different file with the name of ${file_name%.*} in the bin directory"
    fi
  fi
done
