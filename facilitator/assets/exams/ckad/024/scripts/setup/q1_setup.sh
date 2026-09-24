#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl create namespace tides --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true

rm -rf /home/candidate/exam/q1 && mkdir -p /home/candidate/exam/q1
cat > /home/candidate/exam/q1/gauge.properties <<'EOF'
station.id=WG-17
sample.interval.seconds=30
tide.datum=LAT
alert.high.water.cm=520
EOF

# start clean: the student creates this one
kubectl -n tides delete configmap gauge-config --ignore-not-found >/dev/null 2>&1 || true

kubectl apply -f - <<'YAML' || true
apiVersion: v1
kind: ConfigMap
metadata:
  name: tide-north
  namespace: tides
  labels:
    tier: gauge
    region: north
data:
  station.id: NG-02
  sample.interval.seconds: "60"
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: tide-south
  namespace: tides
  labels:
    tier: gauge
    region: south
    status: active
data:
  station.id: SG-09
  sample.interval.seconds: "30"
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: tide-east
  namespace: tides
  labels:
    tier: gauge
    region: east
    status: retired
data:
  station.id: EG-01
  sample.interval.seconds: "120"
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: tide-mouth
  namespace: tides
  labels:
    tier: gauge
    region: south
    status: standby
data:
  station.id: MG-04
  sample.interval.seconds: "30"
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: tide-archive
  namespace: tides
  labels:
    tier: gauge-archive
    region: north
data:
  retention.days: "365"
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: berth-planner
  namespace: tides
  labels:
    tier: planner
    region: west
data:
  berths: "12"
YAML

echo "Setup complete for Question 1"
exit 0
