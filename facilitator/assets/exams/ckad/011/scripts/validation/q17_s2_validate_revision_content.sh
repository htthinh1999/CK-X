#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
f="/tmp/exam/course/17/revision.txt"
if [ -s "$f" ] && { grep -q "revision" "$f" 2>/dev/null || grep -q "Containers:" "$f" 2>/dev/null || grep -q "Image:" "$f" 2>/dev/null; }; then
  echo "Success: revision file contains revision details"
  exit 0
else
  echo "Error: revision file does not contain expected revision format"
  exit 1
fi
