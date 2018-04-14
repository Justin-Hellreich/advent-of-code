#!/bin/bash

# TODO: just use spec if this gets more complicated

cleanup () {
  rm temp.txt diff.txt
  cd ../..
}

compare () {
  diff temp.txt solution.txt > diff.txt
  if [ $? -eq 0 ]; then
    echo "$((10#${question##*/})) ✓"
  else
    echo "$((10#${question##*/})) x"
    cat diff.txt
  fi
}

usage () {
  echo "This script should be run in the advent-of-code directory with no arguments"
  echo -e "\nusage: ./test.sh"
  exit 1
}

if [ $# -gt 0 ]; then
  usage
fi

if [ ! "${PWD##*/}" = "advent-of-code" ]; then
  usage
fi

for dir in 20*; do
  for question in $dir/*; do
    cd $question

    ruby $((10#${question##*/})).rb > temp.txt

    compare
    cleanup
  done
done
