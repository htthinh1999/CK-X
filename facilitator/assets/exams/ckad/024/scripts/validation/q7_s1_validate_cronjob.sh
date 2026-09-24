#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
j=$(kubectl -n ledger get cronjob reconcile -o json 2>/dev/null) || { echo "ERR: cronjob reconcile not found in ledger"; exit 1; }
r=$(echo "$j" | jq -r '
  (.spec.schedule | gsub("\\s+"; " ") | ltrimstr(" ") | rtrimstr(" ")) as $s
  | ([.spec.jobTemplate.spec.template.spec.containers[] | select(.name=="reconciler") | .image] | first // "none") as $img
  | "\($s)|\(.spec.successfulJobsHistoryLimit)|\(.spec.failedJobsHistoryLimit)|\(.spec.jobTemplate.spec.template.spec.restartPolicy)|\($img)"')
[ "$r" = "15 2 * * *|5|2|Never|busybox:1.36" ] && { echo "OK: schedule, history limits, restartPolicy and image are correct"; exit 0; }
echo "ERR: got schedule|successLimit|failedLimit|restartPolicy|image = '$r'"; exit 1
