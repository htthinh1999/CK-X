#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
[ -f /tmp/exam/course/19/coredns.yaml ] && { echo "Success: coredns.yaml exists"; exit 0; }
echo "Error: /tmp/exam/course/19/coredns.yaml not found"; exit 1
