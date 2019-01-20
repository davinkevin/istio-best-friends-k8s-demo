#!/usr/bin/env bash

set -euo pipefail

echo Running from $(pwd)

echo "Installation of Docker credential GCR"
export VERSION=1.5.0 && export OS=linux && export ARCH=amd64
curl -qs -L "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v${VERSION}/docker-credential-gcr_${OS}_${ARCH}-${VERSION}.tar.gz" | tar zxv > docker-credential-gcr && chmod +x ./docker-credential-gcr
export PATH=$PATH:.

echo "Setting the Auto-sidecar injection"
kubectl --overwrite=true label namespace default istio-injection=enabled

echo "Building Search service"
cd search
./mvnw compile jib:build
kubectl apply -f src/main/k8s/search.v1.yaml
cd ..

echo "Building UI service"
cd ui
./mvnw compile jib:build
kubectl apply -f src/main/k8s/ui.v1.yaml

kubectl apply -f https://storage.googleapis.com/gke-release/istio/release/1.0.3-gke.0/stackdriver/stackdriver-tracing.yaml
kubectl apply -f https://storage.googleapis.com/gke-release/istio/release/1.0.3-gke.0/stackdriver/stackdriver-logs.yaml
