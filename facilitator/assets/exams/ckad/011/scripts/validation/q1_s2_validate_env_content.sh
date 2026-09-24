#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/1/config.env"
if [ -s "$f" ] && grep -q "DB_HOST" "$f" 2>/dev/null && grep -q "DB_PORT" "$f" 2>/dev/null; then
  echo "Success: config.env has DB_HOST and DB_PORT keys"
  exit 0
else
  echo "Error: config.env missing expected keys DB_HOST/DB_PORT"
  exit 1
fi
