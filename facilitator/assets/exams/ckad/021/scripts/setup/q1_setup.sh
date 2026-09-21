#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
kubectl create namespace ward --dry-run=client -o yaml | kubectl apply -f - || true
mkdir -p /tmp/exam/course/1
cat > /tmp/exam/course/1/main.go <<'GO'
package main
import "fmt"
func main() {
    fmt.Println("Hello Dojo")
}
GO
cat > /tmp/exam/course/1/Dockerfile <<'DOCKER'
FROM golang:1.20-alpine
WORKDIR /app
COPY . .
# Add multi-stage steps
DOCKER
echo "Setup complete for Question 1"
exit 0
