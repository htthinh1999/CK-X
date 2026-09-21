#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if [ -s "/tmp/exam/course/15/root-cause.txt" ]; then echo "Success: root cause file saved"; exit 0
else echo "Error: root cause file not found at /tmp/exam/course/15/root-cause.txt"; exit 1; fi
