#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/20/response.txt"
if [ -f "$f" ] && { grep -iq "method" "$f" || grep -iq "path" "$f" || grep -iq "headers" "$f"; }; then
  echo "Success: response contains expected echo output"; exit 0
fi
echo "Error: response.txt does not contain method/path/headers"; exit 1
