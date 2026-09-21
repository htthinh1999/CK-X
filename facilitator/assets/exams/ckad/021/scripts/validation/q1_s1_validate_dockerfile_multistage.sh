#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
f="/tmp/exam/course/1/Dockerfile"
if [ -f "$f" ]; then
  from_cnt=$(grep -ci "FROM" "$f")
  if [ "$from_cnt" -ge 2 ]; then
    echo "Success: multi-stage Dockerfile ($from_cnt FROM stages)"
    exit 0
  fi
  echo "Error: Dockerfile not multi-stage ($from_cnt FROM)"
  exit 1
fi
echo "Error: $f not found"
exit 1
