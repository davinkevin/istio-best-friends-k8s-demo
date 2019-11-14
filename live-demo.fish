#!/usr/bin/env fish

function print_with_prompt
      echo -s (set_color --bold 4486f6) "Λ\: " (set_color --bold cyan) '$ ' (set_color normal) $argv
end

function wait_and_clear
      sleep 1; clear;
end

function press_to_go
      read -p ""; clear;
end

kub apply -f ui/src/main/k8s/ui.v1.yaml > /dev/null
clear

# Mirroring
print_with_prompt "kub apply -f ui/src/main/k8s/ui.v2.mirroring.yaml"
press_to_go
print_with_prompt "kub apply -f ui/src/main/k8s/ui.v2.mirroring.yaml"
kub apply -f ui/src/main/k8s/ui.v2.mirroring.yaml
wait_and_clear
print_with_prompt "cat ui/src/main/k8s/ui.v2.mirroring.yaml"
cat ui/src/main/k8s/ui.v2.mirroring.yaml --style "changes,grid" --line-range 112:119
press_to_go

# Canary
print_with_prompt "kub apply -f ui/src/main/k8s/ui.v2.canary.yaml"
press_to_go
print_with_prompt "kub apply -f ui/src/main/k8s/ui.v2.canary.yaml"
kub apply -f ui/src/main/k8s/ui.v2.canary.yaml
wait_and_clear
print_with_prompt "cat ui/src/main/k8s/ui.v2.canary.yaml"
cat ui/src/main/k8s/ui.v2.canary.yaml --style "changes,grid" --line-range 112:124
press_to_go

# Traffic Splitting
print_with_prompt "kub apply -f ui/src/main/k8s/ui.v2.traffic-splitting.yaml"
press_to_go
print_with_prompt "kub apply -f ui/src/main/k8s/ui.v2.traffic-splitting.yaml"
kub apply -f ui/src/main/k8s/ui.v2.traffic-splitting.yaml
wait_and_clear

print_with_prompt "cat ui/src/main/k8s/ui.v2.traffic-splitting.yaml"
cat ui/src/main/k8s/ui.v2.traffic-splitting.yaml --style "changes,grid" --line-range 112:121
press_to_go

print_with_prompt "cat ui/src/main/k8s/ui.v2.traffic-splitting_70_30.yaml"
cat ui/src/main/k8s/ui.v2.traffic-splitting.yaml | sed -e "s@weight: 10@weight: 70@g" -e "s@weight: 90@weight: 30@g" | cat -l yaml --style "changes,grid" --line-range 112:121
press_to_go
print_with_prompt "kub apply -f ui/src/main/k8s/ui.v2.traffic-splitting_70_30.yaml"
cat ui/src/main/k8s/ui.v2.traffic-splitting.yaml | sed -e "s@weight: 10@weight: 70@g" -e "s@weight: 90@weight: 30@g" | kub apply -f -
