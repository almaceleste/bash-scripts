#!/bin/bash
# arglist-run.sh
# Invoke arglist.sh script with several variants to display difference

dir="$(dirname $0)"

read -r -d '' prompt << EOM
┌──────────────────────────
│ arglist-run.sh
│ Invoke arglist.sh script with several variants to display difference
│ Run arglist.sh arg1 arg2 arg3 or choose variants from list below:
│   1: test1 test2 test3
│   2: test 1 test 2 test 3
│   3: "test 1" "test 2" "test 3"
│   4: 'test 1' 'test 2' 'test 3'
│ please, choose 1, 2, 3 or 4:
EOM
while true; do
  read -p "$prompt " answer
  case $answer in
    1 ) "$dir/arglist.sh" test1 test2 test3; break;;
    2 ) "$dir/arglist.sh" test 1 test 2 test 3; break;;
    3 ) "$dir/arglist.sh" "test 1" "test 2" "test 3"; break;;
    4 ) "$dir/arglist.sh" 'test 1' 'test 2' 'test 3'; break;;
    * ) echo "│ ⚠️  variant '$answer' does not exist. good bye"; exit;;
  esac
done