#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/home/candidate/exam/q1/active-gauges.txt
[ -f "$F" ] || { echo "ERR: $F not found"; exit 1; }
exp=$(kubectl -n tides get configmaps -l 'tier=gauge,status!=retired' \
  -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' 2>/dev/null | sed '/^$/d' | LC_ALL=C sort)
echo "$exp" | grep -qx "gauge-config" || { echo "ERR: gauge-config does not match tier=gauge,status!=retired yet"; exit 1; }
got=$(sed 's/^[[:space:]]*//; s/[[:space:]]*$//' "$F" | sed '/^$/d')
[ "$got" = "$exp" ] && { echo "OK: file lists the $(echo "$exp" | wc -l) matching ConfigMaps, sorted"; exit 0; }
echo "ERR: file content mismatch. expected:"; echo "$exp"; echo "got:"; echo "$got"; exit 1
