#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/tmp/exam/course/18/endpoints.txt
if [ ! -s "$F" ]; then
  echo "Error: $F not found or empty"; exit 1
fi
# The file must list exactly the EndpointSlice's IPv4 addresses (any order, one per line)
want=$(kubectl get endpointslice external-db-slice -n tempo -o jsonpath='{range .endpoints[*]}{range .addresses[*]}{@}{"\n"}{end}{end}' 2>/dev/null | sed '/^$/d' | sort -u)
got=$(tr -d '\r' < "$F" | tr ' \t' '\n\n' | sed '/^$/d' | sort -u)
if [ -z "$want" ]; then
  echo "Error: EndpointSlice external-db-slice not found in namespace tempo"; exit 1
fi
if [ "$got" = "$want" ]; then
  echo "Success: endpoints.txt lists the addresses of external-db-slice"; exit 0
fi
echo "Error: endpoints.txt has [$(echo $got)], expected [$(echo $want)]"; exit 1
