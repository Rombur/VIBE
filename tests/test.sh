#!/bin/bash

cd /scratch
test_ids=( 1 2 3 6 7 10 ) 
for i in "${test_ids[@]}"
do
  echo "case ${i}"
  case="case${i}"
  case_input="case${i}_input"
  case_launch="./case${i}_launch"

  # Run the test
  cp -a ${case_input} ${case} && cd ${case} && ${case_launch}

  # Compare the solution
  diff TemperatureAverage.txt /opt/vibe/examples/${case}/work/battery_state/TemperatureAverage.txt > diff.txt
  cd ../
  if [ -s "${case}/diff.txt" ]
  then
    echo "ERROR"
    cp ${case}/diff.txt diff_${i}.txt
  fi

  # Delete the directory that has been created
  rm -r ${case}
done
