#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
[ -f /tmp/exam/course/20/coredns.yaml ] && { echo "Success: coredns.yaml exists"; exit 0; }
echo "Error: /tmp/exam/course/20/coredns.yaml not found"; exit 1
