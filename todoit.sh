#!/bin/bash
BEGIN_INDEX="\e[40;38;5;82m"
BEGIN_TASK_DONE="\e[40;38;5;82m"
BEGIN_TASK="\e[30;48;5;82m"
END_FORMAT="\e[0m"

TARGET=~/.todoit # Todo file

# Print todo list with indices
if [ "$1" == "" ]; then
  index=0
  while read line; do
    ((index++))
    case "$line" in 
      *\;done*) # Determine if this task is already marked as done
        line=${line:0:-5}
        echo -e "${BEGIN_INDEX} ${index} ${BEGIN_TASK_DONE} ${line} ${END_FORMAT}";;
      *)
        echo -e "${BEGIN_INDEX} ${index} ${BEGIN_TASK} ${line} ${END_FORMAT}";;
    esac
  done < "$TARGET"
fi

# Add task
if [ "$1" == "add" ]; then
  shift
  echo "$*" >> "$TARGET"
fi

# Mark task as done
if [ "$1" == "done" ]; then
  shift
  if [ "$1" -eq "$1" ] 2>/dev/null; then
    line=$(sed -n "${1}p" "$TARGET")
    # Determine if already marked
    case "$line" in 
      *\;done*)
        echo "Task already marked as done!";;
      *)
        sed -i "${1}c\ ${line};done" "$TARGET" # Append ;done
    esac
  else
    echo "Invalid index given!"
  fi
fi

# Delete task by index
if [ "$1" == "del" ]; then
  shift
  if [ "$1" -eq "$1" ] 2>/dev/null; then
    sed -i -e "${1}d" "$TARGET"
  else
    echo "Invalid index given!"
  fi
fi

# Clear todo file
if [ "$1" == "clear" ]; then
  > "$TARGET"
fi
