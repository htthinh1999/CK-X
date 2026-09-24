#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"

kubectl create namespace lunar --dry-run=client -o yaml | kubectl apply -f - || true

mkdir -p /tmp/exam/course/2
cat > /tmp/exam/course/2/Dockerfile <<'EOF'
FROM golang:1.20-alpine
# Add instructions below
EOF

cat > /tmp/exam/course/2/main.go <<'EOF'
package main
import "fmt"
func main() {
    fmt.Println("Tsukuyomi server running")
}
EOF

echo "Setup complete for Question 2"
exit 0
