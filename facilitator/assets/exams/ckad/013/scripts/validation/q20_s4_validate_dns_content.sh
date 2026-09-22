#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f=/tmp/exam/course/20/dns-output.txt
if [ ! -f "$f" ]; then echo "Error: file not found"; exit 1; fi
ha=$(grep -ciE "address|name" "$f" 2>/dev/null || true)
if [ "$ha" -gt 0 ]; then
  echo "Success: file contains DNS resolution output"
  exit 0
else
  echo "Error: file lacks DNS output"
  exit 1
fi
