#!/bin/bash

plots=( "phase" "flow" "flow2" "quadvar" "quadvareigval" "directions" )


for i in ./md/*.md
do

  filename=${i:5}
  # echo $filename
  name=${filename:8:-3}
  echo $name

  sed '2,$d' $i > tmp.md
  mv tmp.md $i

  for plot in ${plots[@]}
  do
    newline="![](../../output/$plot/$name.png)"
    echo "" >> $i
    echo $newline >> $i
  done


done
