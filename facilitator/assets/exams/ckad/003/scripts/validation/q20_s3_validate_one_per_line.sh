#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/20/running-pods.txt"
if [ ! -f "$f" ]; then echo "Error: file missing"; exit 1; fi
lc=$(wc -l <"$f" 2>/dev/null)
vf=$(grep -v ' ' "$f" 2>/dev/null | wc -l)
if [ "$vf" -eq "$lc" ]; then
  echo "Success: one pod name per line"
  exit 0
else
  echo "Error: format is not one pod name per line"
  exit 1
fi
