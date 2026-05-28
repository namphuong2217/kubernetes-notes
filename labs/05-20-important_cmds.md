#  Lab 6
# 6.5  Validating and Mutating Admission Controllers
```cmd
k get pod pod-with-override -oyaml
```
## 6.2 Static Pod
## Practice Test - Static Pods
```
# 2 bước để xác định config yaml path
ps -aux | grep kubelet # Quan sat se thay "--config=/var/lib/kubelet/config.yaml"
cat /var/lib/kubelet/config.yaml # staticPodPath: /etc/kubernetes/manifests
#Câu 2. Dau hieu nhan biet Static Pods
# 1. Có node-name suffix
kgp -A | grep controlplane
# 2. GET pod thì sẽ thay ownerReferences
k get pod etcd-controlplane -n kube-system -o yaml
# 3. For kubeadm created cluster, Dùng --selector
kgp -A --selector tier=control-plane
# 4. Check static pod manifest directory to count exactly number of pods.
# 5. Nâng cao, xài jq magic
kubectl get pods -o json -A | jq '.items | .[] | select(.metadata.ownerReferences[0].kind == "Node")
| { name: .metadata.name, namespace: .metadata.namespace }'
ps aux | grep kubelet
cat /var/lib/kubelet/config.yaml # Xem staticPodPath
ls /etc/kubernetest/manifests # Thay 4 pod manifest files:
# etcd, kube-apiServer, kube-controller-manager, kube-scheduler
k run ...--dry-run=client -o yaml --command -- sleep 1000 # Dat command o cuoi cung
# So do not place anything.
# anything that you put after this especially after the two dashes here is going to be considered as
an option for this command.

# Câu 9. Muon delete static Pods thi khong the dung "k delete Pod" dc vi do Kubelet manage dua vao
staticPodPath folder, xoa di no lai create lai.
# do do, can xoa file o staticPodPath
# Step 1. Xem pod đó dang ownerReferences bởi ai (Get Pod), ssh qua node01 server
 ssh node01
# Step 2. Xac dinh staticPodPath (cat /var/lib/kubelet/config.yaml # Xem staticPodPath)
 #2.1
 ps aux | grep kubelet
 cat /var/lib/kubelet/config.yaml
 #2.2
 cd /etc/just-to-mess-with-you
 #2.3
 rm greenbox.yaml
# Step 3. Verify: exit ra master node va "k get pods -w" chờ 1 luc vi kubelet no validate periodically

``` 

First, let's identify the node in which the pod called static-greenbox is created. To do this, run:
root@controlplane:~# kubectl get pods --all-namespaces -o wide  | grep static-greenbox
default       static-greenbox-node01                 1/1     Running   0          19s     10.244.1.2   node01       <none>           <none>
root@controlplane:~#
From the result of this command, we can see that the pod is running on node01.


Next, SSH to node01 and identify the path configured for static pods in this node.

Important: The path need not be /etc/kubernetes/manifests. Make sure to check the path configured in the kubelet configuration file.
root@controlplane:~# ssh node01
root@node01:~# ps -ef |  grep /usr/bin/kubelet
root        4147       1  0 14:05 ?        00:00:00 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock --pod-infra-container-image=registry.k8s.io/pause:3.9
root        4773    4733  0 14:05 pts/0    00:00:00 grep /usr/bin/kubelet

root@node01:~# grep -i staticpod /var/lib/kubelet/config.yaml
staticPodPath: /etc/just-to-mess-with-you

root@node01:~#
Here the staticPodPath is /etc/just-to-mess-with-you


Navigate to this directory and delete the YAML file:
root@node01:/etc/just-to-mess-with-you# ls
greenbox.yaml
root@node01:/etc/just-to-mess-with-you# rm -rf greenbox.yaml
root@node01:/etc/just-to-mess-with-you#
wait for 30 seconds.

Exit out of node01 using CTRL + D or type exit. You should return to the controlplane node, Check if the static-greenbox pod has been deleted:
root@controlplane:~# kubectl get pods --all-namespaces -o wide  | grep static-greenbox
root@controlplane:~#
# Practice Test - DaemonSets
``` 
k describe daemonsets kube-proxy -n kube-system
k describe daemonsets kube-flannel-ds -n kube-flannel
k create deployment elasticsearch --image registry.k8s.io/fluentd-elasticsearch:1.20 -n
kube-system --dry-run=client -o yaml > 6.yaml
#Phai tao deloyment roi moi sua kind thanh DaemonSet, xoa spec.replicas & spec.strategy
```
## Editing PODS and Deployments
### Export pod definition of a running pod

k get pod webapp -o yaml > my-new-pod.yaml

### Edit deployment is better
``` 
k edit deployment my-deployment
# then edit the pod template
```
# Lab 5
## Practice Test - Resource Requirements & Limits
```
1. Muốn edit running Pods thì 2 steps
1. Edit (Sau khi Save sẽ đi vào tmp file): `/tmp/kubectl-edit-123456.yaml`
2. Replace: `kubectl replace --foce -f /tmp/kubectl-edit-123456.yaml`
2.
k delete pod elephant --grace-period=0 --force # Delete Pod saving 30s
``` 
## Practice Test - Node Affinity
```
Câu 2: k describe node node01 | grep beta.kubernetes.io/arch #amd64
Câu 3: k label node node01 color=blue
Câu 4: Tạo new deployment có replicas = 3
Câu 5: Nodes nào pods có thể đc scheduled? => All vì ko có taints trên các node
k describe node node01 | grep Taints
Câu 6: set nodeAffinity (Assign Pods to node using nodeAffinity)
Câu 7: kiểm tra nodes mà các pods đc placed vào sau khi set nodeAffinity là gì
k get pods -o wide
Câu 8 (4 phút): Tạo new deployment, đảm bảo các pods đc assigned vào "controlplane" node only.
#Dùng toán tử Exists là bởi vì label không có values
Solution
# Chú ý thụt lề: affinity nằm ngang với containers "line 106: did not find expected key"
# Tham khảo Section 14(3.Tự tìm hiểu thêm về YAML)
Tips: VI dùng Visual Mode để bôi đen nhiều dòng rồi shift để canh lề
```
## Labels and nodeSelectors
```cmd
k get nodes --show-labels
```

Practice Test - Manual Scheduling

# Force replace pod từ file YAML
kubectl replace --force -f nginx.yaml
# Ghi chú:
# - Dùng khi muốn override pod đang chạy
# - Áp dụng được cả sau khi đã kubectl apply trước đó
# - apply lại sẽ không ăn do pod có thêm metadata runtime
# Theo dõi pods realtime
kubectl get pods --watch
# Xem chi tiết node / IP / location
kubectl get pods -o wide
# hoặc
kgp -o wide

Labels
k gt pods -l app=backend
k get pods --selector env=dev —no-headers | wc -l
k get pods --selector bu=finance --no-headers | wc -l
k get all --selector env=prod —no-headers | wc -l
k get all --selector env=prod,bu=finance,tier=frontend # Chú ý là phải ghi liền nhau

Practice Test - Taints and Tolerations
25
Taints
 Add: "kubectl taint nodes node1 key1=value1:NoSchedule"
 Remove: "kubectl taint nodes node1 key1=value1:NoSchedule-"
Tolerations
 spec:
 tolerations:
 - key: "key1"
 value: "value1"
 operator: "Equal"
 effect: "NoSchedule"
 containers:
 - image: nginx
 name: bee
Others
 kubectl taint nodes node01 spray=mortein:NoSchedule
 kubectl describe pods/mosquito # Xem Events để thấy đc Pod đang pending status do ko có tolerate
 kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule-
 # Sau khi remove taint đó ra thi pod đang Pending sẽ ngay lập tức đc ru
kubectl describe node node01 | grep -i taints
k taint nodes node01 spray=mortein:NoSchedule
k describe po bee | grep -i tole -A5

# Remove taint
k taint nodes controlplane node-role.kubernetes.io/control-plane-

k replace --force -f nginx.yaml
k taint node --help
k taint nodes foo dedicated:NoSchedule- 
```
