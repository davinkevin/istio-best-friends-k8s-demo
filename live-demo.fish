#!/usr/bin/env fish

clear
echo -s (set_color --bold 4486f6) "Λ\: " (set_color --bold cyan) '$ ' (set_color normal) "kub apply -f ui/src/main/k8s/ui.v2.mirroring.yaml"
read -p ""; clear
echo -s (set_color --bold 4486f6) "Λ\: " (set_color --bold cyan) '$ ' (set_color normal) "kub apply -f ui/src/main/k8s/ui.v2.mirroring.yaml"
kub apply -f ui/src/main/k8s/ui.v2.mirroring.yaml
read -p ""
clear

echo -s (set_color --bold 4486f6) "Λ\: " (set_color --bold cyan) '$ ' (set_color normal) "kub apply -f ui/src/main/k8s/ui.v2.canary.yaml"
read -p ""; clear
echo -s (set_color --bold 4486f6) "Λ\: " (set_color --bold cyan) '$ ' (set_color normal) "kub apply -f ui/src/main/k8s/ui.v2.canary.yaml"
kub apply -f ui/src/main/k8s/ui.v2.canary.yaml
read -p ""
clear

echo -s (set_color --bold 4486f6) "Λ\: " (set_color --bold cyan) '$ ' (set_color normal) "cat ui/src/main/k8s/ui.v2.traffic-splitting.yaml"
cat ui/src/main/k8s/ui.v2.traffic-splitting.yaml --style "changes,grid" --line-range 112:121
read -p ""; clear
echo -s (set_color --bold 4486f6) "Λ\: " (set_color --bold cyan) '$ ' (set_color normal) "kub apply -f ui/src/main/k8s/ui.v2.traffic-splitting.yaml"
read -p ""; clear
echo -s (set_color --bold 4486f6) "Λ\: " (set_color --bold cyan) '$ ' (set_color normal) "kub apply -f ui/src/main/k8s/ui.v2.traffic-splitting.yaml"
kub apply -f ui/src/main/k8s/ui.v2.traffic-splitting.yaml
read -p ""; clear

echo -s (set_color --bold 4486f6) "Λ\: " (set_color --bold cyan) '$ ' (set_color normal) "cat ui/src/main/k8s/ui.v2.traffic-splitting.yaml"
cat ui/src/main/k8s/ui.v2.traffic-splitting.yaml | sed -e "s@weight: 10@weight: 70@g" -e "s@weight: 90@weight: 30@g" | cat -l yaml --style "changes,grid" --line-range 112:121
read -p ""; clear
echo -s (set_color --bold 4486f6) "Λ\: " (set_color --bold cyan) '$ ' (set_color normal) "kub apply -f ui/src/main/k8s/ui.v2.traffic-splitting.yaml"
read -p ""; clear
echo -s (set_color --bold 4486f6) "Λ\: " (set_color --bold cyan) '$ ' (set_color normal) "kub apply -f ui/src/main/k8s/ui.v2.traffic-splitting.yaml" "kub apply -f ui/src/main/k8s/ui.v2.traffic-splitting.yaml"
cat ui/src/main/k8s/ui.v2.traffic-splitting.yaml | sed -e "s@weight: 10@weight: 70@g" -e "s@weight: 90@weight: 30@g" | kub apply -f -
