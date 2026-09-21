#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
f=/tmp/exam/course/13/pod-resources.txt
if [ -s "$f" ]; then echo "Success: file has content"; exit 0; else echo "Error: file empty or missing"; exit 1; fi
