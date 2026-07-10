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
```cmd
          Welcome to the KodeKloud Hands-On lab                                                                                                                                           
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                   All rights reserved                                                                                                                                                      

controlplane ~ ➜  #1

controlplane ~ ➜  k get ns
NAME              STATUS   AGE
app-space         Active   55s
default           Active   6m57s
ingress-nginx     Active   54s
kube-flannel      Active   6m54s
kube-node-lease   Active   6m57s
kube-public       Active   6m57s
kube-system       Active   6m57s

controlplane ~ ➜  k get pods -n ingress-nginx 
NAME                                        READY   STATUS      RESTARTS   AGE
ingress-nginx-admission-create-ttkrt        0/1     Completed   0          60s
ingress-nginx-admission-patch-2twk4         0/1     Completed   0          60s
ingress-nginx-controller-7677dff578-7vwvl   1/1     Running     0          60s

controlplane ~ ➜  k get deploy
No resources found in default namespace.

controlplane ~ ➜  k get deploy -A
NAMESPACE       NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
app-space       default-backend            1/1     1            1           75s
app-space       webapp-video               1/1     1            1           75s
app-space       webapp-wear                1/1     1            1           76s
ingress-nginx   ingress-nginx-controller   1/1     1            1           75s
kube-system     coredns                    2/2     2            2           7m16s

controlplane ~ ➜  k get pods -A
NAMESPACE       NAME                                        READY   STATUS      RESTARTS   AGE
app-space       default-backend-68fd4d68f-5l97c             1/1     Running     0          93s
app-space       webapp-video-68cff9d6fc-5bb4k               1/1     Running     0          93s
app-space       webapp-wear-7759c9f9d4-wpmlz                1/1     Running     0          94s
ingress-nginx   ingress-nginx-admission-create-ttkrt        0/1     Completed   0          93s
ingress-nginx   ingress-nginx-admission-patch-2twk4         0/1     Completed   0          93s
ingress-nginx   ingress-nginx-controller-7677dff578-7vwvl   1/1     Running     0          93s
kube-flannel    kube-flannel-ds-4jwq6                       1/1     Running     0          7m27s
kube-system     coredns-6f6c7df987-tl5tv                    1/1     Running     0          7m27s
kube-system     coredns-6f6c7df987-wdtbm                    1/1     Running     0          7m27s
kube-system     etcd-controlplane                           1/1     Running     0          7m34s
kube-system     kube-apiserver-controlplane                 1/1     Running     0          7m34s
kube-system     kube-controller-manager-controlplane        1/1     Running     0          7m34s
kube-system     kube-proxy-gs8w6                            1/1     Running     0          7m27s
kube-system     kube-scheduler-controlplane                 1/1     Running     0          7m34s

controlplane ~ ➜  #2

controlplane ~ ➜  #3,4,5

controlplane ~ ➜  kubectl get ingress --all-namespaces
NAMESPACE   NAME                 CLASS    HOSTS   ADDRESS         PORTS   AGE
app-space   ingress-wear-watch   <none>   *       172.20.67.168   80      4m50s

controlplane ~ ➜  k api-resources ingress
error: unexpected arguments: [ingress]
See 'kubectl api-resources -h' for help and examples

controlplane ~ ✖ k api-resources | grep -i "ingress"
ingressclasses                                   networking.k8s.io/v1              false        IngressClass
ingresses                           ing          networking.k8s.io/v1              true         Ingress

controlplane ~ ➜  #6

controlplane ~ ➜  #7

controlplane ~ ➜  #8

controlplane ~ ➜  k describe ingress -n app-space ingress-wear-watch 
Name:             ingress-wear-watch
Labels:           <none>
Namespace:        app-space
Address:          172.20.67.168
Ingress Class:    <none>
Default backend:  <default>
Rules:
  Host        Path  Backends
  ----        ----  --------
  *           
              /wear    wear-service:8080 (172.17.0.4:8080)
              /watch   video-service:8080 (172.17.0.5:8080)
Annotations:  nginx.ingress.kubernetes.io/rewrite-target: /
              nginx.ingress.kubernetes.io/ssl-redirect: false
Events:
  Type    Reason  Age                    From                      Message
  ----    ------  ----                   ----                      -------
  Normal  Sync    6m17s (x2 over 6m17s)  nginx-ingress-controller  Scheduled for sync

controlplane ~ ➜  #9, 10, 

controlplane ~ ➜  k get deploy -n ingress-nginx ingress-nginx-controller -oyaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "1"
  creationTimestamp: "2026-07-10T08:47:20Z"
  generation: 1
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
    app.kubernetes.io/version: 1.1.2
    helm.sh/chart: ingress-nginx-4.0.18
  name: ingress-nginx-controller
  namespace: ingress-nginx
  resourceVersion: "1151"
  uid: 3178ac05-6d98-418a-985c-092ba3ec69dc
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app.kubernetes.io/component: controller
      app.kubernetes.io/instance: ingress-nginx
      app.kubernetes.io/name: ingress-nginx
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        app.kubernetes.io/component: controller
        app.kubernetes.io/instance: ingress-nginx
        app.kubernetes.io/name: ingress-nginx
    spec:
      containers:
      - args:
        - /nginx-ingress-controller
        - --publish-service=$(POD_NAMESPACE)/ingress-nginx-controller
        - --election-id=ingress-controller-leader
        - --watch-ingress-without-class=true
        - --default-backend-service=app-space/default-backend-service
        - --controller-class=k8s.io/ingress-nginx
        - --ingress-class=nginx
        - --configmap=$(POD_NAMESPACE)/ingress-nginx-controller
        - --validating-webhook=:8443
        - --validating-webhook-certificate=/usr/local/certificates/cert
        - --validating-webhook-key=/usr/local/certificates/key
        env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
        - name: LD_PRELOAD
          value: /usr/local/lib/libmimalloc.so
        image: registry.k8s.io/ingress-nginx/controller:v1.1.2@sha256:28b11ce69e57843de44e3db6413e98d09de0f6688e33d4bd384002a44f78405c
        imagePullPolicy: IfNotPresent
        lifecycle:
          preStop:
            exec:
              command:
              - /wait-shutdown
        livenessProbe:
          failureThreshold: 5
          httpGet:
            path: /healthz
            port: 10254
            scheme: HTTP
          initialDelaySeconds: 10
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 1
        name: controller
        ports:
        - containerPort: 80
          name: http
          protocol: TCP
        - containerPort: 443
          name: https
          protocol: TCP
        - containerPort: 8443
          name: webhook
          protocol: TCP
        readinessProbe:
          failureThreshold: 3
          httpGet:
            path: /healthz
            port: 10254
            scheme: HTTP
          initialDelaySeconds: 10
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 1
        resources:
          requests:
            cpu: 100m
            memory: 90Mi
        securityContext:
          allowPrivilegeEscalation: true
          capabilities:
            add:
            - NET_BIND_SERVICE
            drop:
            - ALL
          runAsUser: 101
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /usr/local/certificates/
          name: webhook-cert
          readOnly: true
      dnsPolicy: ClusterFirst
      nodeSelector:
        kubernetes.io/os: linux
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      serviceAccount: ingress-nginx
      serviceAccountName: ingress-nginx
      terminationGracePeriodSeconds: 300
      volumes:
      - name: webhook-cert
        secret:
          defaultMode: 420
          secretName: ingress-nginx-admission
status:
  availableReplicas: 1
  conditions:
  - lastTransitionTime: "2026-07-10T08:48:11Z"
    lastUpdateTime: "2026-07-10T08:48:11Z"
    message: Deployment has minimum availability.
    reason: MinimumReplicasAvailable
    status: "True"
    type: Available
  - lastTransitionTime: "2026-07-10T08:47:20Z"
    lastUpdateTime: "2026-07-10T08:48:11Z"
    message: ReplicaSet "ingress-nginx-controller-7677dff578" has successfully progressed.
    reason: NewReplicaSetAvailable
    status: "True"
    type: Progressing
  observedGeneration: 1
  readyReplicas: 1
  replicas: 1
  terminatingReplicas: 0
  updatedReplicas: 1

controlplane ~ ➜  
           Welcome to the KodeKloud Hands-On lab                                                                                                                                       
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                   All rights reserved                                                                                                                                                 

controlplane ~ ➜  history
    1  history

controlplane ~ ➜  vi q22.yaml

controlplane ~ ✖ vi 22.yaml

controlplane ~ ➜  k create ingress -h
Create an ingress with the specified name.

Aliases:
ingress, ing

Examples:
  # Create a single ingress called 'simple' that directs requests to foo.com/bar to svc
  # svc1:8080 with a TLS secret "my-cert"
  kubectl create ingress simple --rule="foo.com/bar=svc1:8080,tls=my-cert"
  
  # Create a catch all ingress of "/path" pointing to service svc:port and Ingress Class as "otheringress"
  kubectl create ingress catch-all --class=otheringress --rule="/path=svc:port"
  
  # Create an ingress with two annotations: ingress.annotation1 and ingress.annotations2
  kubectl create ingress annotated --class=default --rule="foo.com/bar=svc:port" \
  --annotation ingress.annotation1=foo \
  --annotation ingress.annotation2=bla
  
  # Create an ingress with the same host and multiple paths
  kubectl create ingress multipath --class=default \
  --rule="foo.com/=svc:port" \
  --rule="foo.com/admin/=svcadmin:portadmin"
  
  # Create an ingress with multiple hosts and the pathType as Prefix
  kubectl create ingress ingress1 --class=default \
  --rule="foo.com/path*=svc:8080" \
  --rule="bar.com/admin*=svc2:http"
  
  # Create an ingress with TLS enabled using the default ingress certificate and different path types
  kubectl create ingress ingtls --class=default \
  --rule="foo.com/=svc:https,tls" \
  --rule="foo.com/path/subpath*=othersvc:8080"
  
  # Create an ingress with TLS enabled using a specific secret and pathType as Prefix
  kubectl create ingress ingsecret --class=default \
  --rule="foo.com/*=svc:8080,tls=secret1"
  
  # Create an ingress with a default backend
  kubectl create ingress ingdefault --class=default \
  --default-backend=defaultsvc:http \
  --rule="foo.com/*=svc:8080,tls=secret1"

Options:
    --allow-missing-template-keys=true:
        If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to
        golang and jsonpath output formats.

    --annotation=[]:
        Annotation to insert in the ingress object, in the format annotation=value

    --class='':
        Ingress Class to be used

    --default-backend='':
        Default service for backend, in format of svcname:port

    --dry-run='none':
        Must be "none", "server", or "client". If client strategy, only print the object that would be sent, without
        sending it. If server strategy, submit server-side request without persisting the resource.

    --field-manager='kubectl-create':
        Name of the manager used to track field ownership.

    -o, --output='':
        Output format. One of: (json, yaml, kyaml, name, go-template, go-template-file, template, templatefile,
        jsonpath, jsonpath-as-json, jsonpath-file).

    --rule=[]:
        Rule in format host/path=service:port[,tls=secretname]. Paths containing the leading character '*' are
        considered pathType=Prefix. tls argument is optional.

    --save-config=false:
        If true, the configuration of current object will be saved in its annotation. Otherwise, the annotation will
        be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.

    --show-managed-fields=false:
        If true, keep the managedFields when printing objects in JSON or YAML format.

    --template='':
        Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format
        is golang templates [http://golang.org/pkg/text/template/#pkg-overview].

    --validate='strict':
        Must be one of: strict (or true), warn, ignore (or false). "true" or "strict" will use a schema to validate
        the input and fail the request if invalid. It will perform server side validation if ServerSideFieldValidation
        is enabled on the api-server, but will fall back to less reliable client-side validation if not. "warn" will
        warn about unknown or duplicate fields without blocking the request if server-side field validation is enabled
        on the API server, and behave as "ignore" otherwise. "false" or "ignore" will not perform any schema
        validation, silently dropping any unknown or duplicate fields.

Usage:
  kubectl create ingress NAME --rule=host/path=service:port[,tls[=secret]]  [options]

Use "kubectl options" for a list of global command-line options (applies to all commands).

controlplane ~ ➜  k create ingress -h | grep -i "rewrite" -C5

controlplane ~ ✖  kubectl create ingress annotated --class=default --rule="foo.com/bar=svc:port" \
  --annotation ingress.annotation1=foo \
  --annotation ingress.annotation2=bl --dry-run=client -oyaml > template.yaml

controlplane ~ ➜  vi template.yaml 

controlplane ~ ➜  vi 22.yaml 

controlplane ~ ➜  vi template.yaml 

controlplane ~ ➜  vi 22.yaml 

controlplane ~ ➜  k create -f 22.yaml 
ingress.networking.k8s.io/critical-ingress created

controlplane ~ ➜  k get ingress -A
NAMESPACE        NAME                 CLASS    HOSTS   ADDRESS         PORTS   AGE
app-space        ingress-wear-watch   <none>   *       172.20.67.168   80      36m
critical-space   critical-ingress     <none>   *                       80      4s

controlplane ~ ➜  cat 22.yaml 
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: critical-ingress 
  namespace: critical-space
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - http:
      paths:
      - pathType: Prefix
        path: /pay
        backend:
          service:
            name: pay-service
            port:
              number: 8282


controlplane ~ ➜  #23

controlplane ~ ➜  history
    1  history
    2  vi q22.yaml
    3  vi 22.yaml
    4  k create ingress -h
    5  k create ingress -h | grep -i "rewrite" -C5
    6  vi template.yaml 
    7  vi 22.yaml 
    8  vi template.yaml 
    9  vi 22.yaml 
   10  k create -f 22.yaml 
   11  k get ingress -A
   12  cat 22.yaml 
   13  #23
   14  history
```
# Practice Test - CKA Ingress Networking - 2 (9 questions)
```cmd
           Welcome to the KodeKloud Hands-On lab                                                                                                                                           
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                   All rights reserved                                                                                                                                                      

controlplane ~ ➜  #1 

controlplane ~ ➜  kubectl -n webapp get svc
NAME              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
default-backend   ClusterIP   172.20.208.69   <none>        80/TCP    6m50s
web-app           ClusterIP   172.20.75.158   <none>        80/TCP    6m50s

controlplane ~ ➜  kubectl -n webapp get secrets
NAME      TYPE                DATA   AGE
app-tls   kubernetes.io/tls   2      6m56s

controlplane ~ ➜  kubectl -n ingress-nginx get deploy
NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
ingress-nginx-controller   1/1     1            1           7m

controlplane ~ ➜  #2

controlplane ~ ➜  k create ingress -h
Create an ingress with the specified name.

Aliases:
ingress, ing

Examples:
  # Create a single ingress called 'simple' that directs requests to foo.com/bar to svc
  # svc1:8080 with a TLS secret "my-cert"
  kubectl create ingress simple --rule="foo.com/bar=svc1:8080,tls=my-cert"
  
  # Create a catch all ingress of "/path" pointing to service svc:port and Ingress Class as "otheringress"
  kubectl create ingress catch-all --class=otheringress --rule="/path=svc:port"
  
  # Create an ingress with two annotations: ingress.annotation1 and ingress.annotations2
  kubectl create ingress annotated --class=default --rule="foo.com/bar=svc:port" \
  --annotation ingress.annotation1=foo \
  --annotation ingress.annotation2=bla
  
  # Create an ingress with the same host and multiple paths
  kubectl create ingress multipath --class=default \
  --rule="foo.com/=svc:port" \
  --rule="foo.com/admin/=svcadmin:portadmin"
  
  # Create an ingress with multiple hosts and the pathType as Prefix
  kubectl create ingress ingress1 --class=default \
  --rule="foo.com/path*=svc:8080" \
  --rule="bar.com/admin*=svc2:http"
  
  # Create an ingress with TLS enabled using the default ingress certificate and different path types
  kubectl create ingress ingtls --class=default \
  --rule="foo.com/=svc:https,tls" \
  --rule="foo.com/path/subpath*=othersvc:8080"
  
  # Create an ingress with TLS enabled using a specific secret and pathType as Prefix
  kubectl create ingress ingsecret --class=default \
  --rule="foo.com/*=svc:8080,tls=secret1"
  
  # Create an ingress with a default backend
  kubectl create ingress ingdefault --class=default \
  --default-backend=defaultsvc:http \
  --rule="foo.com/*=svc:8080,tls=secret1"

Options:
    --allow-missing-template-keys=true:
        If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to
        golang and jsonpath output formats.

    --annotation=[]:
        Annotation to insert in the ingress object, in the format annotation=value

    --class='':
        Ingress Class to be used

    --default-backend='':
        Default service for backend, in format of svcname:port

    --dry-run='none':
        Must be "none", "server", or "client". If client strategy, only print the object that would be sent, without
        sending it. If server strategy, submit server-side request without persisting the resource.

    --field-manager='kubectl-create':
        Name of the manager used to track field ownership.

    -o, --output='':
        Output format. One of: (json, yaml, kyaml, name, go-template, go-template-file, template, templatefile,
        jsonpath, jsonpath-as-json, jsonpath-file).

    --rule=[]:
        Rule in format host/path=service:port[,tls=secretname]. Paths containing the leading character '*' are
        considered pathType=Prefix. tls argument is optional.

    --save-config=false:
        If true, the configuration of current object will be saved in its annotation. Otherwise, the annotation will
        be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.

    --show-managed-fields=false:
        If true, keep the managedFields when printing objects in JSON or YAML format.

    --template='':
        Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format
        is golang templates [http://golang.org/pkg/text/template/#pkg-overview].

    --validate='strict':
        Must be one of: strict (or true), warn, ignore (or false). "true" or "strict" will use a schema to validate
        the input and fail the request if invalid. It will perform server side validation if ServerSideFieldValidation
        is enabled on the api-server, but will fall back to less reliable client-side validation if not. "warn" will
        warn about unknown or duplicate fields without blocking the request if server-side field validation is enabled
        on the API server, and behave as "ignore" otherwise. "false" or "ignore" will not perform any schema
        validation, silently dropping any unknown or duplicate fields.

Usage:
  kubectl create ingress NAME --rule=host/path=service:port[,tls[=secret]]  [options]

Use "kubectl options" for a list of global command-line options (applies to all commands).

controlplane ~ ➜  kubectl create -n webapp web-app-ingress --rule="app.kodekloud.local/=web-app:80" --dry-run=client -oyaml > q2.yaml
error: unknown flag: --rule
See 'kubectl create --help' for usage.

controlplane ~ ✖ kubectl create -n webapp ingress web-app-ingress --rule="app.kodekloud.local/=web-app:80" --dry-run=client -oyaml > q2.yaml

controlplane ~ ➜  vi q2.yaml 

controlplane ~ ➜  k create -f q2.yaml 
ingress.networking.k8s.io/web-app-ingress created

controlplane ~ ➜  k get ingress -A
NAMESPACE   NAME              CLASS   HOSTS                 ADDRESS   PORTS   AGE
webapp      web-app-ingress   nginx   app.kodekloud.local             80      4s

controlplane ~ ➜  cat q2.yaml 
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-app-ingress
  namespace: webapp
spec:
  ingressClassName: nginx
  rules:
  - host: app.kodekloud.local
    http:
      paths:
      - backend:
          service:
            name: web-app
            port:
              number: 80
        path: /
        pathType: Prefix
status:
  loadBalancer: {}

controlplane ~ ➜  # In the webapp namespace, create an Ingress resource named web-app-ingress. Configure it to route traffic for the host app.kodekloud.local with path / (pathType: Prefix) to the existing web-app Service on port 80.


Use apiVersion: networking.k8s.io/v1 and set ingressClassName: nginx.
The Ingress Controller is already deployed - you only need to create the Ingress resource.
-bash: Use: command not found
-bash: The: command not found

controlplane ~ ✖ #3

controlplane ~ ✖ vi q2.yaml 

controlplane ~ ➜  vi q2.yaml 

controlplane ~ ➜  k apply -f q2.yaml 
Warning: resource ingresses/web-app-ingress is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
ingress.networking.k8s.io/web-app-ingress configured

controlplane ~ ➜  k edit ingress -n webapp web-app-ingress 
Edit cancelled, no changes made.

controlplane ~ ➜  #4

controlplane ~ ➜  k edit ingress -n webapp web-app-ingress 
ingress.networking.k8s.io/web-app-ingress edited

controlplane ~ ➜  k edit ingress -n webapp web-app-ingress 
Edit cancelled, no changes made.

controlplane ~ ➜  kubectl annotate ingress web-app-ingress -n webapp nginx.ingress.kubernetes.io/ssl-redirect="true"
ingress.networking.k8s.io/web-app-ingress annotated

controlplane ~ ➜  #5

controlplane ~ ➜  kubectl -n webapp get ingress
NAME              CLASS   HOSTS                 ADDRESS         PORTS     AGE
web-app-ingress   nginx   app.kodekloud.local   172.20.57.172   80, 443   5m49s

controlplane ~ ➜  kubectl -n webapp describe ingress web-app-ingress
Name:             web-app-ingress
Labels:           <none>
Namespace:        webapp
Address:          172.20.57.172
Ingress Class:    nginx
Default backend:  <default>
TLS:
  app-tls terminates app.kodekloud.local
Rules:
  Host                 Path  Backends
  ----                 ----  --------
  app.kodekloud.local  
                       /   web-app:80 (172.17.0.4:80)
Annotations:           nginx.ingress.kubernetes.io/ssl-redirect: true
Events:
  Type    Reason  Age               From                      Message
  ----    ------  ----              ----                      -------
  Normal  Sync    63s (x4 over 6m)  nginx-ingress-controller  Scheduled for sync

controlplane ~ ➜  curl -Lk https://app.kodekloud.local
Welcome to the secure web app!

controlplane ~ ➜  # curl: The command-line tool to transfer data from or to a server.
-L: Tells curl to follow redirects if the server responds with a redirect status.
-k: Allows insecure SSL connections, meaning it ignores certificate validation errors (useful for self-signed certs).
https://app.kodekloud.local: The URL you're accessing, which is secured with HTTPS.
-bash: -L:: command not found
-bash: syntax error near unexpected token `('
> ^C

controlplane ~ ✖ history
    1  #1 
    2  kubectl -n webapp get svc
    3  kubectl -n webapp get secrets
    4  kubectl -n ingress-nginx get deploy
    5  #2
    6  k create ingress -h
    7  kubectl create -n webapp web-app-ingress --rule="app.kodekloud.local/=web-app:80" --dry-run=client -oyaml > q2.yaml
    8  kubectl create -n webapp ingress web-app-ingress --rule="app.kodekloud.local/=web-app:80" --dry-run=client -oyaml > q2.yaml
    9  vi q2.yaml 
   10  k create -f q2.yaml 
   11  k get ingress -A
   12  cat q2.yaml 
   13  # In the webapp namespace, create an Ingress resource named web-app-ingress. Configure it to route traffic for the host app.kodekloud.local with path / (pathType: Prefix) to the existing web-app Service on port 80.
   14  Use apiVersion: networking.k8s.io/v1 and set ingressClassName: nginx.
   15  The Ingress Controller is already deployed - you only need to create the Ingress resource.
   16  #3
   17  vi q2.yaml 
   18  k apply -f q2.yaml 
   19  k edit ingress -n webapp web-app-ingress 
   20  #4
   21  k edit ingress -n webapp web-app-ingress 
   22  kubectl annotate ingress web-app-ingress -n webapp nginx.ingress.kubernetes.io/ssl-redirect="true"
   23  #5
   24  kubectl -n webapp get ingress
   25  kubectl -n webapp describe ingress web-app-ingress
   26  curl -Lk https://app.kodekloud.local
   27  # curl: The command-line tool to transfer data from or to a server.
   28  -L: Tells curl to follow redirects if the server responds with a redirect status.
   29  -k: Allows insecure SSL connections, meaning it ignores certificate validation errors (useful for self-signed certs).
   30  https://app.kodekloud.local: The URL you're accessing, which is secured with HTTPS.
   31  history

```
# Practice Test - Gateway API (2025 Updates) (8 questions)
```cmd
            Welcome to the KodeKloud Hands-On lab                                                                                                                                           
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                   All rights reserved                                                                                                                                                      

controlplane ~ ➜  #1 Which API resource is used to define a Gateway in Kubernetes?

controlplane ~ ➜  #2 What is the purpose of the allowedRoutes field in a Gateway?

controlplane ~ ➜  #3, 4, 5

controlplane ~ ➜  kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v1.5.1" | kubectl apply -f -
customresourcedefinition.apiextensions.k8s.io/gatewayclasses.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/gateways.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/grpcroutes.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/httproutes.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/referencegrants.gateway.networking.k8s.io created

controlplane ~ ➜  kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v1.6.1/deploy/crds.yaml
customresourcedefinition.apiextensions.k8s.io/clientsettingspolicies.gateway.nginx.org created
customresourcedefinition.apiextensions.k8s.io/nginxgateways.gateway.nginx.org created
customresourcedefinition.apiextensions.k8s.io/nginxproxies.gateway.nginx.org created
customresourcedefinition.apiextensions.k8s.io/observabilitypolicies.gateway.nginx.org created
customresourcedefinition.apiextensions.k8s.io/snippetsfilters.gateway.nginx.org created
customresourcedefinition.apiextensions.k8s.io/upstreamsettingspolicies.gateway.nginx.org created

controlplane ~ ➜  kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v1.6.1/deploy/nodeport/deploy.yaml
namespace/nginx-gateway created
serviceaccount/nginx-gateway created
clusterrole.rbac.authorization.k8s.io/nginx-gateway created
clusterrolebinding.rbac.authorization.k8s.io/nginx-gateway created
configmap/nginx-includes-bootstrap created
service/nginx-gateway created
deployment.apps/nginx-gateway created
gatewayclass.gateway.networking.k8s.io/nginx created
nginxgateway.gateway.nginx.org/nginx-gateway-config created

controlplane ~ ➜  kubectl get pods -n nginx-gateway
NAME                             READY   STATUS    RESTARTS   AGE
nginx-gateway-685ffdcf84-l82ns   2/2     Running   0          13s

controlplane ~ ➜  kubectl get svc -n nginx-gateway nginx-gateway -o yaml
apiVersion: v1
kind: Service
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"labels":{"app.kubernetes.io/instance":"nginx-gateway","app.kubernetes.io/name":"nginx-gateway","app.kubernetes.io/version":"1.6.1"},"name":"nginx-gateway","namespace":"nginx-gateway"},"spec":{"externalTrafficPolicy":"Local","ports":[{"name":"http","port":80,"protocol":"TCP","targetPort":80},{"name":"https","port":443,"protocol":"TCP","targetPort":443}],"selector":{"app.kubernetes.io/instance":"nginx-gateway","app.kubernetes.io/name":"nginx-gateway"},"type":"NodePort"}}
  creationTimestamp: "2026-07-10T09:51:00Z"
  labels:
    app.kubernetes.io/instance: nginx-gateway
    app.kubernetes.io/name: nginx-gateway
    app.kubernetes.io/version: 1.6.1
  name: nginx-gateway
  namespace: nginx-gateway
  resourceVersion: "1422"
  uid: 8bf18c7e-8878-44fb-8c19-5d762ca7f6a8
spec:
  clusterIP: 172.20.8.111
  clusterIPs:
  - 172.20.8.111
  externalTrafficPolicy: Local
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - name: http
    nodePort: 30318
    port: 80
    protocol: TCP
    targetPort: 80
  - name: https
    nodePort: 31190
    port: 443
    protocol: TCP
    targetPort: 443
  selector:
    app.kubernetes.io/instance: nginx-gateway
    app.kubernetes.io/name: nginx-gateway
  sessionAffinity: None
  type: NodePort
status:
  loadBalancer: {}

controlplane ~ ➜  kubectl patch svc nginx-gateway -n nginx-gateway --type='json' -p='[
  {"op": "replace", "path": "/spec/ports/0/nodePort", "value": 30080},
  {"op": "replace", "path": "/spec/ports/1/nodePort", "value": 30081}
]'
service/nginx-gateway patched

controlplane ~ ➜  kubectl get svc -n nginx-gateway nginx-gateway -o yaml
apiVersion: v1
kind: Service
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"labels":{"app.kubernetes.io/instance":"nginx-gateway","app.kubernetes.io/name":"nginx-gateway","app.kubernetes.io/version":"1.6.1"},"name":"nginx-gateway","namespace":"nginx-gateway"},"spec":{"externalTrafficPolicy":"Local","ports":[{"name":"http","port":80,"protocol":"TCP","targetPort":80},{"name":"https","port":443,"protocol":"TCP","targetPort":443}],"selector":{"app.kubernetes.io/instance":"nginx-gateway","app.kubernetes.io/name":"nginx-gateway"},"type":"NodePort"}}
  creationTimestamp: "2026-07-10T09:51:00Z"
  labels:
    app.kubernetes.io/instance: nginx-gateway
    app.kubernetes.io/name: nginx-gateway
    app.kubernetes.io/version: 1.6.1
  name: nginx-gateway
  namespace: nginx-gateway
  resourceVersion: "1628"
  uid: 8bf18c7e-8878-44fb-8c19-5d762ca7f6a8
spec:
  clusterIP: 172.20.8.111
  clusterIPs:
  - 172.20.8.111
  externalTrafficPolicy: Local
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - name: http
    nodePort: 30080
    port: 80
    protocol: TCP
    targetPort: 80
  - name: https
    nodePort: 30081
    port: 443
    protocol: TCP
    targetPort: 443
  selector:
    app.kubernetes.io/instance: nginx-gateway
    app.kubernetes.io/name: nginx-gateway
  sessionAffinity: None
  type: NodePort
status:
  loadBalancer: {}

controlplane ~ ➜  vi 7.yaml

controlplane ~ ➜  k create -f 7.yaml 
gateway.gateway.networking.k8s.io/nginx-gateway created

controlplane ~ ➜  vi 7.yaml

controlplane ~ ➜  cat 7.yaml 
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: nginx-gateway
  namespace: nginx-gateway
spec:
  gatewayClassName: nginx
  listeners:
  - name: http
    protocol: HTTP
    port: 80
    allowedRoutes:
      namespaces:
        from: All

controlplane ~ ➜  #8

controlplane ~ ➜  k edit gateway -n nginx-gateway nginx-gateway 
Edit cancelled, no changes made.

controlplane ~ ➜  k get pod,svc -n default 
NAME               READY   STATUS    RESTARTS   AGE
pod/frontend-app   1/1     Running   0          3m4s

NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/frontend-svc   ClusterIP   172.20.240.90   <none>        80/TCP    3m4s
service/kubernetes     ClusterIP   172.20.0.1      <none>        443/TCP   20m

controlplane ~ ➜  vi frontend-route.yaml

controlplane ~ ➜  k create -f frontend-route.yaml 
httproute.gateway.networking.k8s.io/frontend-route created

controlplane ~ ➜  cat frontend-route.yaml 
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: frontend-route
spec:
  parentRefs:
  - name: nginx-gateway
    namespace: nginx-gateway
    sectionName: http
  hostnames:
  - "www.example.com"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: frontend-svc
      port: 80

controlplane ~ ➜  vi frontend-route.yaml

controlplane ~ ➜  k apply -f frontend-route.yaml 
Warning: resource httproutes/frontend-route is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
httproute.gateway.networking.k8s.io/frontend-route configured

controlplane ~ ➜  kubectl get httproute frontend-route 
NAME             HOSTNAMES             AGE
frontend-route   ["www.example.com"]   55s

controlplane ~ ➜  kubectl describe httproute frontend-route 
Name:         frontend-route
Namespace:    default
Labels:       <none>
Annotations:  <none>
API Version:  gateway.networking.k8s.io/v1
Kind:         HTTPRoute
Metadata:
  Creation Timestamp:  2026-07-10T10:01:25Z
  Generation:          1
  Resource Version:    2680
  UID:                 0e9b84f5-74e6-4a85-a03a-7a866cd8eb30
Spec:
  Hostnames:
    www.example.com
  Parent Refs:
    Group:         gateway.networking.k8s.io
    Kind:          Gateway
    Name:          nginx-gateway
    Namespace:     nginx-gateway
    Section Name:  http
  Rules:
    Backend Refs:
      Group:   
      Kind:    Service
      Name:    frontend-svc
      Port:    80
      Weight:  1
    Matches:
      Path:
        Type:   PathPrefix
        Value:  /
Status:
  Parents:
    Conditions:
      Last Transition Time:  2026-07-10T10:01:25Z
      Message:               The route is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-07-10T10:01:25Z
      Message:               All references are resolved
      Observed Generation:   1
      Reason:                ResolvedRefs
      Status:                True
      Type:                  ResolvedRefs
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
    Parent Ref:
      Group:         gateway.networking.k8s.io
      Kind:          Gateway
      Name:          nginx-gateway
      Namespace:     nginx-gateway
      Section Name:  http
Events:              <none>

controlplane ~ ➜  k delete httproutes.gateway.networking.k8s.io frontend-route 
httproute.gateway.networking.k8s.io "frontend-route" deleted from default namespace

controlplane ~ ➜  k create -f frontend-route.yaml 
httproute.gateway.networking.k8s.io/frontend-route created

controlplane ~ ➜  cat frontend-route.yaml 
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: frontend-route
spec:
  parentRefs:
  - name: nginx-gateway
    namespace: nginx-gateway
    sectionName: http
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: frontend-svc
      port: 80

controlplane ~ ➜  history
    1  #1 Which API resource is used to define a Gateway in Kubernetes?
    2  #2 What is the purpose of the allowedRoutes field in a Gateway?
    3  #3, 4, 5
    4  kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v1.5.1" | kubectl apply -f -
    5  kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v1.6.1/deploy/crds.yaml
    6  kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v1.6.1/deploy/nodeport/deploy.yaml
    7  kubectl get pods -n nginx-gateway
    8  kubectl get svc -n nginx-gateway nginx-gateway -o yaml
    9  kubectl patch svc nginx-gateway -n nginx-gateway --type='json' -p='[
  {"op": "replace", "path": "/spec/ports/0/nodePort", "value": 30080},
  {"op": "replace", "path": "/spec/ports/1/nodePort", "value": 30081}
]'
   10  kubectl get svc -n nginx-gateway nginx-gateway -o yaml
   11  vi 7.yaml
   12  k create -f 7.yaml 
   13  vi 7.yaml
   14  cat 7.yaml 
   15  #8
   16  k edit gateway -n nginx-gateway nginx-gateway 
   17  k get pod,svc -n default 
   18  vi frontend-route.yaml
   19  k create -f frontend-route.yaml 
   20  cat frontend-route.yaml 
   21  vi frontend-route.yaml
   22  k apply -f frontend-route.yaml 
   23  kubectl get httproute frontend-route 
   24  kubectl describe httproute frontend-route 
   25  k delete httproutes.gateway.networking.k8s.io frontend-route 
   26  k create -f frontend-route.yaml 
   27  cat frontend-route.yaml 
   28  history

```