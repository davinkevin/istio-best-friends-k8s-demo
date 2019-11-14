#!/usr/bin/env fish

# Create the kiali dashboard
kub port-forward service/kiali 20001:20001 -n istio-system
open http://localhost:20001/kiali/console/

# Standard
while true
    curl -qs istioandk8sbff | jq '.' -C;
    sleep 0.1
end

# With header
while true
    curl -qs istioandk8sbff -H 'version: beta' | jq '.' -C;
    sleep 0.1
end
