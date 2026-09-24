#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace nexus --dry-run=client -o yaml | kubectl apply -f - || true

# Materialize the genesis-web helm chart under the course dir
CHART_DIR=/tmp/exam/course/16/genesis-web-chart
mkdir -p "$CHART_DIR/templates"

cat > "$CHART_DIR/Chart.yaml" <<'EOF'
apiVersion: v2
name: genesis-web
description: A Helm chart for Kubernetes
type: application
version: 0.1.0
appVersion: "1.16.0"
EOF

cat > "$CHART_DIR/values.yaml" <<'EOF'
replicaCount: 1

image:
  repository: nginx
  pullPolicy: IfNotPresent
  tag: "1.21"

service:
  type: ClusterIP
  port: 80

customLabel: "default-value"
EOF

cat > "$CHART_DIR/templates/deployment.yaml" <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "genesis-web.fullname" . }}
  labels:
    app.kubernetes.io/name: {{ include "genesis-web.name" . }}
    helm.sh/chart: {{ include "genesis-web.chart" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
    custom-label: {{ .Values.customLabel }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app.kubernetes.io/name: {{ include "genesis-web.name" . }}
      app.kubernetes.io/instance: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: {{ include "genesis-web.name" . }}
        app.kubernetes.io/instance: {{ .Release.Name }}
        custom-label: {{ .Values.customLabel }}
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

cat > "$CHART_DIR/templates/_helpers.tpl" <<'EOF'
{{- define "genesis-web.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "genesis-web.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "genesis-web.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
EOF

# Install the release with an initial custom value the student must preserve
helm status genesis-web -n nexus >/dev/null 2>&1 || \
  helm install genesis-web "$CHART_DIR" -n nexus --set customLabel="initial-install" --wait --timeout 120s 2>/dev/null || true

echo "Setup complete for Question 16"
exit 0
