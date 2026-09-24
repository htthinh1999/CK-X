#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f "/tmp/exam/course/6/debug-output.txt" ]; then echo "Success: file /tmp/exam/course/6/debug-output.txt exists"; exit 0; else echo "Error: file /tmp/exam/course/6/debug-output.txt not found"; exit 1; fi
