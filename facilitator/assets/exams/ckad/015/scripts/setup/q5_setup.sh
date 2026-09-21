#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace typhoon --dry-run=client -o yaml | kubectl apply -f - >/dev/null 2>&1 || true
mkdir -p /tmp/exam/course/5/storm-chart/templates
cat > /tmp/exam/course/5/storm-chart/Chart.yaml <<'EOF'
apiVersion: v2
name: storm-chart
description: A Helm chart for Kubernetes
type: application
version: 0.1.0
appVersion: "1.16.0"
EOF
cat > /tmp/exam/course/5/storm-chart/values.yaml <<'EOF'
replicaCount: 1

image:
  repository: nginx
  pullPolicy: IfNotPresent
  tag: "1.23.1"
EOF
cat > /tmp/exam/course/5/storm-chart/templates/_helpers.tpl <<'EOF'
{{- define "storm-chart.fullname" -}}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
EOF
cat > /tmp/exam/course/5/storm-chart/templates/deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "storm-chart.fullname" . }}
  labels:
    app: {{ .Chart.Name }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ .Chart.Name }}
  template:
    metadata:
      labels:
        app: {{ .Chart.Name }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
EOF
helm status storm-app -n typhoon >/dev/null 2>&1 || helm install storm-app /tmp/exam/course/5/storm-chart -n typhoon >/dev/null 2>&1 || true
echo "Setup complete for Question 5"
exit 0
