#!/bin/bash

cd /scratch
test_ids=( 1 2 3 6 10 ) 
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

# Case 7 is particular because we run two tests in the same directory. We need
# to clean the directory after case 7 4P

case="case7"
case_launch="./case7_launch"

case_input="case7p_input"
echo "case 7 4P"

# Run the test
cp -a ${case_input} ${case} && cd ${case} && ${case_launch}

# Compare the solution
diff TemperatureAverage.txt /opt/vibe/examples/${case}/work/battery_state/TemperatureAverage.txt > diff.txt
cd ../
if [ -s "${case}/diff.txt" ]
then
  echo "ERROR"
  cp ${case}/diff.txt diff_7_4P.txt
fi

# Delete the directory that has been created
rm -r ${case}

# Clean the directory before 4S
cd /opt/vibe/examples/case7
rm batsim.conf *.log checklist.conf resource_usage RESULT
rm -rf simulation_log simulation_results simulation_setup work
cd /scratch


echo "case 7 4S"
case_input="case7s_input"

# Run the test
cp -a ${case_input} ${case} && cd ${case} && ${case_launch}

# Compare the solution
diff TemperatureAverage.txt /opt/vibe/examples/${case}/work/battery_state/TemperatureAverage.txt > diff.txt
cd ../
if [ -s "${case}/diff.txt" ]
then
  echo "ERROR"
  cp ${case}/diff.txt diff_7_4S.txt
fi

# Delete the directory that has been created
rm -r ${case}
