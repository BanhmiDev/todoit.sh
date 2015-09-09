#!/bin/bash

BEGIN_INDEX="\e[40;38;5;82m"
BEGIN_TASK="\e[30;48;5;82m"
END_FORMAT="\e[0m"

BEGIN_DONE="\033[9m"
END_DONE="\033[29m"

TARGET=~/.todoit # Todo file

# Print todo list with indices
if [ "$1" == "" ]; then
  index=0
  while read line; do
    ((index++))
    echo -e "${BEGIN_INDEX} ${index} ${BEGIN_TASK} ${line} ${END_FORMAT}"           
  done < $TARGET
fi

# Add task
if [ "$1" == "add" ]; then
  shift
  echo "$*" >> $TARGET
fi

# Delete task by index
if [ "$1" == "del" ]; then
  shift
  if [ "$1" -eq "$1" ] 2>/dev/null; then
    sed -i -e "${1}d" $TARGET
  else
    echo "Invalid index given!"
  fi
fi

# Clear todo file
if [ "$1" == "clear" ]; then
  > $TARGET
fi
