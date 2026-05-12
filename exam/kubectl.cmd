#1

kubectl run nginx --image=nginx --dry-run=client -o yaml # Ko chay that
cat q1.yaml

kubectl apply -f q1.yaml
kubectl get pod

kubectl describe pod <pod-name>
kubectl describe pod <pod-name> | grep -i 'image'

kubectl get pod -o wide
kubectl get nodes

kubectl describe pod webapp | grep -i 'image'

# Luu Pod lai truoc khi delete
kubectl get pod <pod-name> -o yaml > q11_webapp.yaml
kubectl delete pod

kubectl run redis --image=redis123  --dry-run=client -o yaml > q12.yaml
kubectl apply -f q12.yaml
vi q12.yaml
# Escape
:

history

# 2
#Q1 How many PODS exist on the system
k get replicaset.apps
#Q2
#Q3
k get replicaset.apps

# Q5
k describe rs new-replica-set | grep -i 'image'
k get replicaset.apps -o wide
# Q7
k describe rs new-replica-set -o wide
k describe pod <pod-name>
# Q8
k get rs -w # Watch state
k delete po <pod-name>
# Q9
4
# Q10
k apply -f replicaset-definitions-1.yaml
cat replicaset-definitions-1.yaml
k api-resources
k api-resources | grep -i 'rs'

ls
vi replicaset-definitions-1.yaml
cat replicaset-definitions-1.yaml
vi q11.yaml
# paste content file tren vao
# doi v1 thanh apps/v1
:wq!
k apply -f q11.yaml
# Xem img.png

k delete re replicaset-2

# Q14
k get rs
k edit rs new-replica-set
# sua image busybox

k get po -o wide
k delete pod <pod-name>
# k get rs -w will reflect changes in other terminal
# Go on deleting all PODs one by one

# Q15
k edit rs new-replicaset
# Sua file bang vim :wq

# Q16
kubectl scale rs --replicas
