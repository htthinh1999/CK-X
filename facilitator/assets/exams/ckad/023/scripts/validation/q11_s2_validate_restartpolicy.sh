#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
CTX="${KUBE_CONTEXT:+--context=$KUBE_CONTEXT}"
rp=$(kubectl $CTX -n prod get cronjob backup -o jsonpath='{.spec.jobTemplate.spec.template.spec.restartPolicy}' 2>/dev/null)
[ "$rp" = "OnFailure" ] && { echo "OK: restartPolicy OnFailure"; exit 0; }
echo "ERR: restartPolicy=$rp, expected OnFailure"; exit 1
