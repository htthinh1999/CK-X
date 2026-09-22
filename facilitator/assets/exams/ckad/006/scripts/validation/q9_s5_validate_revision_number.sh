#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(cat /tmp/exam/course/9/rollback-revision.txt 2>/dev/null | tr -d '[:space:]')
if [[ "$v" =~ ^[0-9]+$ ]]; then echo "Success: file contains revision number $v"; exit 0; else echo "Error: file content '$v' is not a revision number"; exit 1; fi
