#!/usr/bin/env bash

set -euo pipefail

echo Running from $(pwd)

echo "Setting the Auto-sidecar injection"
kubectl label namespace default istio-injection=enabled

echo "Building Search service"
cd search
./mvnw compile jib:dockerBuild
kubectl apply -f src/main/k8s/search.v1.yaml
cd ..

echo "Building UI service"
cd ui
./mvnw compile jib:dockerBuild
kubectl apply -f src/main/k8s/ui.v1.yaml

