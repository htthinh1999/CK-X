#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f=/tmp/exam/course/1/pod-spec-fields.txt
if [ -f "$f" ]; then echo "Success: $f exists"; exit 0; else echo "Error: $f not found"; exit 1; fi
