#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if grep -q "data" "/tmp/exam/course/6/debug-output.txt" 2>/dev/null || grep -q "total" "/tmp/exam/course/6/debug-output.txt" 2>/dev/null; then echo "Success: output contains listing"; exit 0; else echo "Error: output contains listing - not found"; exit 1; fi
