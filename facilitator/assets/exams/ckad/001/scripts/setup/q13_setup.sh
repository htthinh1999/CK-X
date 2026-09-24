#!/bin/bash

# Setup for Question 13: Create a PersistentVolumeClaim named 'pvc-app'

# Create the storage-test namespace if it doesn't exist already
if ! kubectl get namespace storage-test &> /dev/null; then
    kubectl create namespace storage-test
fi

# Delete any existing PVC with the same name to ensure a clean state
kubectl delete pvc pvc-app -n storage-test --ignore-not-found=true

# Create the StorageClass if it doesn't exist (dependency for this question)
# if ! kubectl get storageclass fast-storage &> /dev/null; then
#     cat <<EOF | kubectl apply -f -
# apiVersion: storage.k8s.io/v1
# kind: StorageClass
# metadata:
#   name: fast-storage
# provisioner: kubernetes.io/no-provisioner
# volumeBindingMode: WaitForFirstConsumer
# EOF
#     echo "Created dependency: StorageClass 'fast-storage'"
# fi

echo "Setup complete for Question 13: Environment ready for creating PersistentVolumeClaim 'pvc-app'"
exit 0 