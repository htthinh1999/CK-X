#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=almanac
DIR=/home/candidate/exam/q14

kubectl create namespace "$NS" --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
rm -rf "$DIR" && mkdir -p "$DIR"

cat > "$DIR/almanac.env" <<'EOF'
# Almanac service runtime settings
# one KEY=value per line; lines starting with # are comments

SUNRISE_SOURCE=usno
TIDE_TABLE=pacific-north
MOON_PHASE_API=v2
FORECAST_WINDOW=72h
EOF

# Reset student-created objects (idempotent re-runs)
kubectl -n "$NS" delete pod almanac-reader --ignore-not-found --wait=false >/dev/null 2>&1 || true
kubectl -n "$NS" delete configmap sky-settings --ignore-not-found >/dev/null 2>&1 || true

kubectl -n "$NS" apply -f - >/dev/null 2>&1 <<'YAML' || true
apiVersion: v1
kind: ConfigMap
metadata:
  name: ephemeris-2019
  namespace: almanac
  labels:
    kind: ephemeris
    stale: "true"
data:
  epoch: "2019"
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: ephemeris-2020
  namespace: almanac
  labels:
    kind: ephemeris
    stale: "true"
data:
  epoch: "2020"
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: tide-tables-legacy
  namespace: almanac
  labels:
    kind: tides
    stale: "true"
data:
  region: pacific
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: ephemeris-2025
  namespace: almanac
  labels:
    kind: ephemeris
    stale: "false"
data:
  epoch: "2025"
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: observer-roster
  namespace: almanac
  labels:
    team: night-shift
data:
  lead: vega
YAML

echo "Setup complete for Question 14"
exit 0
