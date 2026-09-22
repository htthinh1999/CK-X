#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f /tmp/exam/course/12/crd-group.txt ]; then
  g=$(cat /tmp/exam/course/12/crd-group.txt 2>/dev/null | tr -d '[:space:]')
  if [ "$g" = "ckad.example.com" ]; then echo "Success: CRD group correct"; exit 0; else echo "Error: group is $g"; exit 1; fi
else
  echo "Error: /tmp/exam/course/12/crd-group.txt not found"
  exit 1
fi
