# Rolling Updates and Rollbacks
```cmd
          Welcome to the KodeKloud Hands-On lab                                                                                                                      
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                 All rights reserved                                                                                                                                 

controlplane ~ ➜  #1

controlplane ~ ➜  k get pod
NAME                        READY   STATUS    RESTARTS   AGE
frontend-59dfbc6688-2h89s   1/1     Running   0          23s
frontend-59dfbc6688-k9gl7   1/1     Running   0          23s
frontend-59dfbc6688-r9m57   1/1     Running   0          23s
frontend-59dfbc6688-tlwbt   1/1     Running   0          23s

controlplane ~ ➜  k get svc
NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
kubernetes       ClusterIP   10.43.0.1       <none>        443/TCP          5m54s
webapp-service   NodePort    10.43.159.233   <none>        8080:30080/TCP   28s

controlplane ~ ➜  #1

controlplane ~ ➜  ls
curl-pod.yaml  curl-test.sh

controlplane ~ ➜  bash /root/curl-test.sh
Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK

Hello, Application Version: v1 ; Color: blue OK


controlplane ~ ➜  #2,3

controlplane ~ ➜  #4

controlplane ~ ➜  k get deploy
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
frontend   4/4     4            4           91s

controlplane ~ ➜  k describe deploy frontend
Name:                   frontend
Namespace:              default
CreationTimestamp:      Tue, 09 Jun 2026 10:11:14 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               name=webapp
Replicas:               4 desired | 4 updated | 4 total | 4 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        20
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  name=webapp
  Containers:
   simple-webapp:
    Image:         kodekloud/webapp-color:v1
    Port:          8080/TCP
    Host Port:     0/TCP
    Environment:   <none>
    Mounts:        <none>
  Volumes:         <none>
  Node-Selectors:  <none>
  Tolerations:     <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   frontend-59dfbc6688 (4/4 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  108s  deployment-controller  Scaled up replica set frontend-59dfbc6688 from 0 to 4

controlplane ~ ➜  #5

controlplane ~ ➜  #6

controlplane ~ ➜  #7

controlplane ~ ➜  #8

controlplane ~ ➜  k edit deploy frontend --image=kodekloud/webapp-color:v2
error: unknown flag: --image
See 'kubectl edit --help' for usage.

controlplane ~ ✖ k edit deploy frontend --help
Edit a resource from the default editor.

 The edit command allows you to directly edit any API resource you can retrieve via the command-line tools. It will open
the editor defined by your KUBE_EDITOR, or EDITOR environment variables, or fall back to 'vi' for Linux or 'notepad' for
Windows. When attempting to open the editor, it will first attempt to use the shell that has been defined in the 'SHELL'
environment variable. If this is not defined, the default shell will be used, which is '/bin/bash' for Linux or 'cmd'
for Windows.

 You can edit multiple objects, although changes are applied one at a time. The command accepts file names as well as
command-line arguments, although the files you point to must be previously saved versions of resources.

 Editing is done with the API version used to fetch the resource. To edit using a specific API version, fully-qualify
the resource, version, and group.

 The default format is YAML. To edit in JSON, specify "-o json".

 The flag --windows-line-endings can be used to force Windows line endings, otherwise the default for your operating
system will be used.

 In the event an error occurs while updating, a temporary file will be created on disk that contains your unapplied
changes. The most common error when updating a resource is another editor changing the resource on the server. When this
occurs, you will have to apply your changes to the newer version of the resource, or update your temporary saved copy to
include the latest resource version.

Examples:
  # Edit the service named 'registry'
  kubectl edit svc/registry
  
  # Use an alternative editor
  KUBE_EDITOR="nano" kubectl edit svc/registry
  
  # Edit the job 'myjob' in JSON using the v1 API format
  kubectl edit job.v1.batch/myjob -o json
  
  # Edit the deployment 'mydeployment' in YAML and save the modified config in its annotation
  kubectl edit deployment/mydeployment -o yaml --save-config
  
  # Edit the 'status' subresource for the 'mydeployment' deployment
  kubectl edit deployment mydeployment --subresource='status'

Options:
    --allow-missing-template-keys=true:
        If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to
        golang and jsonpath output formats.

    --field-manager='kubectl-edit':
        Name of the manager used to track field ownership.

    -f, --filename=[]:
        Filename, directory, or URL to files to use to edit the resource

    -k, --kustomize='':
        Process the kustomization directory. This flag can't be used together with -f or -R.

    -o, --output='':
        Output format. One of: (json, yaml, kyaml, name, go-template, go-template-file, template, templatefile,
        jsonpath, jsonpath-as-json, jsonpath-file).

    --output-patch=false:
        Output the patch if the resource is edited.

    -R, --recursive=false:
        Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests
        organized within the same directory.

    --save-config=false:
        If true, the configuration of current object will be saved in its annotation. Otherwise, the annotation will
        be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.

    --show-managed-fields=false:
        If true, keep the managedFields when printing objects in JSON or YAML format.

    --subresource='':
        If specified, edit will operate on the subresource of the requested object.

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

    --windows-line-endings=false:
        Defaults to the line ending native to your platform.

Usage:
  kubectl edit (RESOURCE/NAME | -f FILENAME) [options]

Use "kubectl options" for a list of global command-line options (applies to all commands).

controlplane ~ ➜  k edit deploy frontend
deployment.apps/frontend edited

controlplane ~ ➜  k describe deploy frontend 
Name:                   frontend
Namespace:              default
CreationTimestamp:      Tue, 09 Jun 2026 10:11:14 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 2
Selector:               name=webapp
Replicas:               4 desired | 2 updated | 5 total | 3 available | 2 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        20
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  name=webapp
  Containers:
   simple-webapp:
    Image:         kodekloud/webapp-color:v2
    Port:          8080/TCP
    Host Port:     0/TCP
    Environment:   <none>
    Mounts:        <none>
  Volumes:         <none>
  Node-Selectors:  <none>
  Tolerations:     <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    ReplicaSetUpdated
OldReplicaSets:  frontend-59dfbc6688 (3/3 replicas created)
NewReplicaSet:   frontend-799cddccfc (2/2 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  4m49s  deployment-controller  Scaled up replica set frontend-59dfbc6688 from 0 to 4
  Normal  ScalingReplicaSet  17s    deployment-controller  Scaled up replica set frontend-799cddccfc from 0 to 1
  Normal  ScalingReplicaSet  17s    deployment-controller  Scaled down replica set frontend-59dfbc6688 from 4 to 3
  Normal  ScalingReplicaSet  17s    deployment-controller  Scaled up replica set frontend-799cddccfc from 1 to 2

controlplane ~ ➜  #9

controlplane ~ ➜  bash /root/curl-test.sh
Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK


controlplane ~ ➜  #10

controlplane ~ ➜  #11

controlplane ~ ➜  k edit deploy frontend
deployment.apps/frontend edited

controlplane ~ ➜  #12

controlplane ~ ➜  k edit deploy frontend
deployment.apps/frontend edited

controlplane ~ ➜  #13

controlplane ~ ➜  bash /root/curl-test.sh
Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK

Hello, Application Version: v2 ; Color: green OK


controlplane ~ ➜  history
    1  #1
    2  k get pod
    3  k get svc
    4  #1
    5  ls
    6  bash /root/curl-test.sh
    7  #2,3
    8  #4
    9  k get deploy
   10  k describe deploy frontend
   11  #5
   12  #6
   13  #7
   14  #8
   15  k edit deploy frontend --image=kodekloud/webapp-color:v2
   16  k edit deploy frontend --help
   17  k edit deploy frontend
   18  k describe deploy frontend 
   19  #9
   20  bash /root/curl-test.sh
   21  #10
   22  #11
   23  k edit deploy frontend
   24  #12
   25  k edit deploy frontend
   26  #13
   27  bash /root/curl-test.sh
   28  history

```

# Commands Arguments
```cmd
            Welcome to the KodeKloud Hands-On lab                                                                                                                                          
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                   All rights reserved                                                                                                                                                     

controlplane ~ ➜  #1

controlplane ~ ➜  k get pod
NAME             READY   STATUS    RESTARTS   AGE
ubuntu-sleeper   1/1     Running   0          8s

controlplane ~ ➜  #2

controlplane ~ ➜  k describe pod ubuntu-sleeper 
Name:             ubuntu-sleeper
Namespace:        default
Priority:         0
Service Account:  default
Node:             controlplane/10.244.220.230
Start Time:       Tue, 09 Jun 2026 10:22:07 +0000
Labels:           <none>
Annotations:      <none>
Status:           Running
IP:               10.22.0.9
IPs:
  IP:  10.22.0.9
Containers:
  ubuntu:
    Container ID:  containerd://4539a1b2430aac120ecfa1b6cbeb7ea5c3636a8fb4e677dccd6aa0e372d98430
    Image:         ubuntu
    Image ID:      docker.io/library/ubuntu@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64
    Port:          <none>
    Host Port:     <none>
    Command:
      sleep
      4800
    State:          Running
      Started:      Tue, 09 Jun 2026 10:22:11 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-bvqf5 (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  kube-api-access-bvqf5:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    Optional:                false
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  29s   default-scheduler  Successfully assigned default/ubuntu-sleeper to controlplane
  Normal  Pulling    28s   kubelet            spec.containers{ubuntu}: Pulling image "ubuntu"
  Normal  Pulled     26s   kubelet            spec.containers{ubuntu}: Successfully pulled image "ubuntu" in 2.748s (2.748s including waiting). Image size: 41567720 bytes.
  Normal  Created    26s   kubelet            spec.containers{ubuntu}: Container created
  Normal  Started    25s   kubelet            spec.containers{ubuntu}: Container started

controlplane ~ ➜  #3

controlplane ~ ➜  ls
sample.yaml            ubuntu-sleeper-2.yaml  ubuntu-sleeper-3.yaml  webapp-color           webapp-color-2         webapp-color-3

controlplane ~ ➜  vi ubuntu-sleeper-2.yaml 

controlplane ~ ➜  k create -f ubuntu-sleeper-2.yaml
pod/ubuntu-sleeper-2 created

controlplane ~ ➜  #4

controlplane ~ ➜  k create -f ubuntu-sleeper-3.yaml
Error from server (BadRequest): error when creating "ubuntu-sleeper-3.yaml": Pod in version "v1" cannot be handled as a Pod: json: cannot unmarshal number into Go struct field Container.spec.containers.command of type string

controlplane ~ ✖ vi ubuntu-sleeper-3.yaml 

controlplane ~ ➜  k create -f ubuntu-sleeper-3.yaml
pod/ubuntu-sleeper-3 created

controlplane ~ ➜  #5

controlplane ~ ➜  vi ubuntu-sleeper-3.yaml 

controlplane ~ ➜  k apply -f ubuntu-sleeper-3.yaml
Warning: resource pods/ubuntu-sleeper-3 is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
The Pod "ubuntu-sleeper-3" is invalid: spec: Forbidden: pod updates may not change fields other than `spec.containers[*].image`,`spec.initContainers[*].image`,`spec.activeDeadlineSeconds`,`spec.tolerations` (only additions to existing tolerations),`spec.terminationGracePeriodSeconds` (allow it to be set to 1 if it was previously negative)
@@ -95,7 +95,7 @@
    "Image": "ubuntu",
    "Command": [
     "sleep",
-    "1200"
+    "2000"
    ],
    "Args": null,
    "WorkingDir": "",


controlplane ~ ✖ k edit pod ubuntu-sleeper-3 
error: pods "ubuntu-sleeper-3" is invalid
A copy of your changes has been stored to "/tmp/kubectl-edit-3318710568.yaml"
error: Edit cancelled, no valid changes were saved.

controlplane ~ ✖ k replace --force -f /tmp/kubectl-edit-3318710568.yaml
pod "ubuntu-sleeper-3" deleted from default namespace
pod/ubuntu-sleeper-3 replaced

controlplane ~ ➜  #6

controlplane ~ ➜  cat /r
root/ run/  

controlplane ~ ➜  cat /root/webapp-color
cat: read error: Is a directory

controlplane ~ ✖ cat /root/webapp-color/Dockerfile
FROM python:3.6-alpine

RUN pip install flask

COPY . /opt/

EXPOSE 8080

WORKDIR /opt

ENTRYPOINT ["python", "app.py"]

controlplane ~ ➜  #7

controlplane ~ ➜  cat /root/webapp-color/Dockerfile2
FROM python:3.6-alpine

RUN pip install flask

COPY . /opt/

EXPOSE 8080

WORKDIR /opt

ENTRYPOINT ["python", "app.py"]

CMD ["--color", "red"]

controlplane ~ ➜  #8

controlplane ~ ➜  

controlplane ~ ➜  cat webapp-color-pod.yaml
cat: can't open 'webapp-color-pod.yaml': No such file or directory

controlplane ~ ✖ ls
sample.yaml            ubuntu-sleeper-2.yaml  ubuntu-sleeper-3.yaml  webapp-color           webapp-color-2         webapp-color-3

controlplane ~ ➜  ls webapp-color-2
Dockerfile             webapp-color-pod.yaml

controlplane ~ ➜  cat webapp-color-2/webapp-color-pod.yaml 
apiVersion: v1 
kind: Pod 
metadata:
  name: webapp-green
  labels:
      name: webapp-green 
spec:
  containers:
  - name: simple-webapp
    image: kodekloud/webapp-color
    command: ["--color","green"]

controlplane ~ ➜  

controlplane ~ ➜  cat webapp-color-2/Dockerfile 
FROM python:3.6-alpine

RUN pip install flask

COPY . /opt/

EXPOSE 8080

WORKDIR /opt

ENTRYPOINT ["python", "app.py"]

CMD ["--color", "red"]

controlplane ~ ➜  #9

controlplane ~ ➜  cat webapp-color-3/webapp-color-pod-2.yaml 
apiVersion: v1 
kind: Pod 
metadata:
  name: webapp-green
  labels:
      name: webapp-green 
spec:
  containers:
  - name: simple-webapp
    image: kodekloud/webapp-color
    command: ["python", "app.py"]
    args: ["--color", "pink"]

controlplane ~ ➜  cat webapp-color-3/Dockerfile 
FROM python:3.6-alpine

RUN pip install flask

COPY . /opt/

EXPOSE 8080

WORKDIR /opt

ENTRYPOINT ["python", "app.py"]

CMD ["--color", "red"]

controlplane ~ ➜  #10

controlplane ~ ➜  ls
sample.yaml            ubuntu-sleeper-2.yaml  ubuntu-sleeper-3.yaml  webapp-color           webapp-color-2         webapp-color-3

controlplane ~ ➜  cd webapp-color-3

controlplane ~/webapp-color-3 ➜  ls
Dockerfile               webapp-color-pod-2.yaml

controlplane ~/webapp-color-3 ➜  vi webapp-color-pod-2.yaml 

controlplane ~/webapp-color-3 ➜  k create -f webapp-color-pod-2.yaml 
pod/webapp-green created```
# History
```cmd
# Rolling Updates and Rollbacks
controlplane ~ ➜  history
    1  #1
    2  k get pod
    3  k get svc
    4  #1
    5  ls
    6  bash /root/curl-test.sh
    7  #2,3
    8  #4
    9  k get deploy
   10  k describe deploy frontend
   11  #5
   12  #6
   13  #7
   14  #8
   15  k edit deploy frontend --image=kodekloud/webapp-color:v2
   16  k edit deploy frontend --help
   17  k edit deploy frontend
   18  k describe deploy frontend 
   19  #9
   20  bash /root/curl-test.sh
   21  #10
   22  #11
   23  k edit deploy frontend
   24  #12
   25  k edit deploy frontend
   26  #13
   27  bash /root/curl-test.sh
   28  history
   
# Commands and Arguments
controlplane ~/webapp-color-3 ➜  history
    1  #1
    2  k get pod
    3  #2
    4  k describe pod ubuntu-sleeper 
    5  #3
    6  ls
    7  vi ubuntu-sleeper-2.yaml 
    8  k create -f ubuntu-sleeper-2.yaml
    9  #4
   10  k create -f ubuntu-sleeper-3.yaml
   11  vi ubuntu-sleeper-3.yaml 
   12  k create -f ubuntu-sleeper-3.yaml
   13  #5
   14  vi ubuntu-sleeper-3.yaml 
   15  k apply -f ubuntu-sleeper-3.yaml
   16  k edit pod ubuntu-sleeper-3 
   17  k replace --force -f /tmp/kubectl-edit-3318710568.yaml
   18  #6
   19  cat /root/webapp-color
   20  cat /root/webapp-color/Dockerfile
   21  #7
   22  cat /root/webapp-color/Dockerfile2
   23  #8
   24  cat webapp-color-pod.yaml
   25  ls
   26  ls webapp-color-2
   27  cat webapp-color-2/webapp-color-pod.yaml 
   28  cat webapp-color-2/Dockerfile 
   29  #9
   30  cat webapp-color-3/webapp-color-pod-2.yaml 
   31  cat webapp-color-3/Dockerfile 
   32  #10
   33  ls
   34  cd webapp-color-3
   35  ls
   36  vi webapp-color-pod-2.yaml 
   37  k create -f webapp-color-pod-2.yaml 
   38  history
```