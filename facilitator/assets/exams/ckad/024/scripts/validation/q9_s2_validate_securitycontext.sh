#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
j=$(kubectl -n ledger get cronjob reconcile -o json 2>/dev/null) || { echo "ERR: cronjob reconcile not found in ledger"; exit 1; }
# effective values: container-level settings override pod-level ones
r=$(echo "$j" | jq -r '
  .spec.jobTemplate.spec.template.spec as $p
  | ($p.containers[] | select(.name=="reconciler")) as $c
  | [ (if $c.securityContext.runAsUser != null then $c.securityContext.runAsUser else $p.securityContext.runAsUser end),
      (if $c.securityContext.runAsNonRoot != null then $c.securityContext.runAsNonRoot else $p.securityContext.runAsNonRoot end),
      $c.securityContext.readOnlyRootFilesystem ]
  | map(tostring) | join(",")' | head -n1)
[ "$r" = "2500,true,true" ] && { echo "OK: runAsUser=2500 runAsNonRoot=true readOnlyRootFilesystem=true"; exit 0; }
echo "ERR: runAsUser,runAsNonRoot,readOnlyRootFilesystem = '${r:-<no reconciler container>}' (want 2500,true,true)"; exit 1
