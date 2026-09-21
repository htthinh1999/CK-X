#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
f=/tmp/exam/course/10/top-pods.txt
[ -f "$f" ] || { echo "Error: $f not found"; exit 1; }
lines=$(wc -l <"$f")
if [ "$lines" -ge 3 ]; then
  echo "Success: top-pods.txt has $lines lines"
  exit 0
else
  echo "Error: top-pods.txt has only $lines lines (need >= 3)"
  exit 1
fi
