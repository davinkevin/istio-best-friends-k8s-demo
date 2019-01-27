#!/usr/bin/env fish

# Create the kiali dashboard
kub port-forward service/kiali 20001:20001 -n istio-system

# Standard
while true
    curl -qs istioandk8sbff | jq '.' -C;
    sleep 0.4
end

# With header
while true
    curl -qs istioandk8sbff -H 'version: beta' | jq '.' -C;
    sleep 0.1
end
