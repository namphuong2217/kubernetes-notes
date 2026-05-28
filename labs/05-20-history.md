
## 6.1 DaemonSets
```
controlplane ~ ➜  history
1  k get ds -a
2  k get ds -A
3  k get ds --help
4  #1 above
5  #2
6  k get ds -A -o wide
7  k describe ds kube-proxy -n kube-system
8  #4
9  #5
10  k describe ds kube-flannel-ds
11  k describe ds kube-flannel-ds -n kube-flannel
12  k describe ds kube-flannel-ds -n kube-flannel | grep -i image
13  k describe ds kube-flannel-ds -n kube-flannel | grep -i image -A5
14  #6
15  k create ds elasticsearch -n kube-system --image=registry.k8s.io/fluentd-elasticsearch:1.20
16  k create ds --help
17  k create deployment elasticsarch -n kube-system -oyaml q6.yaml
18  k create deployment elasticsarch --image=registry.k8s.io/fluentd-elasticsearch:1.20 -n kube-system -oyaml > q6.yaml
19  vi q6.yaml
20  k apply -f q6.yaml
21  vi q6.yaml
22  k create pod elasticsarch --image=registry.k8s.io/fluentd-elasticsearch:1.20 -n kube-system -oyaml > q6.yaml
23  k run elasticsarch --image=registry.k8s.io/fluentd-elasticsearch:1.20 -n kube-system -oyaml > q6-1.yaml
24  vi q6-
25  vi q6-1.yaml
26  k apply -f q6-1.yaml
27  kpg
28  k api-resources | grep -i Daemon
29  k api-resources | grep -i Daemon -A7
30  vi q6-1.yaml
31  k apply -f q6-1.yaml
32  k create deployment elasticsearch --image=registry.k8s.io/fluentd-elasticsearch:1.20 -n kube-system -oyaml > fluentd.yaml
33  vi fluentd.yaml
34  k apply -f fluentd.yaml
35  vi fluentd.yaml
36  kubectl create deployment elasticsearch
37  --image=registry.k8s.io/fluentd-elasticsearch:1.20
38  -n kube-system --dry-run=client -o yaml > fluentd2.yaml
39  kubectl create deployment elasticsearch --image=registry.k8s.io/fluentd-elasticsearch:1.20 -n kube-system --dry-run=client -o yaml > fluentd2.yaml
40  vi fluentd2.yaml
41  k create -f fluentd2.yaml
42  history
 ```
# 5 History
```
# Manual Scheduling
controlplane ~ ➜  history
    1  lg 
    2  ls
    3  #1
    4  \
    5  k apply -f nginx.yaml
    6  #2
    7  k get po -A
    8  #3
    9  k describe po nginx | grep -i "event" -A9
   10  k describe po nginx 
   11  k get nodes
   12  #4
   13  vi nginx.yaml 
   14  k apply --force -f nginx.yaml 
   15  k replace --force -f nginx.yaml 
   16  #5
   17  vi nginx.yaml 
   18  k replace --force -f nginx.yaml 
   19  vi nginx.yaml 
   20  history
   
# Selectors
controlplane ~ ➜  history
    1  #1
    2  k get po --env=dev
    3  k get ns 
    4  k get labels
    5  k get po -o wide
    6  k get po --selector env=dev
    7  k get po --selector env=dev --no-headers | wc -l 
    8  #2
    9  k get po --selector bu=finance --no-headers | wc -l 
   10  #3
   11  k get all --selector env=prod --no-headers | wc -l
   12  k get all --selector env=prod
   13  #4
   14  k get po --selector env=prod,bu=finance,tier=frontend
   15  #5
   16  k apply -f replicaset-definition-1.yaml 
   17  vi replicaset-definition-1.yaml 
   18  k apply -f replicaset-definition-1.yaml 
   19  k get rs
   20  history
   
 # Taints and Tolerations
 controlplane ~ ➜  history
    1  k get nodes
    2  clear
    3  #1
    4  k get nodes
    5  k get nodes -A
    6  #2
    7  k describe nodes node01
    8  #3
    9  k taint nodes node01 spray=mortein:NoSchedule
   10  #4
   11  k run mosquito --image=nginx
   12  #5
   13  k get pod mosquito 
   14  #6
   15  k describe po mosquito 
   16  #7
   17  k run be --image=nginx --dry-run=client -oyaml q7.yaml
   18  vi q7.yaml
   19  k create be --image=nginx --dry-run=client -oyaml q7.yaml
   20  k run be --image=nginx --dry-run=client -o yaml > q7.yaml
   21  vi q7.yaml 
   22  cat q7.yaml 
   23  k apply -f q7.yaml 
   24  vi q7.yaml 
   25  k apply -f q7.yaml 
   26  cat q7.yaml 
   27  vi q7.yaml 
   28  k apply -f q7.yaml 
   29  #8
   30  k get po bee
   31  k get po bee -o wide
   32  #9
   33  k decribe node controlplane
   34  k describe node controlplane
   35  k describe node controlplane | grep -i taint -a9
   36  k taint nodes controlplane node-role.kubernetes.io/control-plane-
   37  k describe node controlplane | grep -i taint -a9
   38  #11
   39  k get po mosquito 
   40  #12
   41  k get po mosquito -o wide
   42  history

# Node affinity
controlplane ~ ✦2 ➜  history
    1  k describe node node01 | grep -i "labels" -A5
    2  #1 
    3  #2
    4  #3
    5  k label node nod01 color=blue
    6  k label node node01 color=blue
    7  k label --help
    8  k label --help | grep -i "Node" A9
    9  k label --help | grep -i "Node" -A9
   10  #4
   11  k create deploy blue --image=nginx --replicas=3
   12  #5
   13  k get nodes
   14  k describe controlplane | grep -i "Taints" -A9
   15  k describe node controlplane | grep -i "Taints" -A9
   16  k describe node node01 | grep -i "Taints" -A9
   17  #6
   18  k edit node01
   19  k edit node node01
   20  k edit deployments.apps 
   21  k label node node01 color=blue
   22  k label node node01 color=red
   23  k get po 
   24  cat deployment blue
   25  k edit deploy blue -o yaml > q6.yaml
   26  k get pods -o wide
   27  #7
   28  #8
   29  k create deployment red --image=nginx --replicas=2 dry-run=client -o yaml > q8.yaml
   30  k create deployment red --image=nginx --replicas=2 --dry-run=client -o yaml > q8.yaml
   31  vi q8.yaml 
   32  cat q8.yaml 
   33  k apply -f q8.yaml 
   34  vi q8.yaml 
   35  cat q8.yaml 
   36  k apply -f q8.yaml 
   37  vi q8.yaml 
   38  k apply -f q8.yaml 
   39  rm q8
   40  rm q8.yaml 
   41  ls
   42  k create deployment red --image=nginx --replicas=2 --dry-run=client -o yaml > q8.yaml
   43  vi q8.yaml 
   44  rm q8.yaml.swap
   45  ls -A
   46  rm .q8.yaml.swp 
   47  vi q8.yaml 
   48  cat q8.yaml 
   49  k apply -f q8.yaml 
   50  history
   
# Resource limits
controlplane ~ ➜  history
    1  k describe po rabbit
    2  k delete po rabbit 
    3  #1 + 2
    4  #3
    5  k describe po elephant 
    6  #4
    7  ls
    8  k edit pod elephant 
    9  k edit pod elephant 
   10  k replace --force -f /tmp/kubectl-edit-1654243837.yaml
   11  #6
   12  k get pod -o wide
   13  k delet po el
   14  k delete po elephant 
   15  history
```