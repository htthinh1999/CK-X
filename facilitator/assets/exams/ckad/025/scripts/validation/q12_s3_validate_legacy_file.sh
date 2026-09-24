#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/home/candidate/exam/q12/legacy-schema-pods.txt

[ -f "$F" ] || { echo "FAIL: $F not found"; exit 1; }

# strip trailing whitespace / CR and blank lines
got=$(sed -e 's/[[:space:]]*$//' "$F" | sed -e '/^$/d')
want=$(printf 'idx-andromeda\nidx-draco\nidx-eridanus')

if [ "$got" = "$want" ]; then
  echo "PASS: $F lists exactly the pods annotated catalog.observatory.io/legacy-schema"
  exit 0
fi
echo "FAIL: $F content does not match the expected sorted pod names"
echo "--- got ---"; echo "$got"
exit 1
