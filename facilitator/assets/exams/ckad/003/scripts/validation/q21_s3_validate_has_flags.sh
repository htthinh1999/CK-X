#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
f="/tmp/exam/course/21/drain-command.sh"
if [ ! -f "$f" ]; then echo "Error: file missing"; exit 1; fi
c=$(cat "$f")
ok=true
echo "$c" | grep -q "ignore-daemonsets" || ok=false
if ! echo "$c" | grep -q "delete-emptydir-data\|delete-local-data"; then ok=false; fi
echo "$c" | grep -q "force" || ok=false
if [ "$ok" = true ]; then
  echo "Success: required flags present"
  exit 0
else
  echo "Error: missing required drain flags"
  exit 1
fi
