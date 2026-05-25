# Lab 5 + 6
```
kubectl describe node node01 | grep -i taints
k taint nodes node01 spray=mortein:NoSchedule
k describe po bee | grep -i tole -A5
# Remove taint
k taint nodes controlplane node-role.kubernetes.io/control-plane-

k replace --force -f nginx.yaml
k taint node --help
k taint nodes foo dedicated:NoSchedule- 
```