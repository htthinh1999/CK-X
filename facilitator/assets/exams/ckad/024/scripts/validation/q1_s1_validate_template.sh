#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# The Deployment must run the template of the last working revision:
# image nginx:1.25 AND env LIFT_MODE=tandem (revision 1 has no env var).
img=$(kubectl -n quayside get deployment crane -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
mode=$(kubectl -n quayside get deployment crane -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="LIFT_MODE")].value}' 2>/dev/null)
if [ "$img" = "nginx:1.25" ] && [ "$mode" = "tandem" ]; then
  echo "OK: crane runs nginx:1.25 with LIFT_MODE=tandem"
  exit 0
fi
echo "FAIL: image='$img' LIFT_MODE='$mode' (expected nginx:1.25 / tandem)"
exit 1
