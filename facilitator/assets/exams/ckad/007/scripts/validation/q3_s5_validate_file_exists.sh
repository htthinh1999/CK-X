#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if [ -f "/tmp/exam/course/3/patch-commands.sh" ]; then echo "Success: file /tmp/exam/course/3/patch-commands.sh exists"; exit 0; else echo "Error: file /tmp/exam/course/3/patch-commands.sh not found"; exit 1; fi
