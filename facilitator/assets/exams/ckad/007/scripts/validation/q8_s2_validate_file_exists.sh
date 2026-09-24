#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f "/tmp/exam/course/8/endpoints-info.txt" ]; then echo "Success: file /tmp/exam/course/8/endpoints-info.txt exists"; exit 0; else echo "Error: file /tmp/exam/course/8/endpoints-info.txt not found"; exit 1; fi
