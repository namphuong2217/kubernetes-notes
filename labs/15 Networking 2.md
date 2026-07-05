# Practice Test - Service Networking (6 questions)
```cmd
controlplane ~ ➜  cat /etc/kubernetes/manifests/kube-controller-manager.yaml | grep "cidr" -C4
spec:
  containers:
  - command:
    - kube-controller-manager
    - --allocate-node-cidrs=true
    - --authentication-kubeconfig=/etc/kubernetes/controller-manager.conf
    - --authorization-kubeconfig=/etc/kubernetes/controller-manager.conf
    - --bind-address=127.0.0.1
    - --client-ca-file=/etc/kubernetes/pki/ca.crt
    - --cluster-cidr=172.17.0.0/16
    - --cluster-name=kubernetes
    - --cluster-signing-cert-file=/etc/kubernetes/pki/ca.crt
    - --cluster-signing-key-file=/etc/kubernetes/pki/ca.key
    - --controllers=*,bootstrapsigner,tokencleaner

controlplane ~ ➜  #3 What is the IP Range configured for the services within the cluster?

controlplane ~ ➜  cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep -i "service" -C5
    - --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt
    - --requestheader-extra-headers-prefix=X-Remote-Extra-
    - --requestheader-group-headers=X-Remote-Group
    - --requestheader-username-headers=X-Remote-User
    - --secure-port=6443
    - --service-account-issuer=https://kubernetes.default.svc.cluster.local
    - --service-account-key-file=/etc/kubernetes/pki/sa.pub
    - --service-account-signing-key-file=/etc/kubernetes/pki/sa.key
    - --service-cluster-ip-range=172.20.0.0/16
    - --tls-cert-file=/etc/kubernetes/pki/apiserver.crt
    - --tls-private-key-file=/etc/kubernetes/pki/apiserver.key
    image: registry.k8s.io/kube-apiserver:v1.35.0
    imagePullPolicy: IfNotPresent
    livenessProbe:

controlplane ~ ➜  #4

controlplane ~ ➜  # How many kube-proxy pods are deployed in this cluster?

controlplane ~ ➜  k get pods -A
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-54488c9c76-rcx9f   1/1     Running   0          35m
kube-system   canal-6ggsk                                2/2     Running   0          35m
kube-system   canal-c2ddj                                2/2     Running   0          35m
kube-system   coredns-6f6c7df987-8bdwf                   1/1     Running   0          35m
kube-system   coredns-6f6c7df987-v8jxd                   1/1     Running   0          35m
kube-system   etcd-controlplane                          1/1     Running   0          35m
kube-system   kube-apiserver-controlplane                1/1     Running   0          35m
kube-system   kube-controller-manager-controlplane       1/1     Running   0          35m
kube-system   kube-proxy-4xjqk                           1/1     Running   0          35m
kube-system   kube-proxy-bskrq                           1/1     Running   0          35m
kube-system   kube-scheduler-controlplane                1/1     Running   0          35m

controlplane ~ ➜  #5 What type of proxy is the kube-proxy configured to use?

controlplane ~ ➜  k logs pod kube-proxy-4xjqk
error: error from server (NotFound): pods "pod" not found in namespace "default"

controlplane ~ ✖ k logs -n kube-system kube-proxy-4xjqk
I0705 19:08:06.302910       1 server_linux.go:53] "Using iptables proxy"
I0705 19:08:06.369273       1 shared_informer.go:370] "Waiting for caches to sync"
I0705 19:08:06.469371       1 shared_informer.go:377] "Caches are synced"
I0705 19:08:06.469395       1 server.go:218] "Successfully retrieved NodeIPs" NodeIPs=["10.244.23.173"]
I0705 19:08:06.473673       1 conntrack.go:57] "Setting nf_conntrack_max" nfConntrackMax=524288
E0705 19:08:06.480198       1 server.go:255] "Kube-proxy configuration may be incomplete or incorrect" err="nodePortAddresses is unset; NodePort connections will be accepted on all local IPs. Consider using `--nodeport-addresses primary`"
I0705 19:08:06.525350       1 server.go:264] "kube-proxy running in dual-stack mode" primary ipFamily="IPv4"
I0705 19:08:06.525379       1 server_linux.go:136] "Using iptables Proxier"
I0705 19:08:06.528921       1 proxier.go:242] "Setting route_localnet=1 to allow node-ports on localhost; to change this either disable iptables.localhostNodePorts (--iptables-localhost-nodeports) or set nodePortAddresses (--nodeport-addresses) to filter loopback addresses" ipFamily="IPv4"
I0705 19:08:06.545430       1 server.go:529] "Version info" version="v1.35.0"
I0705 19:08:06.545443       1 server.go:531] "Golang settings" GOGC="" GOMAXPROCS="" GOTRACEBACK=""
I0705 19:08:06.546283       1 config.go:200] "Starting service config controller"
I0705 19:08:06.546292       1 shared_informer.go:349] "Waiting for caches to sync" controller="service config"
I0705 19:08:06.546316       1 config.go:106] "Starting endpoint slice config controller"
I0705 19:08:06.546322       1 shared_informer.go:349] "Waiting for caches to sync" controller="endpoint slice config"
I0705 19:08:06.546325       1 config.go:403] "Starting serviceCIDR config controller"
I0705 19:08:06.546328       1 shared_informer.go:349] "Waiting for caches to sync" controller="serviceCIDR config"
I0705 19:08:06.546386       1 config.go:309] "Starting node config controller"
I0705 19:08:06.546401       1 shared_informer.go:349] "Waiting for caches to sync" controller="node config"
I0705 19:08:06.546406       1 shared_informer.go:356] "Caches are synced" controller="node config"
I0705 19:08:06.647086       1 shared_informer.go:356] "Caches are synced" controller="endpoint slice config"
I0705 19:08:06.647096       1 shared_informer.go:356] "Caches are synced" controller="serviceCIDR config"
I0705 19:08:06.647110       1 shared_informer.go:356] "Caches are synced" controller="service config"

controlplane ~ ➜  #6 How does this Kubernetes cluster ensure that a kube-proxy pod runs on all nodes in the cluster?

Inspect the kube-proxy pods and try to identify how they are deployed.
-bash: Inspect: command not found

controlplane ~ ✖ k describe pod kube-proxy-4xjqk
Error from server (NotFound): pods "kube-proxy-4xjqk" not found

controlplane ~ ✖ k get pods -n kube-system -o wide
NAME                                       READY   STATUS    RESTARTS   AGE   IP              NODE           NOMINATED NODE   READINESS GATES
calico-kube-controllers-54488c9c76-rcx9f   1/1     Running   0          38m   172.17.0.4      controlplane   <none>           <none>
canal-6ggsk                                2/2     Running   0          38m   10.244.23.173   controlplane   <none>           <none>
canal-c2ddj                                2/2     Running   0          38m   10.244.83.175   node01         <none>           <none>
coredns-6f6c7df987-8bdwf                   1/1     Running   0          38m   172.17.0.2      controlplane   <none>           <none>
coredns-6f6c7df987-v8jxd                   1/1     Running   0          38m   172.17.0.3      controlplane   <none>           <none>
etcd-controlplane                          1/1     Running   0          38m   10.244.23.173   controlplane   <none>           <none>
kube-apiserver-controlplane                1/1     Running   0          38m   10.244.23.173   controlplane   <none>           <none>
kube-controller-manager-controlplane       1/1     Running   0          38m   10.244.23.173   controlplane   <none>           <none>
kube-proxy-4xjqk                           1/1     Running   0          38m   10.244.23.173   controlplane   <none>           <none>
kube-proxy-bskrq                           1/1     Running   0          38m   10.244.83.175   node01         <none>           <none>
kube-scheduler-controlplane                1/1     Running   0          38m   10.244.23.173   controlplane   <none>           <none>

controlplane ~ ➜  k get all -A
NAMESPACE     NAME                                           READY   STATUS    RESTARTS   AGE
kube-system   pod/calico-kube-controllers-54488c9c76-rcx9f   1/1     Running   0          38m
kube-system   pod/canal-6ggsk                                2/2     Running   0          38m
kube-system   pod/canal-c2ddj                                2/2     Running   0          38m
kube-system   pod/coredns-6f6c7df987-8bdwf                   1/1     Running   0          38m
kube-system   pod/coredns-6f6c7df987-v8jxd                   1/1     Running   0          38m
kube-system   pod/etcd-controlplane                          1/1     Running   0          38m
kube-system   pod/kube-apiserver-controlplane                1/1     Running   0          38m
kube-system   pod/kube-controller-manager-controlplane       1/1     Running   0          38m
kube-system   pod/kube-proxy-4xjqk                           1/1     Running   0          38m
kube-system   pod/kube-proxy-bskrq                           1/1     Running   0          38m
kube-system   pod/kube-scheduler-controlplane                1/1     Running   0          38m

NAMESPACE     NAME                 TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)                  AGE
default       service/kubernetes   ClusterIP   172.20.0.1    <none>        443/TCP                  38m
kube-system   service/kube-dns     ClusterIP   172.20.0.10   <none>        53/UDP,53/TCP,9153/TCP   38m

NAMESPACE     NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-system   daemonset.apps/canal        2         2         2       2            2           kubernetes.io/os=linux   38m
kube-system   daemonset.apps/kube-proxy   2         2         2       2            2           kubernetes.io/os=linux   38m

NAMESPACE     NAME                                      READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   deployment.apps/calico-kube-controllers   1/1     1            1           38m
kube-system   deployment.apps/coredns                   2/2     2            2           38m

NAMESPACE     NAME                                                 DESIRED   CURRENT   READY   AGE
kube-system   replicaset.apps/calico-kube-controllers-54488c9c76   1         1         1       38m
kube-system   replicaset.apps/coredns-6f6c7df987     
```
# Practice Test - CoreDNS in Kubernetes (15 questions)
```cmd
        Welcome to the KodeKloud Hands-On lab                                                                                       
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
              All rights reserved                                                                                                   

controlplane ~ ➜  #1

controlplane ~ ➜  k get pods -n kube-system 
NAME                                   READY   STATUS    RESTARTS   AGE
coredns-6f6c7df987-qm76v               1/1     Running   0          12m
coredns-6f6c7df987-zgkp8               1/1     Running   0          12m
etcd-controlplane                      1/1     Running   0          12m
kube-apiserver-controlplane            1/1     Running   0          12m
kube-controller-manager-controlplane   1/1     Running   0          12m
kube-proxy-szk9k                       1/1     Running   0          12m
kube-scheduler-controlplane            1/1     Running   0          12m

controlplane ~ ➜  #2

controlplane ~ ➜  #3

controlplane ~ ➜  k get svc -n kube-system 
NAME       TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)                  AGE
kube-dns   ClusterIP   172.20.0.10   <none>        53/UDP,53/TCP,9153/TCP   13m

controlplane ~ ➜  #4

controlplane ~ ➜  # What is the IP of the CoreDNS server that should be configured on PODs to resolve services?

controlplane ~ ➜  #5 

controlplane ~ ➜  k describe svc kube-dns
Error from server (NotFound): services "kube-dns" not found

controlplane ~ ✖ k describe svc kube-dns -n kube-system 
Name:                     kube-dns
Namespace:                kube-system
Labels:                   k8s-app=kube-dns
                          kubernetes.io/cluster-service=true
                          kubernetes.io/name=CoreDNS
Annotations:              prometheus.io/port: 9153
                          prometheus.io/scrape: true
Selector:                 k8s-app=kube-dns
Type:                     ClusterIP
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       172.20.0.10
IPs:                      172.20.0.10
Port:                     dns  53/UDP
TargetPort:               53/UDP
Endpoints:                172.17.0.2:53,172.17.0.3:53
Port:                     dns-tcp  53/TCP
TargetPort:               53/TCP
Endpoints:                172.17.0.2:53,172.17.0.3:53
Port:                     metrics  9153/TCP
TargetPort:               9153/TCP
Endpoints:                172.17.0.2:9153,172.17.0.3:9153
Session Affinity:         None
Internal Traffic Policy:  Cluster
Events:                   <none>

controlplane ~ ➜  k get deployment -n kube-system 
NAME      READY   UP-TO-DATE   AVAILABLE   AGE
coredns   2/2     2            2           29m

controlplane ~ ➜  k describe deploy coredns -n kube-system 
Name:                   coredns
Namespace:              kube-system
CreationTimestamp:      Sun, 05 Jul 2026 19:40:05 +0000
Labels:                 k8s-app=kube-dns
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               k8s-app=kube-dns
Replicas:               2 desired | 2 updated | 2 total | 2 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  1 max unavailable, 25% max surge
Pod Template:
  Labels:           k8s-app=kube-dns
  Service Account:  coredns
  Containers:
   coredns:
    Image:       registry.k8s.io/coredns/coredns:v1.10.1
    Ports:       53/UDP (dns), 53/TCP (dns-tcp), 9153/TCP (metrics), 8080/TCP (liveness-probe), 8181/TCP (readiness-probe)
    Host Ports:  0/UDP (dns), 0/TCP (dns-tcp), 0/TCP (metrics), 0/TCP (liveness-probe), 0/TCP (readiness-probe)
    Args:
      -conf
      /etc/coredns/Corefile
    Limits:
      memory:  170Mi
    Requests:
      cpu:        100m
      memory:     70Mi
    Liveness:     http-get http://:8080/health delay=60s timeout=5s period=10s #success=1 #failure=5
    Readiness:    http-get http://:8181/ready delay=0s timeout=1s period=10s #success=1 #failure=3
    Environment:  <none>
    Mounts:
      /etc/coredns from config-volume (ro)
  Volumes:
   config-volume:
    Type:               ConfigMap (a volume populated by a ConfigMap)
    Name:               coredns
    Optional:           false
  Priority Class Name:  system-cluster-critical
  Node-Selectors:       kubernetes.io/os=linux
  Tolerations:          CriticalAddonsOnly op=Exists
                        node-role.kubernetes.io/control-plane:NoSchedule
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   coredns-6f6c7df987 (2/2 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  29m   deployment-controller  Scaled up replica set coredns-6f6c7df987 from 0 to 2

controlplane ~ ➜  #6 How is the Corefile passed into the CoreDNS POD?

controlplane ~ ➜  kubectl get cm -n kube-system
NAME                                                   DATA   AGE
coredns                                                1      30m
extension-apiserver-authentication                     6      30m
kube-apiserver-legacy-service-account-token-tracking   1      30m
kube-proxy                                             2      30m
kube-root-ca.crt                                       1      30m
kubeadm-config                                         1      30m
kubelet-config                                         1      30m

controlplane ~ ➜  #7

controlplane ~ ➜  #8

controlplane ~ ➜  kubectl describe configmap coredns -n kube-system
Name:         coredns
Namespace:    kube-system
Labels:       <none>
Annotations:  <none>

Data
====
Corefile:
----
.:53 {
    errors
    health {
       lameduck 5s
    }
    ready
    kubernetes cluster.local in-addr.arpa ip6.arpa {
       pods insecure
       fallthrough in-addr.arpa ip6.arpa
       ttl 30
    }
    prometheus :9153
    forward . /etc/resolv.conf {
       max_concurrent 1000
    }
    cache 30
    loop
    reload
    loadbalance
}



BinaryData
====

Events:  <none>

controlplane ~ ➜  # What is the root domain/zone configured for this kubernetes cluster?

controlplane ~ ➜  #9

controlplane ~ ➜  k get pods
NAME                READY   STATUS    RESTARTS   AGE
hr                  1/1     Running   0          20m
simple-webapp-1     1/1     Running   0          20m
simple-webapp-122   1/1     Running   0          20m
test                1/1     Running   0          20m

controlplane ~ ➜  k exec test -- curl hr
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0curl: (6) Could not resolve host: hr
command terminated with exit code 6

controlplane ~ ✖ k get svc
NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
kubernetes     ClusterIP   172.20.0.1       <none>        443/TCP        32m
test-service   NodePort    172.20.241.229   <none>        80:30080/TCP   20m
web-service    ClusterIP   172.20.183.143   <none>        80/TCP         20m

controlplane ~ ➜  k describe svc web-service 
Name:                     web-service
Namespace:                default
Labels:                   <none>
Annotations:              <none>
Selector:                 name=hr
Type:                     ClusterIP
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       172.20.183.143
IPs:                      172.20.183.143
Port:                     <unset>  80/TCP
TargetPort:               80/TCP
Endpoints:                172.17.0.5:80
Session Affinity:         None
Internal Traffic Policy:  Cluster
Events:                   <none>

controlplane ~ ➜  #11 

controlplane ~ ➜  #12

controlplane ~ ➜  #13

controlplane ~ ➜  #14

controlplane ~ ➜  k get pods -A -owide
NAMESPACE      NAME                                   READY   STATUS    RESTARTS   AGE   IP              NODE           NOMINATED NODE   READINESS GATES
default        hr                                     1/1     Running   0          23m   172.17.0.5      controlplane   <none>           <none>
default        simple-webapp-1                        1/1     Running   0          23m   172.17.0.7      controlplane   <none>           <none>
default        simple-webapp-122                      1/1     Running   0          23m   172.17.0.8      controlplane   <none>           <none>
default        test                                   1/1     Running   0          23m   172.17.0.6      controlplane   <none>           <none>
default        webapp-57f9844586-tlwfv                1/1     Running   0          31s   172.17.0.9      controlplane   <none>           <none>
kube-flannel   kube-flannel-ds-9p7jk                  1/1     Running   0          35m   10.244.23.150   controlplane   <none>           <none>
kube-system    coredns-6f6c7df987-qm76v               1/1     Running   0          35m   172.17.0.3      controlplane   <none>           <none>
kube-system    coredns-6f6c7df987-zgkp8               1/1     Running   0          35m   172.17.0.2      controlplane   <none>           <none>
kube-system    etcd-controlplane                      1/1     Running   0          35m   10.244.23.150   controlplane   <none>           <none>
kube-system    kube-apiserver-controlplane            1/1     Running   0          35m   10.244.23.150   controlplane   <none>           <none>
kube-system    kube-controller-manager-controlplane   1/1     Running   0          35m   10.244.23.150   controlplane   <none>           <none>
kube-system    kube-proxy-szk9k                       1/1     Running   0          35m   10.244.23.150   controlplane   <none>           <none>
kube-system    kube-scheduler-controlplane            1/1     Running   0          35m   10.244.23.150   controlplane   <none>           <none>
payroll        mysql                                  1/1     Running   0          31s   172.17.0.10     controlplane   <none>           <none>
payroll        web                                    1/1     Running   0          23m   172.17.0.4      controlplane   <none>           <none>

controlplane ~ ➜  k edit deploy webapp 
deployment.apps/webapp edited

controlplane ~ ➜  #15

controlplane ~ ➜  k exec -it hr -- nsloopkup mysql.payroll > /root/CKA/nslookup.out
E0705 20:17:49.217504   36329 runtime.go:142] "Observed a panic" panic="runtime error: invalid memory address or nil pointer dereference" panicGoValue="\"invalid memory address or nil pointer dereference\"" stacktrace=<
                                                                                                goroutine 119 [running]:
                                                                                                                                k8s.io/apimachinery/pkg/util/runtime.logPanic({0x289ca38, 0x3c0f0a0}, {0x2008260, 0x3bb6560})
                                                                                                        k8s.io/apimachinery/pkg/util/runtime/runtime.go:132 +0xbc
                                k8s.io/apimachinery/pkg/util/runtime.handleCrash({0x289ca38, 0x3c0f0a0}, {0x2008260, 0x3bb6560}, {0xc0000c3da8, 0x0, 0x0?})
                                        k8s.io/apimachinery/pkg/util/runtime/runtime.go:107 +0x116
                                                                                                        k8s.io/apimachinery/pkg/util/runtime.HandleCrash({0x0, 0x0, 0xc000003c00?})
                                                                k8s.io/apimachinery/pkg/util/runtime/runtime.go:64 +0x17b
                                                                                                                                panic({0x2008260?, 0x3bb6560?})
                                        runtime/panic.go:783 +0x132
                                                                        k8s.io/kubectl/pkg/cmd/exec.(*terminalSizeQueueAdapter).Next(0x0?)
                        k8s.io/kubectl/pkg/cmd/exec/exec.go:414 +0x15
                                                                        k8s.io/client-go/tools/remotecommand.(*streamProtocolV3).handleResizes.func1()
                                k8s.io/client-go/tools/remotecommand/v3.go:74 +0xac
                                                                                        created by k8s.io/client-go/tools/remotecommand.(*streamProtocolV3).handleResizes in goroutine 116
                                                                        k8s.io/client-go/tools/remotecommand/v3.go:69 +0x65
                                                                                                                            >
                                                                                                                             panic: runtime error: invalid memory address or nil pointer dereference [recovered, repanicked]
                                                                                          [signal SIGSEGV: segmentation violation code=0x1 addr=0x18 pc=0x1bfd355]

                                goroutine 119 [running]:
                                                        k8s.io/apimachinery/pkg/util/runtime.handleCrash({0x289ca38, 0x3c0f0a0}, {0x2008260, 0x3bb6560}, {0xc00090bda8, 0x0, 0x0?})
                                                        k8s.io/apimachinery/pkg/util/runtime/runtime.go:114 +0x1a9
                                                                                                                  k8s.io/apimachinery/pkg/util/runtime.HandleCrash({0x0, 0x0, 0xc000003c00?})
                                                                k8s.io/apimachinery/pkg/util/runtime/runtime.go:64 +0x17b
                                                                                                                         panic({0x2008260?, 0x3bb6560?})
                        runtime/panic.go:783 +0x132
                                                   k8s.io/kubectl/pkg/cmd/exec.(*terminalSizeQueueAdapter).Next(0x0?)
                                                                                                                        k8s.io/kubectl/pkg/cmd/exec/exec.go:414 +0x15
                                   k8s.io/client-go/tools/remotecommand.(*streamProtocolV3).handleResizes.func1()
                                                                                                                        k8s.io/client-go/tools/remotecommand/v3.go:74 +0xac
                                         created by k8s.io/client-go/tools/remotecommand.(*streamProtocolV3).handleResizes in goroutine 116
                k8s.io/client-go/tools/remotecommand/v3.go:69 +0x65

                                                                   controlplane ~ ✖ 
```
# Practice Test - CKA Ingress Networking - 1 (23 questions)
# Practice Test - CKA Ingress Networking - 2 (9 questions)
# Practice Test - Gateway API (2025 Updates) (8 questions)