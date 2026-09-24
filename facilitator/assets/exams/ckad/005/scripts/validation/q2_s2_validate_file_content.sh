#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
f=/tmp/exam/course/2/pod-spec-fields.txt
if [ -f "$f" ] && grep -qi "resources\|limits\|requests" "$f"; then echo "Success: file contains resources documentation"; exit 0; else echo "Error: file missing resources documentation"; exit 1; fi
