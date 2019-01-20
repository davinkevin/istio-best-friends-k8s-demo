#!/usr/bin/env bash

set -euo pipefail

echo Running from $(pwd)

echo "Installation of Istio"
curl -L https://git.io/getLatestIstio | sh -
kubectl apply -f istio-1.0.5/install/kubernetes/helm/istio/templates/crds.yaml
sleep 10
kubectl apply -f istio-1.0.5/install/kubernetes/istio-demo.yaml

echo "Installation of Kiali"
curl -L http://git.io/getLatestKialiKubernetes | bash
