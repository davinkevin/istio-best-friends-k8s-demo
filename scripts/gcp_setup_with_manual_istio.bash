#!/usr/bin/env bash

set -euo pipefail

echo Running from $(pwd)

# Create the cluster with this command
# gcloud beta container --project "istio-csm" clusters create "istio-k8s-bff" --zone "us-central1-a" --username "admin" --cluster-version "1.12.7-gke.10" --machine-type "n1-standard-2" --image-type "COS" --disk-type "pd-standard" --disk-size "100" --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "3" --enable-stackdriver-kubernetes --no-enable-ip-alias --network "projects/istio-csm/global/networks/default" --subnetwork "projects/istio-csm/regions/us-central1/subnetworks/default" --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade --enable-autorepair
# And connect to it
# gcloud container clusters get-credentials istio-k8s-bff --zone us-central1-a --project istio-csm
echo "Use my personal mail"
# gcloud config set account foo.bar@gmail.com
echo "create a role for my user in the cluster"
kubectl create clusterrolebinding cluster-admin-binding \
                  --clusterrole=cluster-admin \
                  --user=(gcloud config get-value core/account)

curl -L https://git.io/getLatestIstio | sh -
ls istio-1.1.7/install/kubernetes/helm/istio-init/files/crd*yaml | xargs -n1 -P 1 -I  @ kubectl apply -f @
sleep 5
kubectl apply -f istio-1.1.0/install/kubernetes/istio-demo.yaml

echo "Installation of Docker credential GCR"
export VERSION=1.5.0 && export OS=darwin && export ARCH=amd64
curl -qs -L "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v${VERSION}/docker-credential-gcr_${OS}_${ARCH}-${VERSION}.tar.gz" | tar zxv > docker-credential-gcr && chmod +x ./docker-credential-gcr
export PATH=$PATH:.

echo "Setting the Auto-sidecar injection"
kubectl --overwrite=true label namespace default istio-injection=enabled


kubectl apply -f search/src/main/k8s/search.v1.yaml
kubectl apply -f ui/src/main/k8s/ui.v1.yaml
