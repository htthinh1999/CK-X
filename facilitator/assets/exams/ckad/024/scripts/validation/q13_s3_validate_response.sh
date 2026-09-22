#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f=/home/candidate/exam/q13/response.html
[ -s "$f" ] || { echo "FAIL: $f is missing or empty"; exit 1; }
if grep -qi 'welcome to nginx' "$f"; then
  echo "OK: $f contains the nginx welcome page"
  exit 0
fi
echo "FAIL: $f does not contain the nginx welcome page"
exit 1
