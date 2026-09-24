#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -s "/tmp/exam/course/8/endpoints-info.txt" ]; then echo "Success: file /tmp/exam/course/8/endpoints-info.txt has content"; exit 0; else echo "Error: file /tmp/exam/course/8/endpoints-info.txt is empty or missing"; exit 1; fi
