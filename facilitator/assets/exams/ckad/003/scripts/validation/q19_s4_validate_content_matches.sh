#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f="/tmp/exam/course/19/running-pods.txt"
if [ ! -f "$f" ]; then echo "Error: file missing"; exit 1; fi
actual=$(kubectl get pods --all-namespaces --field-selector=status.phase=Running -o jsonpath='{.items[*].metadata.name}' 2>/dev/null | tr ' ' '\n' | sort)
file_pods=$(sort "$f")
overlap=$(comm -12 <(echo "$actual") <(echo "$file_pods") | wc -l)
if [ "$overlap" -gt 0 ] 2>/dev/null; then
  echo "Success: content matches running pods ($overlap match(es))"
  exit 0
else
  echo "Error: file content does not match any running pods"
  exit 1
fi
