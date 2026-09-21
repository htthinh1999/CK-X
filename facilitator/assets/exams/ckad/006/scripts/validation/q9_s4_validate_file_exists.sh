#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if [ -f "/tmp/exam/course/9/rollback-revision.txt" ]; then echo "Success: rollback-revision.txt exists"; exit 0; else echo "Error: /tmp/exam/course/9/rollback-revision.txt not found"; exit 1; fi
