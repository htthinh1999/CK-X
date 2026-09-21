#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
f="/tmp/exam/course/4/rendered.yaml"
if [ -f "$f" ] && [ "$(wc -l <"$f")" -gt 50 ]; then
  echo "Success: rendered.yaml has >50 lines"
  exit 0
else
  echo "Error: rendered.yaml has 50 or fewer lines"
  exit 1
fi
