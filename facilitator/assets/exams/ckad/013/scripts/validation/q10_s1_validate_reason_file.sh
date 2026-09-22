#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f /tmp/exam/course/10/pending-reason.txt ]; then
  r=$(cat /tmp/exam/course/10/pending-reason.txt 2>/dev/null | tr -d '[:space:]')
  if [ "$r" = "disktype" ]; then echo "Success: reason file correct (disktype)"; exit 0; else echo "Error: reason file has $r"; exit 1; fi
else
  echo "Error: /tmp/exam/course/10/pending-reason.txt not found"
  exit 1
fi
