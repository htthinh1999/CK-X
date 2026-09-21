#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
f="/tmp/exam/course/7/password.txt"
if [ -f "$f" ] && [ "$(cat "$f")" = "FirePhoenix2024!" ]; then
  echo "Success: password content correct"
  exit 0
else
  echo "Error: password.txt content incorrect"
  exit 1
fi
