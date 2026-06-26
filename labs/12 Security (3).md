# Section 12 - Security (3) - Runtime Security & Network Isolation

## Security Contexts (6 questions)
```cmd

controlplane ~ ➜  #1

controlplane ~ ➜   k exec ubuntu-sleeper -- whoami
root

controlplane ~ ➜  #2

controlplane ~ ➜  k get pod ubuntu-sleeper -oyaml  > q2.yaml

controlplane ~ ➜  vi q2.yaml 

controlplane ~ ➜  cat q2.yaml | grep -i "securitycontext" -C2
  uid: a649594a-8456-47a9-a4f0-7e9f258d79e2
spec:
  securityContext:
    runAsUser: 1010
  containers:
--
  restartPolicy: Always
  schedulerName: default-scheduler
  securityContext: {}
  serviceAccount: default
  serviceAccountName: default

controlplane ~ ➜  k delete pod ubuntu-sleeper --force
Warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
pod "ubuntu-sleeper" force deleted from default namespace

controlplane ~ ➜  k apply -f q2.yaml 
pod/ubuntu-sleeper created

controlplane ~ ➜  k get pod --show-labels
NAME             READY   STATUS    RESTARTS   AGE   LABELS
ubuntu-sleeper   1/1     Running   0          9s    <none>

controlplane ~ ➜  vi q2.yaml 

controlplane ~ ➜  cat q2.yaml | grep -i "securitycontext" -C2
  restartPolicy: Always
  schedulerName: default-scheduler
  securityContext: 
    runAsUser: 1010
  serviceAccount: default

controlplane ~ ➜  k delete pod ubuntu-sleeper --force
Warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
pod "ubuntu-sleeper" force deleted from default namespace

controlplane ~ ➜  k apply -f q2.yaml 
pod/ubuntu-sleeper created

controlplane ~ ➜  k get pod
NAME             READY   STATUS    RESTARTS   AGE
ubuntu-sleeper   1/1     Running   0          7s

controlplane ~ ➜  #3

controlplane ~ ➜  vi multi-pod.yaml 

controlplane ~ ➜  #4

controlplane ~ ➜  vi multi-pod.yaml 

controlplane ~ ➜  #5

controlplane ~ ➜  vi multi-pod.yaml 

controlplane ~ ➜  ls
multi-pod.yaml  q2.yaml         sample.yaml

controlplane ~ ➜  vi q2.yaml 

controlplane ~ ➜  k delete pod ubuntu-sleeper --force
Warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
pod "ubuntu-sleeper" force deleted from default namespace

controlplane ~ ➜  k apply -f q2.yaml 
Error from server (BadRequest): error when creating "q2.yaml": Pod in version "v1" cannot be handled as a Pod: strict decoding error: unknown field "spec.securityContext.capabilities"

controlplane ~ ✖ vi q2.yaml 

controlplane ~ ➜  k apply -f q2.yaml 
Error from server (BadRequest): error when creating "q2.yaml": Pod in version "v1" cannot be handled as a Pod: strict decoding error: unknown field "spec.containers[0].capabilities"

controlplane ~ ✖ vi q2.yaml 

controlplane ~ ➜  k apply -f q2.yaml 
pod/ubuntu-sleeper created

controlplane ~ ➜  cat q2.yaml | grep -i "capa" -C3
    - "4800"
    image: ubuntu
    securityContext:
      capabilities:
        add: ["SYS_TIME"]
    imagePullPolicy: Always
    name: ubuntu

controlplane ~ ➜  #6

controlplane ~ ➜  vi q2.yaml 

controlplane ~ ➜  k delete pod ubuntu-sleeper --force
Warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
pod "ubuntu-sleeper" force deleted from default namespace

controlplane ~ ➜  k apply -f q2.yaml 
pod/ubuntu-sleeper created

controlplane ~ ➜  history
    1  k get pod ubuntu-sleeper -o wide
    2  k describe pod ubuntu-sleeper | grep -i "user"
    3  k describe pod ubuntu-sleeper | grep -i 'user'
    4  k describe pod ubuntu-sleeper
    5  clear
    6  #1
    7   k exec ubuntu-sleeper -- whoami
    8  #2
    9  k get pod ubuntu-sleeper -oyaml  > q2.yaml
   10  vi q2.yaml 
   11  cat q2.yaml | grep -i "securitycontext" -C2
   12  k delete pod ubuntu-sleeper --force
   13  k apply -f q2.yaml 
   14  k get pod --show-labels
   15  vi q2.yaml 
   16  cat q2.yaml | grep -i "securitycontext" -C2
   17  k delete pod ubuntu-sleeper --force
   18  k apply -f q2.yaml 
   19  k get pod
   20  #3
   21  vi multi-pod.yaml 
   22  #4
   23  vi multi-pod.yaml 
   24  #5
   25  vi multi-pod.yaml 
   26  ls
   27  vi q2.yaml 
   28  k delete pod ubuntu-sleeper --force
   29  k apply -f q2.yaml 
   30  vi q2.yaml 
   31  k apply -f q2.yaml 
   32  vi q2.yaml 
   33  k apply -f q2.yaml 
   34  cat q2.yaml | grep -i "capa" -C3
   35  #6
   36  vi q2.yaml 
   37  k delete pod ubuntu-sleeper --force
   38  k apply -f q2.yaml 
   39  history
```

## Network Policy (10 questions)
TODO Luu bai cua anh Hoan
```cmd
          Welcome to the KodeKloud Hands-On lab                                                                                                           
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                All rights reserved                                                                                                                       

controlplane ~ ➜  #1

controlplane ~ ➜  k get netpol --show-labels
NAME             POD-SELECTOR   AGE   LABELS
payroll-policy   name=payroll   96s   <none>

controlplane ~ ➜  #2

controlplane ~ ➜  #3

controlplane ~ ➜  k describe netpol payroll-policy 
Name:         payroll-policy
Namespace:    default
Created on:   2026-06-25 13:46:11 +0000 UTC
Labels:       <none>
Annotations:  <none>
Spec:
  PodSelector:     name=payroll
  Allowing ingress traffic:
    To Port: 8080/TCP
    From:
      PodSelector: name=internal
  Not affecting egress traffic
  Policy Types: Ingress

controlplane ~ ➜  #4

controlplane ~ ➜  #5

controlplane ~ ➜  #6

controlplane ~ ➜  #7

controlplane ~ ➜  #8

controlplane ~ ➜  #9

controlplane ~ ➜  vi q9.yaml

controlplane ~ ➜  k create -f q9.yaml 
Error from server (BadRequest): error when creating "q9.yaml": NetworkPolicy in version "v1" cannot be handled as a NetworkPolicy: json: cannot unmarshal object into Go struct field NetworkPolicySpec.spec.ingress of type []v1.NetworkPolicyIngressRule

controlplane ~ ✖ vi q9.yaml

controlplane ~ ➜  k create -f q9.yaml 
networkpolicy.networking.k8s.io/internal-policy created

controlplane ~ ➜  cat q9.yaml 
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: internal-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      name: internal
  policyTypes:
  - Ingress
  - Egress
  ingress:
    - {}
  egress:
  - to:
     - podSelector:
         matchLabels:
           name: payroll
    ports:
      - port: 8080
        protocol: TCP
  - to:
     - podSelector:
         matchLabels:
           name: mysql
    ports:
      - port: 3306
        protocol: TCP

  - ports:
    - protocol: TCP
      port: 53
    - protocol: UDP
      port: 53

controlplane ~ ➜  history
    1  #1
    2  k get netpol --show-labels
    3  #2
    4  #3
    5  k describe netpol payroll-policy 
    6  #4
    7  #5
    8  #6
    9  #7
   10  #8
   11  #9
   12  vi q9.yaml
   13  k create -f q9.yaml 
   14  vi q9.yaml
   15  k create -f q9.yaml 
   16  cat q9.yaml 
   17  history```