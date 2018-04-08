#!/bin/bash

for dir in 20*; do
  for question in $dir/*; do
    echo "http://adventofcode.com/$dir/day/$((10#${question##*/}))" > $question/README.md
  done
done
