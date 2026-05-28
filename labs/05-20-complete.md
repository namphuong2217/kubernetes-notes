# Lab 6 
## 6.5 Validating and Mutating Admission Controllers
```cmd
         Welcome to the KodeKloud Hands-On lab                                                                                                               
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                All rights reserved                                                                                                                           

controlplane ~ ➜  #1-3

controlplane ~ ➜  k create ns webhook-demo
namespace/webhook-demo created

controlplane ~ ➜  #4

controlplane ~ ➜  k create secret --help
Create a secret with specified type.

 A docker-registry type secret is for accessing a container registry.

 A generic type secret indicate an Opaque secret type.

 A tls type secret holds TLS certificate and its associated key.

Available Commands:
  docker-registry   Create a secret for use with a Docker registry
  generic           Create a secret from a local file, directory, or literal value
  tls               Create a TLS secret

Usage:
  kubectl create secret (docker-registry | generic | tls) [options]

Use "kubectl create secret <command> --help" for more information about a given command.
Use "kubectl options" for a list of global command-line options (applies to all commands).

controlplane ~ ➜  k create secret tls --help
Create a TLS secret from the given public/private key pair.

 The public/private key pair must exist beforehand. The public key certificate must be .PEM encoded
and match the given private key.

Examples:
  # Create a new TLS secret named tls-secret with the given key pair
  kubectl create secret tls tls-secret --cert=path/to/tls.crt --key=path/to/tls.key

Options:
    --allow-missing-template-keys=true:
        If true, ignore any errors in templates when a field or map key is missing in the
        template. Only applies to golang and jsonpath output formats.

    --append-hash=false:
        Append a hash of the secret to its name.

    --cert='':
        Path to PEM encoded public key certificate.

    --dry-run='none':
        Must be "none", "server", or "client". If client strategy, only print the object that
        would be sent, without sending it. If server strategy, submit server-side request without
        persisting the resource.

    --field-manager='kubectl-create':
        Name of the manager used to track field ownership.

    --key='':
        Path to private key associated with given certificate.

    -o, --output='':
        Output format. One of: (json, yaml, kyaml, name, go-template, go-template-file, template,
        templatefile, jsonpath, jsonpath-as-json, jsonpath-file).

    --save-config=false:
        If true, the configuration of current object will be saved in its annotation. Otherwise,
        the annotation will be unchanged. This flag is useful when you want to perform kubectl
        apply on this object in the future.

    --show-managed-fields=false:
        If true, keep the managedFields when printing objects in JSON or YAML format.

    --template='':
        Template string or path to template file to use when -o=go-template, -o=go-template-file.
        The template format is golang templates
        [http://golang.org/pkg/text/template/#pkg-overview].

    --validate='strict':
        Must be one of: strict (or true), warn, ignore (or false). "true" or "strict" will use a
        schema to validate the input and fail the request if invalid. It will perform server side
        validation if ServerSideFieldValidation is enabled on the api-server, but will fall back
        to less reliable client-side validation if not. "warn" will warn about unknown or
        duplicate fields without blocking the request if server-side field validation is enabled
        on the API server, and behave as "ignore" otherwise. "false" or "ignore" will not perform
        any schema validation, silently dropping any unknown or duplicate fields.

Usage:
  kubectl create secret tls NAME --cert=path/to/cert/file --key=path/to/key/file
[--dry-run=server|client|none] [options]

Use "kubectl options" for a list of global command-line options (applies to all commands).

controlplane ~ ➜  k create secret tls --cert='/root/keys/webhook-server-tls.crt' --key='/root/keys/webhook-server-tls.key'
error: exactly one NAME is required, got 0
See 'kubectl create secret tls -h' for help and examples

controlplane ~ ✖ k create secret tls webhook-server-tls --cert='/root/keys/webhook-server-tls.crt' --key='/root/key
s/webhook-server-tls.key'
secret/webhook-server-tls created

controlplane ~ ➜  #5

controlplane ~ ➜  #4

controlplane ~ ➜  k create secret tls webhook-server-tls --cert='/root/keys/webhook-server-tls.crt' --key='/root/ke
ys/webhook-server-tls.key' -n webhook-demo
secret/webhook-server-tls created

controlplane ~ ➜  #5

controlplane ~ ➜  k create -f /root/webhook-deployment.yaml
deployment.apps/webhook-server created

controlplane ~ ➜  vi /root/webhook-deployment.yaml

controlplane ~ ➜  #6

controlplane ~ ➜  k create -f /root/webhook-service.yaml
service/webhook-server created

controlplane ~ ➜  vi /root/webhook-service.yaml

controlplane ~ ➜  cat /root/webhook-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: webhook-server
  namespace: webhook-demo
spec:
  selector:
    app: webhook-server
  ports:
    - port: 443
      targetPort: webhook-api

controlplane ~ ➜  cat /root/webhook-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webhook-server
  namespace: webhook-demo
  labels:
    app: webhook-server
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webhook-server
  template:
    metadata:
      labels:
        app: webhook-server
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 1234
      containers:
      - name: server
        image: stackrox/admission-controller-webhook-demo:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 8443
          name: webhook-api
        volumeMounts:
        - name: webhook-tls-certs
          mountPath: /run/secrets/tls
          readOnly: true
      volumes:
      - name: webhook-tls-certs
        secret:
          secretName: webhook-server-tls

controlplane ~ ➜  #7

controlplane ~ ➜  cat /root/webhook-configuration.yaml
apiVersion: admissionregistration.k8s.io/v1
kind: MutatingWebhookConfiguration
metadata:
  name: demo-webhook
webhooks:
  - name: webhook-server.webhook-demo.svc
    clientConfig:
      service:
        name: webhook-server
        namespace: webhook-demo
        path: "/mutate"
      caBundle: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURQekNDQWllZ0F3SUJBZ0lVVFFSV1lUZU1hdXBHZUt3ZUNEbGUyb3ZWd2pFd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0x6RXRNQ3NHQTFVRUF3d2tRV1J0YVhOemFXOXVJRU52Ym5SeWIyeHNaWElnVjJWaWFHOXZheUJFWlcxdgpJRU5CTUI0WERUSTJNRFV5T0RFMU1EUXpNVm9YRFRJMk1EWXlOekUxTURRek1Wb3dMekV0TUNzR0ExVUVBd3drClFXUnRhWE56YVc5dUlFTnZiblJ5YjJ4c1pYSWdWMlZpYUc5dmF5QkVaVzF2SUVOQk1JSUJJakFOQmdrcWhraUcKOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQTFsSmRaQ000Ry9MUHZlZFFST1pjaXFtOC9UVUFmY3AxdHNVRgpIbkRueHF2MDBOMmFTcndFRWpvRVVJZ1pHSm1UM2oyUkl4L2FZSEJFL0h4Z0pvdy91NG9tSlN1MGtycEYvY0RsCnQyY3VJaVpuNEhKRFJoNDlmYlV0Lzg2WklSY2dCZ1IvTDFrd01Ec3l6UDRaSUE5b29pMjNFVUZiRERZY25zS3QKREVucytBWGpQMEcrRjQxMVE5c2RFWGM0VzM3TStUSmVITDB6Y0d5SVJSbVZUeFdHRDF3TlJ1L2grZkZEVlBpOQo1NlBXQ2NDQmVNRUVWT05mRWZxbzR5U1laMTFISGd4UDZTM2c1d3gzRGhvODdLckt2cG5uend1R3c4Y2FRaEgzCjRKU1paQ25NaHlzNkpVZnJ1NFo0ZXBicms4Q1RyUDBTd3ZGenJQYWd5OGorUVVDOE1RSURBUUFCbzFNd1VUQWQKQmdOVkhRNEVGZ1FVbDByTk1SMjhWaGxEM21BTWFwNVFjc2MveE5Jd0h3WURWUjBqQkJnd0ZvQVVsMHJOTVIyOApWaGxEM21BTWFwNVFjc2MveE5Jd0R3WURWUjBUQVFIL0JBVXdBd0VCL3pBTkJna3Foa2lHOXcwQkFRc0ZBQU9DCkFRRUFuZXg2UWZoTU14aDRtNzhxZkZqcjRnbUJlb1gwNW5XdVJqQzEra1AxTHhrVFdOS2RUZko0QTdXTnhJU1EKS1hFNlBsUWJQRXhDWWV2STF3T3ljVDBSZFYyQjMxVTdocUJ0eVFlRWtmdEMrSSttcGdwZFFqUHlzRk90dVQyUApSdTNOMHlaclNRY3RoNGI3UW9OVkVVN0g5RUFKa1VLUkxoQTg0TnpKUHA1SXRmRVZBRjlSL1VUT1JNd3YvbXlmCi9yNkVlTTJUZ3ZMMnhNenFiQkRoOGlkYlU5MjI2SVcyZC9IRDl0MFJnUUQwUG0vQ0tkM0lCcFFWdEU4UVJHWjMKTHFHTHEyRG52QVo1Vjc3bENOTzdwQytaaGhWOWZjM0VNdzJIQkFoQnUwTlhHVXdlL0xrTWZGdHY3bnludWZBcQo3d1VVT1pPOW8vaW1oQUFLTVE1bW1JSS9kZz09Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    rules:
      - operations: [ "CREATE" ]
        apiGroups: [""]
        apiVersions: ["v1"]
        resources: ["pods"]
    admissionReviewVersions: ["v1beta1"]
    sideEffects: None

controlplane ~ ➜  k create -f /root/webhook-configuration.yaml
mutatingwebhookconfiguration.admissionregistration.k8s.io/demo-webhook created

controlplane ~ ➜  #8

controlplane ~ ➜  #9

controlplane ~ ➜  cat /root/pod-with-defaults.yaml
# A pod with no securityContext specified.
# Without the webhook, it would run as user root (0). The webhook mutates it
# to run as the non-root user with uid 1234.
apiVersion: v1
kind: Pod
metadata:
  name: pod-with-defaults
  labels:
    app: pod-with-defaults
spec:
  restartPolicy: OnFailure
  containers:
    - name: busybox
      image: busybox
      command: ["sh", "-c", "echo I am running as user $(id -u)"]

controlplane ~ ➜  k create -f /root/pod-with-defaults.yaml
pod/pod-with-defaults created

controlplane ~ ➜  

controlplane ~ ➜  #10

controlplane ~ ➜  #11

controlplane ~ ➜  k describe pod pod-with-defaults 
Name:             pod-with-defaults
Namespace:        default
Priority:         0
Service Account:  default
Node:             controlplane/10.244.167.78
Start Time:       Thu, 28 May 2026 15:15:02 +0000
Labels:           app=pod-with-defaults
Annotations:      <none>
Status:           Succeeded
IP:               172.17.0.6
IPs:
  IP:  172.17.0.6
Containers:
  busybox:
    Container ID:  containerd://933edbd241eec1f5e23e9cf9d0980f549f82bb9152ced4fbc8c607d7dcd0ebd2
    Image:         busybox
    Image ID:      docker.io/library/busybox@sha256:fd8d9aa63ba2f0982b5304e1ee8d3b90a210bc1ffb5314d980eb6962f1a9715d
    Port:          <none>
    Host Port:     <none>
    Command:
      sh
      -c
      echo I am running as user $(id -u)
    State:          Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Thu, 28 May 2026 15:15:03 +0000
      Finished:     Thu, 28 May 2026 15:15:03 +0000
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-k5xvn (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   False 
  Initialized                 True 
  Ready                       False 
  ContainersReady             False 
  PodScheduled                True 
Volumes:
  kube-api-access-k5xvn:
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
  Normal  Scheduled  19s   default-scheduler  Successfully assigned default/pod-with-defaults to controlplane
  Normal  Pulling    19s   kubelet            spec.containers{busybox}: Pulling image "busybox"
  Normal  Pulled     18s   kubelet            spec.containers{busybox}: Successfully pulled image "busybox" in 537ms (537ms including waiting). Image size: 2236931 bytes.
  Normal  Created    18s   kubelet            spec.containers{busybox}: Container created
  Normal  Started    18s   kubelet            spec.containers{busybox}: Container started

controlplane ~ ➜  k get po pod-with-defaults -oyaml 
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: "2026-05-28T15:15:02Z"
  generation: 1
  labels:
    app: pod-with-defaults
  name: pod-with-defaults
  namespace: default
  resourceVersion: "1863"
  uid: 01add240-a4d9-4898-832d-2c979306dc35
spec:
  containers:
  - command:
    - sh
    - -c
    - echo I am running as user $(id -u)
    image: busybox
    imagePullPolicy: Always
    name: busybox
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-k5xvn
      readOnly: true
  dnsPolicy: ClusterFirst
  enableServiceLinks: true
  nodeName: controlplane
  preemptionPolicy: PreemptLowerPriority
  priority: 0
  restartPolicy: OnFailure
  schedulerName: default-scheduler
  securityContext:
    runAsNonRoot: true
    runAsUser: 1234
  serviceAccount: default
  serviceAccountName: default
  terminationGracePeriodSeconds: 30
  tolerations:
  - effect: NoExecute
    key: node.kubernetes.io/not-ready
    operator: Exists
    tolerationSeconds: 300
  - effect: NoExecute
    key: node.kubernetes.io/unreachable
    operator: Exists
    tolerationSeconds: 300
  volumes:
  - name: kube-api-access-k5xvn
    projected:
      defaultMode: 420
      sources:
      - serviceAccountToken:
          expirationSeconds: 3607
          path: token
      - configMap:
          items:
          - key: ca.crt
            path: ca.crt
          name: kube-root-ca.crt
      - downwardAPI:
          items:
          - fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
            path: namespace
status:
  conditions:
  - lastProbeTime: null
    lastTransitionTime: "2026-05-28T15:15:05Z"
    observedGeneration: 1
    status: "False"
    type: PodReadyToStartContainers
  - lastProbeTime: null
    lastTransitionTime: "2026-05-28T15:15:02Z"
    observedGeneration: 1
    reason: PodCompleted
    status: "True"
    type: Initialized
  - lastProbeTime: null
    lastTransitionTime: "2026-05-28T15:15:02Z"
    observedGeneration: 1
    reason: PodCompleted
    status: "False"
    type: Ready
  - lastProbeTime: null
    lastTransitionTime: "2026-05-28T15:15:02Z"
    observedGeneration: 1
    reason: PodCompleted
    status: "False"
    type: ContainersReady
  - lastProbeTime: null
    lastTransitionTime: "2026-05-28T15:15:02Z"
    observedGeneration: 1
    status: "True"
    type: PodScheduled
  containerStatuses:
  - containerID: containerd://933edbd241eec1f5e23e9cf9d0980f549f82bb9152ced4fbc8c607d7dcd0ebd2
    image: docker.io/library/busybox:latest
    imageID: docker.io/library/busybox@sha256:fd8d9aa63ba2f0982b5304e1ee8d3b90a210bc1ffb5314d980eb6962f1a9715d
    lastState: {}
    name: busybox
    ready: false
    resources: {}
    restartCount: 0
    started: false
    state:
      terminated:
        containerID: containerd://933edbd241eec1f5e23e9cf9d0980f549f82bb9152ced4fbc8c607d7dcd0ebd2
        exitCode: 0
        finishedAt: "2026-05-28T15:15:03Z"
        reason: Completed
        startedAt: "2026-05-28T15:15:03Z"
    volumeMounts:
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-k5xvn
      readOnly: true
      recursiveReadOnly: Disabled
  hostIP: 10.244.167.78
  hostIPs:
  - ip: 10.244.167.78
  observedGeneration: 1
  phase: Succeeded
  podIP: 172.17.0.6
  podIPs:
  - ip: 172.17.0.6
  qosClass: BestEffort
  startTime: "2026-05-28T15:15:02Z"

controlplane ~ ➜  #12

controlplane ~ ➜  cat /root/pod-with-override.yaml
# A pod with a securityContext explicitly allowing it to run as root.
# The effect of deploying this with and without the webhook is the same. The
# explicit setting however prevents the webhook from applying more secure
# defaults.
apiVersion: v1
kind: Pod
metadata:
  name: pod-with-override
  labels:
    app: pod-with-override
spec:
  restartPolicy: OnFailure
  securityContext:
    runAsNonRoot: false
  containers:
    - name: busybox
      image: busybox
      command: ["sh", "-c", "echo I am running as user $(id -u)"]

controlplane ~ ➜  k create -f /root/pod-with-override.yaml
pod/pod-with-override created

controlplane ~ ➜  k get pod pod-with-override -oyaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: "2026-05-28T15:18:16Z"
  generation: 1
  labels:
    app: pod-with-override
  name: pod-with-override
  namespace: default
  resourceVersion: "2125"
  uid: da6b2e7e-3331-4276-8990-1601a099ad87
spec:
  containers:
  - command:
    - sh
    - -c
    - echo I am running as user $(id -u)
    image: busybox
    imagePullPolicy: Always
    name: busybox
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-kj6tr
      readOnly: true
  dnsPolicy: ClusterFirst
  enableServiceLinks: true
  nodeName: controlplane
  preemptionPolicy: PreemptLowerPriority
  priority: 0
  restartPolicy: OnFailure
  schedulerName: default-scheduler
  securityContext:
    runAsNonRoot: false
  serviceAccount: default
  serviceAccountName: default
  terminationGracePeriodSeconds: 30
  tolerations:
  - effect: NoExecute
    key: node.kubernetes.io/not-ready
    operator: Exists
    tolerationSeconds: 300
  - effect: NoExecute
    key: node.kubernetes.io/unreachable
    operator: Exists
    tolerationSeconds: 300
  volumes:
  - name: kube-api-access-kj6tr
    projected:
      defaultMode: 420
      sources:
      - serviceAccountToken:
          expirationSeconds: 3607
          path: token
      - configMap:
          items:
          - key: ca.crt
            path: ca.crt
          name: kube-root-ca.crt
      - downwardAPI:
          items:
          - fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
            path: namespace
status:
  conditions:
  - lastProbeTime: null
    lastTransitionTime: "2026-05-28T15:18:18Z"
    observedGeneration: 1
    status: "False"
    type: PodReadyToStartContainers
  - lastProbeTime: null
    lastTransitionTime: "2026-05-28T15:18:16Z"
    observedGeneration: 1
    reason: PodCompleted
    status: "True"
    type: Initialized
  - lastProbeTime: null
    lastTransitionTime: "2026-05-28T15:18:16Z"
    observedGeneration: 1
    reason: PodCompleted
    status: "False"
    type: Ready
  - lastProbeTime: null
    lastTransitionTime: "2026-05-28T15:18:16Z"
    observedGeneration: 1
    reason: PodCompleted
    status: "False"
    type: ContainersReady
  - lastProbeTime: null
    lastTransitionTime: "2026-05-28T15:18:16Z"
    observedGeneration: 1
    status: "True"
    type: PodScheduled
  containerStatuses:
  - containerID: containerd://c97d8252612c5623a6fc5fafeffb06e414e2bb21e0b5848406ef5dc5d2d95226
    image: docker.io/library/busybox:latest
    imageID: docker.io/library/busybox@sha256:fd8d9aa63ba2f0982b5304e1ee8d3b90a210bc1ffb5314d980eb6962f1a9715d
    lastState: {}
    name: busybox
    ready: false
    resources: {}
    restartCount: 0
    started: false
    state:
      terminated:
        containerID: containerd://c97d8252612c5623a6fc5fafeffb06e414e2bb21e0b5848406ef5dc5d2d95226
        exitCode: 0
        finishedAt: "2026-05-28T15:18:17Z"
        reason: Completed
        startedAt: "2026-05-28T15:18:17Z"
    volumeMounts:
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-kj6tr
      readOnly: true
      recursiveReadOnly: Disabled
  hostIP: 10.244.167.78
  hostIPs:
  - ip: 10.244.167.78
  observedGeneration: 1
  phase: Succeeded
  podIP: 172.17.0.7
  podIPs:
  - ip: 172.17.0.7
  qosClass: BestEffort
  startTime: "2026-05-28T15:18:16Z"

controlplane ~ ➜  cat /root/pod-with-conflict.yaml
# A pod with a conflicting securityContext setting: it has to run as a non-root
# user, but we explicitly request a user id of 0 (root).
# Without the webhook, the pod could be created, but would be unable to launch
# due to an unenforceable security context leading to it being stuck in a
# 'CreateContainerConfigError' status. With the webhook, the creation of
# the pod is outright rejected.
apiVersion: v1
kind: Pod
metadata:
  name: pod-with-conflict
  labels:
    app: pod-with-conflict
spec:
  restartPolicy: OnFailure
  securityContext:
    runAsNonRoot: true
    runAsUser: 0
  containers:
    - name: busybox
      image: busybox
      command: ["sh", "-c", "echo I am running as user $(id -u)"]

controlplane ~ ➜  k create -f /root/pod-with-conflict.yaml
Error from server: error when creating "/root/pod-with-conflict.yaml": admission webhook "webhook-server.webhook-demo.svc" denied the request: runAsNonRoot specified, but runAsUser set to 0 (the root user)

controlplane ~ ✖ history
    1  #1-3
    2  k create ns webhook-demo
    3  #4
    4  k create secret --help
    5  k create secret tls --help
    6  k create secret tls --cert='/root/keys/webhook-server-tls.crt' --key='/root/keys/webhook-server-tls.key'
    7  k create secret tls webhook-server-tls --cert='/root/keys/webhook-server-tls.crt' --key='/root/keys/webhook-server-tls.key'
    8  #5
    9  #4
   10  k create secret tls webhook-server-tls --cert='/root/keys/webhook-server-tls.crt' --key='/root/keys/webhook-server-tls.key' -n webhook-demo
   11  #5
   12  k create -f /root/webhook-deployment.yaml
   13  vi /root/webhook-deployment.yaml
   14  #6
   15  k create -f /root/webhook-service.yaml
   16  vi /root/webhook-service.yaml
   17  cat /root/webhook-service.yaml
   18  cat /root/webhook-deployment.yaml
   19  #7
   20  cat /root/webhook-configuration.yaml
   21  k create -f /root/webhook-configuration.yaml
   22  #8
   23  #9
   24  cat /root/pod-with-defaults.yaml
   25  k create -f /root/pod-with-defaults.yaml
   26  #10
   27  #11
   28  k describe pod pod-with-defaults 
   29  k get po pod-with-defaults -oyaml 
   30  #12
   31  cat /root/pod-with-override.yaml
   32  k create -f /root/pod-with-override.yaml
   33  k get pod pod-with-override -oyaml
   34  cat /root/pod-with-conflict.yaml
   35  k create -f /root/pod-with-conflict.yaml
   36  history
```
## 6.4 Admission Controller
```cmd
          Welcome to the KodeKloud Hands-On lab                                                                                                               
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                All rights reserved                                                                                                                           

controlplane ~ ➜  #1

controlplane ~ ➜  #2

controlplane ~ ➜  #3

controlplane ~ ➜  cat /etc/kubernetes/imgvalidation
cat: /etc/kubernetes/imgvalidation: Is a directory

controlplane ~ ✖ ls -la /etc/kubernetes/imgvalidation/
cat /etc/kubernetes/imgvalidation/admission-configuration.yaml
cat /etc/kubernetes/imgvalidation/imagepolicy-conf.yaml
cat /etc/kubernetes/imgvalidation/kubeconf.yaml
total 32
drwxr-xr-x 2 root root 4096 May 28 14:36 .
drwxrwxr-x 1 root root 4096 May 28 14:36 ..
-rw-r--r-- 1 root root  164 May 28 14:36 admission-configuration.yaml
-rw-r--r-- 1 root root  145 May 28 14:36 imagepolicy-conf.yaml
-rw-r--r-- 1 root root  494 May 28 14:36 kubeconf.yaml
-rw-r--r-- 1 root root 1172 May 28 14:36 webhook.crt
-rw------- 1 root root 1704 May 28 14:36 webhook.key
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: ImagePolicyWebhook
  path: /etc/kubernetes/imgvalidation/imagepolicy-conf.yaml
imagePolicy:
  kubeConfigFile: /etc/kubernetes/imgvalidation/kubeconf.yaml
  allowTTL: 50
  denyTTL: 50
  retryBackoff: 500
  defaultAllow: true
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority: /etc/kubernetes/imgvalidation/webhook.crt
    server: https://placeholder.example.com
  name: checker_webhook
contexts:
- context:
    cluster: checker_webhook
    user: api-server
  name: checker_validator
current-context: checker_validator
preferences: {}
users:
- name: api-server
  user:
    client-certificate: /etc/kubernetes/pki/front-proxy-client.crt
    client-key: /etc/kubernetes/pki/front-proxy-client.key

controlplane ~ ➜  ls -la /etc/kubernetes/imgvalidation/
total 32
drwxr-xr-x 2 root root 4096 May 28 14:36 .
drwxrwxr-x 1 root root 4096 May 28 14:36 ..
-rw-r--r-- 1 root root  164 May 28 14:36 admission-configuration.yaml
-rw-r--r-- 1 root root  145 May 28 14:36 imagepolicy-conf.yaml
-rw-r--r-- 1 root root  494 May 28 14:36 kubeconf.yaml
-rw-r--r-- 1 root root 1172 May 28 14:36 webhook.crt
-rw------- 1 root root 1704 May 28 14:36 webhook.key

controlplane ~ ➜  cat /etc/kubernetes/imgvalidation/admission-configuration.yaml
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: ImagePolicyWebhook
  path: /etc/kubernetes/imgvalidation/imagepolicy-conf.yaml

controlplane ~ ➜  cat /etc/kubernetes/imgvalidation/imagepolicy-conf.yaml
imagePolicy:
  kubeConfigFile: /etc/kubernetes/imgvalidation/kubeconf.yaml
  allowTTL: 50
  denyTTL: 50
  retryBackoff: 500
  defaultAllow: true

controlplane ~ ➜  cat /etc/kubernetes/imgvalidation/kubeconf.yaml
apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority: /etc/kubernetes/imgvalidation/webhook.crt
    server: https://placeholder.example.com
  name: checker_webhook
contexts:
- context:
    cluster: checker_webhook
    user: api-server
  name: checker_validator
current-context: checker_validator
preferences: {}
users:
- name: api-server
  user:
    client-certificate: /etc/kubernetes/pki/front-proxy-client.crt
    client-key: /etc/kubernetes/pki/front-proxy-client.key

controlplane ~ ➜  #3

controlplane ~ ➜  #4

controlplane ~ ➜  vi /etc/kubernetes/imgvalidation/imagepolicy-conf.yaml

controlplane ~ ➜  cat /etc/kubernetes/imgvalidation/imagepolicy-conf.yaml
imagePolicy:
  kubeConfigFile: /etc/kubernetes/imgvalidation/kubeconf.yaml
  allowTTL: 50
  denyTTL: 50
  retryBackoff: 500
  defaultAllow: false

controlplane ~ ➜  #5

controlplane ~ ➜  #6

controlplane ~ ➜  ls /etc/kubernetes/imgvalidation/kubeconf.yaml
/etc/kubernetes/imgvalidation/kubeconf.yaml

controlplane ~ ➜  vim /etc/kubernetes/imgvalidation/kubeconf.yaml

controlplane ~ ➜  #7

controlplane ~ ➜  cp /etc/kubernetes/manifests/kube-apiserver.yaml /opt/kube-apiserver.yaml.bak

controlplane ~ ➜  vi /etc/kubernetes/manifests/kube-apiserver.yaml 

controlplane ~ ➜  k get pods -n kube-system
The connection to the server controlplane:6443 was refused - did you specify the right host or port?

controlplane ~ ✖ k get pods -n kube-system
NAME                                   READY   STATUS    RESTARTS       AGE
coredns-6f6c7df987-bkfpb               1/1     Running   0              26m
coredns-6f6c7df987-cwf4s               1/1     Running   0              26m
etcd-controlplane                      1/1     Running   0              26m
kube-apiserver-controlplane            1/1     Running   0              73s
kube-controller-manager-controlplane   1/1     Running   1 (109s ago)   26m
kube-proxy-2cnbc                       1/1     Running   0              26m
kube-scheduler-controlplane            1/1     Running   1 (108s ago)   26m

controlplane ~ ➜  cat /etc/kubernetes/manifests/kube-apiserver.yaml 
apiVersion: v1
kind: Pod
metadata:
  annotations:
    kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint: 10.244.34.203:6443
  labels:
    component: kube-apiserver
    tier: control-plane
  name: kube-apiserver
  namespace: kube-system
spec:
  containers:
  - command:
    - kube-apiserver
    - --advertise-address=10.244.34.203
    - --allow-privileged=true
    - --authorization-mode=Node,RBAC
    - --client-ca-file=/etc/kubernetes/pki/ca.crt
    - --enable-admission-plugins=NodeRestriction
    - --enable-bootstrap-token-auth=true
    - --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt
    - --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt
    - --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key
    - --etcd-servers=https://127.0.0.1:2379
    - --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt
    - --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key
    - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
    - --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt
    - --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key
    - --requestheader-allowed-names=front-proxy-client
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
    - --enable-admission-plugins=NodeRestriction,ImagePolicyWebhook
    - --admission-control-config-file=/etc/kubernetes/imgvalidation/admission-configuration.yaml
    image: registry.k8s.io/kube-apiserver:v1.35.0
    imagePullPolicy: IfNotPresent
    livenessProbe:
      failureThreshold: 8
      httpGet:
        host: 10.244.34.203
        path: /livez
        port: probe-port
        scheme: HTTPS
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 15
    name: kube-apiserver
    ports:
    - containerPort: 6443
      name: probe-port
      protocol: TCP
    readinessProbe:
      failureThreshold: 3
      httpGet:
        host: 10.244.34.203
        path: /readyz
        port: probe-port
        scheme: HTTPS
      periodSeconds: 1
      timeoutSeconds: 15
    resources:
      requests:
        cpu: 250m
    startupProbe:
      failureThreshold: 24
      httpGet:
        host: 10.244.34.203
        path: /livez
        port: probe-port
        scheme: HTTPS
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 15
    volumeMounts:
    - mountPath: /etc/ssl/certs
      name: ca-certs
      readOnly: true
    - mountPath: /etc/ca-certificates
      name: etc-ca-certificates
      readOnly: true
    - mountPath: /etc/kubernetes/pki
      name: k8s-certs
      readOnly: true
    - mountPath: /usr/local/share/ca-certificates
      name: usr-local-share-ca-certificates
      readOnly: true
    - mountPath: /usr/share/ca-certificates
      name: usr-share-ca-certificates
      readOnly: true
    - name: imgvalidation
      mountPath: /etc/kubernetes/imgvalidation
      readOnly: true
  hostNetwork: true
  priority: 2000001000
  priorityClassName: system-node-critical
  securityContext:
    seccompProfile:
      type: RuntimeDefault
  volumes:
  - hostPath:
      path: /etc/ssl/certs
      type: DirectoryOrCreate
    name: ca-certs
  - hostPath:
      path: /etc/ca-certificates
      type: DirectoryOrCreate
    name: etc-ca-certificates
  - hostPath:
      path: /etc/kubernetes/pki
      type: DirectoryOrCreate
    name: k8s-certs
  - hostPath:
      path: /usr/local/share/ca-certificates
      type: DirectoryOrCreate
    name: usr-local-share-ca-certificates
  - hostPath:
      path: /usr/share/ca-certificates
      type: DirectoryOrCreate
    name: usr-share-ca-certificates
  - name: imgvalidation
    hostPath:
      path: /etc/kubernetes/imgvalidation
      type: Directory
status: {}

controlplane ~ ➜  #8

controlplane ~ ➜  kubectl apply -f ~/test-deploy.yaml
Error from server (Forbidden): error when creating "/root/test-deploy.yaml": pods "test-deploy" is forbidden: image policy webhook backend denied one or more images: Images using latest tag are not allowed

controlplane ~ ✖ cat ~/test-deply.yaml
cat: /root/test-deply.yaml: No such file or directory

controlplane ~ ✖ cat ~/test-deploy.yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-deploy
spec:
  containers:
  - name: nginx
    image: nginx:latest

controlplane ~ ➜  history
    1  #1
    2  #2
    3  #3
    4  cat /etc/kubernetes/imgvalidation
    5  ls -la /etc/kubernetes/imgvalidation/
    6  cat /etc/kubernetes/imgvalidation/admission-configuration.yaml
    7  cat /etc/kubernetes/imgvalidation/imagepolicy-conf.yaml
    8  cat /etc/kubernetes/imgvalidation/kubeconf.yaml
    9  ls -la /etc/kubernetes/imgvalidation/
   10  cat /etc/kubernetes/imgvalidation/admission-configuration.yaml
   11  cat /etc/kubernetes/imgvalidation/imagepolicy-conf.yaml
   12  cat /etc/kubernetes/imgvalidation/kubeconf.yaml
   13  #3
   14  #4
   15  vi /etc/kubernetes/imgvalidation/imagepolicy-conf.yaml
   16  cat /etc/kubernetes/imgvalidation/imagepolicy-conf.yaml
   17  #5
   18  #6
   19  ls /etc/kubernetes/imgvalidation/kubeconf.yaml
   20* vim /etc/kualidation/kubeconf.yaml
   21  #7
   22  cp /etc/kubernetes/manifests/kube-apiserver.yaml /opt/kube-apiserver.yaml.bak
   23  vi /etc/kubernetes/manifests/kube-apiserver.yaml 
   24  k get pods -n kube-system
   25  cat /etc/kubernetes/manifests/kube-apiserver.yaml 
   26  #8
   27  kubectl apply -f ~/test-deploy.yaml
   28  cat ~/test-deply.yaml
   29  cat ~/test-deploy.yaml
   30  history

```
## 6.3 Multiple Schedulers
```cmd
   Welcome to the KodeKloud Hands-On lab                                                                                                               
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                All rights reserved                                                                                                                           

controlplane ~ ➜  k get po -A -o wide
NAMESPACE      NAME                                   READY   STATUS    RESTARTS   AGE   IP              NODE           NOMINATED NODE   READINESS GATES
kube-flannel   kube-flannel-ds-gpmjn                  1/1     Running   0          14m   10.244.128.51   controlplane   <none>           <none>
kube-system    coredns-6f6c7df987-mvmzn               1/1     Running   0          14m   172.17.0.2      controlplane   <none>           <none>
kube-system    coredns-6f6c7df987-xkppk               1/1     Running   0          14m   172.17.0.3      controlplane   <none>           <none>
kube-system    etcd-controlplane                      1/1     Running   0          14m   10.244.128.51   controlplane   <none>           <none>
kube-system    kube-apiserver-controlplane            1/1     Running   0          14m   10.244.128.51   controlplane   <none>           <none>
kube-system    kube-controller-manager-controlplane   1/1     Running   0          14m   10.244.128.51   controlplane   <none>           <none>
kube-system    kube-proxy-bf8r5                       1/1     Running   0          14m   10.244.128.51   controlplane   <none>           <none>
kube-system    kube-scheduler-controlplane            1/1     Running   0          14m   10.244.128.51   controlplane   <none>           <none>

controlplane ~ ➜  #1

controlplane ~ ➜  #2

controlplane ~ ➜  k describe po kube-scheduler-controlplane
Error from server (NotFound): pods "kube-scheduler-controlplane" not found

controlplane ~ ✖ k describe po -n kube-system kube-scheduler-controlplane | grep -i "image"
    Image:         registry.k8s.io/kube-scheduler:v1.35.0
    Image ID:      registry.k8s.io/kube-scheduler@sha256:0ab622491a82532e01876d55e365c08c5bac01bcd5444a8ed58c1127ab47819f

controlplane ~ ➜  #3

controlplane ~ ➜  kubectl get serviceaccount 
NAME      AGE
default   17m

controlplane ~ ➜  kubectl get serviceaccount -n kube-system
NAME                                          AGE
attachdetach-controller                       17m
bootstrap-signer                              17m
certificate-controller                        17m
clusterrole-aggregation-controller            17m
coredns                                       17m
cronjob-controller                            17m
daemon-set-controller                         17m
default                                       17m
deployment-controller                         17m
disruption-controller                         17m
endpoint-controller                           17m
endpointslice-controller                      17m
endpointslicemirroring-controller             17m
ephemeral-volume-controller                   17m
expand-controller                             17m
generic-garbage-collector                     17m
horizontal-pod-autoscaler                     17m
job-controller                                17m
kube-proxy                                    17m
legacy-service-account-token-cleaner          17m
my-scheduler                                  98s
namespace-controller                          17m
node-controller                               17m
persistent-volume-binder                      17m
pod-garbage-collector                         17m
pv-protection-controller                      17m
pvc-protection-controller                     17m
replicaset-controller                         17m
replication-controller                        17m
resource-claim-controller                     17m
resourcequota-controller                      17m
root-ca-cert-publisher                        17m
service-account-controller                    17m
service-cidrs-controller                      17m
statefulset-controller                        17m
token-cleaner                                 17m
ttl-after-finished-controller                 17m
ttl-controller                                17m
validatingadmissionpolicy-status-controller   17m
volumeattributesclass-protection-controller   17m

controlplane ~ ➜  kubectl get clusterrolebinding
NAME                                                            ROLE                                                                               AGE
cluster-admin                                                   ClusterRole/cluster-admin                                                          18m
flannel                                                         ClusterRole/flannel                                                                18m
kubeadm:cluster-admins                                          ClusterRole/cluster-admin                                                          18m
kubeadm:get-nodes                                               ClusterRole/kubeadm:get-nodes                                                      18m
kubeadm:kubelet-bootstrap                                       ClusterRole/system:node-bootstrapper                                               18m
kubeadm:node-autoapprove-bootstrap                              ClusterRole/system:certificates.k8s.io:certificatesigningrequests:nodeclient       18m
kubeadm:node-autoapprove-certificate-rotation                   ClusterRole/system:certificates.k8s.io:certificatesigningrequests:selfnodeclient   18m
kubeadm:node-proxier                                            ClusterRole/system:node-proxier                                                    18m
my-scheduler-as-kube-scheduler                                  ClusterRole/system:kube-scheduler                                                  115s
my-scheduler-as-volume-scheduler                                ClusterRole/system:volume-scheduler                                                115s
system:basic-user                                               ClusterRole/system:basic-user                                                      18m
system:controller:attachdetach-controller                       ClusterRole/system:controller:attachdetach-controller                              18m
system:controller:certificate-controller                        ClusterRole/system:controller:certificate-controller                               18m
system:controller:clusterrole-aggregation-controller            ClusterRole/system:controller:clusterrole-aggregation-controller                   18m
system:controller:cronjob-controller                            ClusterRole/system:controller:cronjob-controller                                   18m
system:controller:daemon-set-controller                         ClusterRole/system:controller:daemon-set-controller                                18m
system:controller:deployment-controller                         ClusterRole/system:controller:deployment-controller                                18m
system:controller:disruption-controller                         ClusterRole/system:controller:disruption-controller                                18m
system:controller:endpoint-controller                           ClusterRole/system:controller:endpoint-controller                                  18m
system:controller:endpointslice-controller                      ClusterRole/system:controller:endpointslice-controller                             18m
system:controller:endpointslicemirroring-controller             ClusterRole/system:controller:endpointslicemirroring-controller                    18m
system:controller:ephemeral-volume-controller                   ClusterRole/system:controller:ephemeral-volume-controller                          18m
system:controller:expand-controller                             ClusterRole/system:controller:expand-controller                                    18m
system:controller:generic-garbage-collector                     ClusterRole/system:controller:generic-garbage-collector                            18m
system:controller:horizontal-pod-autoscaler                     ClusterRole/system:controller:horizontal-pod-autoscaler                            18m
system:controller:job-controller                                ClusterRole/system:controller:job-controller                                       18m
system:controller:legacy-service-account-token-cleaner          ClusterRole/system:controller:legacy-service-account-token-cleaner                 18m
system:controller:namespace-controller                          ClusterRole/system:controller:namespace-controller                                 18m
system:controller:node-controller                               ClusterRole/system:controller:node-controller                                      18m
system:controller:persistent-volume-binder                      ClusterRole/system:controller:persistent-volume-binder                             18m
system:controller:pod-garbage-collector                         ClusterRole/system:controller:pod-garbage-collector                                18m
system:controller:pv-protection-controller                      ClusterRole/system:controller:pv-protection-controller                             18m
system:controller:pvc-protection-controller                     ClusterRole/system:controller:pvc-protection-controller                            18m
system:controller:replicaset-controller                         ClusterRole/system:controller:replicaset-controller                                18m
system:controller:replication-controller                        ClusterRole/system:controller:replication-controller                               18m
system:controller:resource-claim-controller                     ClusterRole/system:controller:resource-claim-controller                            18m
system:controller:resourcequota-controller                      ClusterRole/system:controller:resourcequota-controller                             18m
system:controller:root-ca-cert-publisher                        ClusterRole/system:controller:root-ca-cert-publisher                               18m
system:controller:route-controller                              ClusterRole/system:controller:route-controller                                     18m
system:controller:selinux-warning-controller                    ClusterRole/system:controller:selinux-warning-controller                           18m
system:controller:service-account-controller                    ClusterRole/system:controller:service-account-controller                           18m
system:controller:service-cidrs-controller                      ClusterRole/system:controller:service-cidrs-controller                             18m
system:controller:service-controller                            ClusterRole/system:controller:service-controller                                   18m
system:controller:statefulset-controller                        ClusterRole/system:controller:statefulset-controller                               18m
system:controller:ttl-after-finished-controller                 ClusterRole/system:controller:ttl-after-finished-controller                        18m
system:controller:ttl-controller                                ClusterRole/system:controller:ttl-controller                                       18m
system:controller:validatingadmissionpolicy-status-controller   ClusterRole/system:controller:validatingadmissionpolicy-status-controller          18m
system:controller:volumeattributesclass-protection-controller   ClusterRole/system:controller:volumeattributesclass-protection-controller          18m
system:coredns                                                  ClusterRole/system:coredns                                                         18m
system:discovery                                                ClusterRole/system:discovery                                                       18m
system:kube-controller-manager                                  ClusterRole/system:kube-controller-manager                                         18m
system:kube-dns                                                 ClusterRole/system:kube-dns                                                        18m
system:kube-scheduler                                           ClusterRole/system:kube-scheduler                                                  18m
system:monitoring                                               ClusterRole/system:monitoring                                                      18m
system:node                                                     ClusterRole/system:node                                                            18m
system:node-proxier                                             ClusterRole/system:node-proxier                                                    18m
system:public-info-viewer                                       ClusterRole/system:public-info-viewer                                              18m
system:service-account-issuer-discovery                         ClusterRole/system:service-account-issuer-discovery                                18m
system:volume-scheduler                                         ClusterRole/system:volume-scheduler                                                18m

controlplane ~ ➜  #4

controlplane ~ ➜  ls /root/
my-scheduler-configmap.yaml  my-scheduler-config.yaml  my-scheduler.yaml  nginx-pod.yaml

controlplane ~ ➜  k create configmap my-scheduler-config --fromfile=/root/my-scheduler-configmap.yaml -n kube-system
error: unknown flag: --fromfile
See 'kubectl create configmap --help' for usage.

controlplane ~ ✖ k create configmap my-scheduler-config --from-file=/root/my-scheduler-configmap.yaml -n kube-system
configmap/my-scheduler-config created

controlplane ~ ➜  k get configmap -n kube-
kube-flannel     kube-node-lease  kube-public      kube-system      

controlplane ~ ➜  k get configmap -n kube-system my-scheduler-config 
NAME                  DATA   AGE
my-scheduler-config   1      27s

controlplane ~ ➜  #5

controlplane ~ ➜  #4

controlplane ~ ➜  kubectl create -f /root/my-scheduler-configmap.yaml
Error from server (AlreadyExists): error when creating "/root/my-scheduler-configmap.yaml": configmaps "my-scheduler-config" already exists

controlplane ~ ✖ #5

controlplane ~ ✖ k get po -A
NAMESPACE      NAME                                   READY   STATUS    RESTARTS   AGE
kube-flannel   kube-flannel-ds-gpmjn                  1/1     Running   0          22m
kube-system    coredns-6f6c7df987-mvmzn               1/1     Running   0          22m
kube-system    coredns-6f6c7df987-xkppk               1/1     Running   0          22m
kube-system    etcd-controlplane                      1/1     Running   0          23m
kube-system    kube-apiserver-controlplane            1/1     Running   0          23m
kube-system    kube-controller-manager-controlplane   1/1     Running   0          23m
kube-system    kube-proxy-bf8r5                       1/1     Running   0          22m
kube-system    kube-scheduler-controlplane            1/1     Running   0          23m

controlplane ~ ➜  k describe po -n kube-system kube-scheduler-controlplane | grep -i "image" -A9
    Image:         registry.k8s.io/kube-scheduler:v1.35.0
    Image ID:      registry.k8s.io/kube-scheduler@sha256:0ab622491a82532e01876d55e365c08c5bac01bcd5444a8ed58c1127ab47819f
    Port:          10259/TCP (probe-port)
    Host Port:     10259/TCP (probe-port)
    Command:
      kube-scheduler
      --authentication-kubeconfig=/etc/kubernetes/scheduler.conf
      --authorization-kubeconfig=/etc/kubernetes/scheduler.conf
      --bind-address=127.0.0.1
      --kubeconfig=/etc/kubernetes/scheduler.conf
      --leader-elect=true

controlplane ~ ➜  vi /root/my-scheduler.yaml

controlplane ~ ➜  cat /root/my-scheduler.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: my-scheduler
  name: my-scheduler
  namespace: kube-system
spec:
  serviceAccountName: my-scheduler
  containers:
  - command:
    - /usr/local/bin/kube-scheduler
    - --config=/etc/kubernetes/my-scheduler/my-scheduler-config.yaml
    image: registry.k8s.io/kube-scheduler:v1.35.0
    livenessProbe:
      httpGet:
        path: /healthz
        port: 10259
        scheme: HTTPS
      initialDelaySeconds: 15
    name: kube-second-scheduler
    readinessProbe:
      httpGet:
        path: /healthz
        port: 10259
        scheme: HTTPS
    resources:
      requests:
        cpu: '0.1'
    securityContext:
      privileged: false
    volumeMounts:
      - name: config-volume
        mountPath: /etc/kubernetes/my-scheduler
  hostNetwork: false
  hostPID: false
  volumes:
    - name: config-volume
      configMap:
        name: my-scheduler-config

controlplane ~ ➜  k create -f /root/my-scheduler.yaml
pod/my-scheduler created

controlplane ~ ➜  #6

controlplane ~ ➜  vi /root/nginx-pod.yaml 

controlplane ~ ➜  k create -f /root/nginx-pod.yaml 
pod/nginx created

controlplane ~ ➜  k get pod -A
NAMESPACE      NAME                                   READY   STATUS             RESTARTS      AGE
default        nginx                                  0/1     Pending            0             5s
kube-flannel   kube-flannel-ds-gpmjn                  1/1     Running            0             26m
kube-system    coredns-6f6c7df987-mvmzn               1/1     Running            0             26m
kube-system    coredns-6f6c7df987-xkppk               1/1     Running            0             26m
kube-system    etcd-controlplane                      1/1     Running            0             27m
kube-system    kube-apiserver-controlplane            1/1     Running            0             27m
kube-system    kube-controller-manager-controlplane   1/1     Running            0             27m
kube-system    kube-proxy-bf8r5                       1/1     Running            0             26m
kube-system    kube-scheduler-controlplane            1/1     Running            0             27m
kube-system    my-scheduler                           0/1     CrashLoopBackOff   4 (79s ago)   2m47s

controlplane ~ ➜  history
    1  k get po -A -o wide
    2  #1
    3  #2
    4  k describe po kube-scheduler-controlplane
    5  k describe po -n kube-system kube-scheduler-controlplane | grep -i "image"
    6  #3
    7  kubectl get serviceaccount 
    8  kubectl get serviceaccount -n kube-system
    9  kubectl get clusterrolebinding
   10  #4
   11  ls /root/
   12  k create configmap my-scheduler-config --fromfile=/root/my-scheduler-configmap.yaml -n kube-system
   13  k create configmap my-scheduler-config --from-file=/root/my-scheduler-configmap.yaml -n kube-system
   14  k get configmap -n kube-system my-scheduler-config 
   15  #5
   16  #4
   17  kubectl create -f /root/my-scheduler-configmap.yaml
   18  #5
   19  k get po -A
   20  k describe po -n kube-system kube-scheduler-controlplane | grep -i "image" -A9
   21  vi /root/my-scheduler.yaml
   22  cat /root/my-scheduler.yaml
   23  k create -f /root/my-scheduler.yaml
   24  #6
   25  vi /root/nginx-pod.yaml 
   26  k create -f /root/nginx-pod.yaml 
   27  k get pod -A
   28  history

```
## 6.2 Static Pod
```cmd
          Welcome to the KodeKloud Hands-On lab                                                                                                               
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
                All rights reserved                                                                                                                           

controlplane ~ ➜  k get po -A
NAMESPACE      NAME                                   READY   STATUS    RESTARTS   AGE
kube-flannel   kube-flannel-ds-t8x5r                  1/1     Running   0          20m
kube-flannel   kube-flannel-ds-zm9kp                  1/1     Running   0          21m
kube-system    coredns-6f6c7df987-ldpzs               1/1     Running   0          21m
kube-system    coredns-6f6c7df987-ljptr               1/1     Running   0          21m
kube-system    etcd-controlplane                      1/1     Running   0          21m
kube-system    kube-apiserver-controlplane            1/1     Running   0          21m
kube-system    kube-controller-manager-controlplane   1/1     Running   0          21m
kube-system    kube-proxy-9bvng                       1/1     Running   0          21m
kube-system    kube-proxy-m6crs                       1/1     Running   0          20m
kube-system    kube-scheduler-controlplane            1/1     Running   0          21m

controlplane ~ ➜  #1

controlplane ~ ➜  #2

controlplane ~ ➜  #3

controlplane ~ ➜  #4

controlplane ~ ➜  k get po -A -o ưide
error: unable to match a printer suitable for the output format "ưide", allowed formats are: custom-columns,custom-columns-file,go-template,go-template-file,json,jsonpath,jsonpath-as-json,jsonpath-file,kyaml,name,template,templatefile,wide,yaml

controlplane ~ ✖ k get po -A -o wide
NAMESPACE      NAME                                   READY   STATUS    RESTARTS   AGE   IP               NODE           NOMINATED NODE   READINESS GATES
kube-flannel   kube-flannel-ds-t8x5r                  1/1     Running   0          21m   10.244.220.232   node01         <none>           <none>
kube-flannel   kube-flannel-ds-zm9kp                  1/1     Running   0          22m   10.244.241.21    controlplane   <none>           <none>
kube-system    coredns-6f6c7df987-ldpzs               1/1     Running   0          22m   172.17.0.2       controlplane   <none>           <none>
kube-system    coredns-6f6c7df987-ljptr               1/1     Running   0          22m   172.17.0.3       controlplane   <none>           <none>
kube-system    etcd-controlplane                      1/1     Running   0          22m   10.244.241.21    controlplane   <none>           <none>
kube-system    kube-apiserver-controlplane            1/1     Running   0          22m   10.244.241.21    controlplane   <none>           <none>
kube-system    kube-controller-manager-controlplane   1/1     Running   0          22m   10.244.241.21    controlplane   <none>           <none>
kube-system    kube-proxy-9bvng                       1/1     Running   0          22m   10.244.241.21    controlplane   <none>           <none>
kube-system    kube-proxy-m6crs                       1/1     Running   0          21m   10.244.220.232   node01         <none>           <none>
kube-system    kube-scheduler-controlplane            1/1     Running   0          22m   10.244.241.21    controlplane   <none>           <none>

controlplane ~ ➜  #5

controlplane ~ ➜  cat /var/lib/kubelet/config.yaml
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    cacheTTL: 0s
    enabled: true
  x509:
    clientCAFile: /etc/kubernetes/pki/ca.crt
authorization:
  mode: Webhook
  webhook:
    cacheAuthorizedTTL: 0s
    cacheUnauthorizedTTL: 0s
cgroupDriver: systemd
clusterDNS:
- 172.20.0.10
clusterDomain: cluster.local
containerRuntimeEndpoint: unix:///var/run/containerd/containerd.sock
cpuManagerReconcilePeriod: 0s
crashLoopBackOff: {}
evictionPressureTransitionPeriod: 0s
fileCheckFrequency: 0s
healthzBindAddress: 127.0.0.1
healthzPort: 10248
httpCheckFrequency: 0s
imageMaximumGCAge: 0s
imageMinimumGCAge: 0s
kind: KubeletConfiguration
logging:
  flushFrequency: 0
  options:
    json:
      infoBufferSize: "0"
    text:
      infoBufferSize: "0"
  verbosity: 0
memorySwap: {}
nodeStatusReportFrequency: 0s
nodeStatusUpdateFrequency: 0s
rotateCertificates: true
runtimeRequestTimeout: 0s
shutdownGracePeriod: 0s
shutdownGracePeriodCriticalPods: 0s
staticPodPath: /etc/kubernetes/manifests
streamingConnectionIdleTimeout: 0s
syncFrequency: 0s
volumeStatsAggPeriod: 0s

controlplane ~ ➜  ^C

controlplane ~ ✖ ls /etc/kubernetes/manifests
etcd.yaml  kube-apiserver.yaml  kube-controller-manager.yaml  kube-scheduler.yaml

controlplane ~ ➜  cat /etc/kubernetes/manifests/etcd.yaml 
apiVersion: v1
kind: Pod
metadata:
  annotations:
    kubeadm.kubernetes.io/etcd.advertise-client-urls: https://10.244.241.21:2379
  labels:
    component: etcd
    tier: control-plane
  name: etcd
  namespace: kube-system
spec:
  containers:
  - command:
    - etcd
    - --advertise-client-urls=https://10.244.241.21:2379
    - --cert-file=/etc/kubernetes/pki/etcd/server.crt
    - --client-cert-auth=true
    - --data-dir=/var/lib/etcd
    - --feature-gates=InitialCorruptCheck=true
    - --initial-advertise-peer-urls=https://10.244.241.21:2380
    - --initial-cluster=controlplane=https://10.244.241.21:2380
    - --key-file=/etc/kubernetes/pki/etcd/server.key
    - --listen-client-urls=https://127.0.0.1:2379,https://10.244.241.21:2379
    - --listen-metrics-urls=http://127.0.0.1:2381
    - --listen-peer-urls=https://10.244.241.21:2380
    - --name=controlplane
    - --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
    - --peer-client-cert-auth=true
    - --peer-key-file=/etc/kubernetes/pki/etcd/peer.key
    - --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
    - --snapshot-count=10000
    - --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
    - --watch-progress-notify-interval=5s
    image: registry.k8s.io/etcd:3.6.6-0
    imagePullPolicy: IfNotPresent
    livenessProbe:
      failureThreshold: 8
      httpGet:
        host: 127.0.0.1
        path: /livez
        port: probe-port
        scheme: HTTP
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 15
    name: etcd
    ports:
    - containerPort: 2381
      name: probe-port
      protocol: TCP
    readinessProbe:
      failureThreshold: 3
      httpGet:
        host: 127.0.0.1
        path: /readyz
        port: probe-port
        scheme: HTTP
      periodSeconds: 1
      timeoutSeconds: 15
    resources:
      requests:
        cpu: 100m
        memory: 100Mi
    startupProbe:
      failureThreshold: 24
      httpGet:
        host: 127.0.0.1
        path: /readyz
        port: probe-port
        scheme: HTTP
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 15
    volumeMounts:
    - mountPath: /var/lib/etcd
      name: etcd-data
    - mountPath: /etc/kubernetes/pki/etcd
      name: etcd-certs
  hostNetwork: true
  priority: 2000001000
  priorityClassName: system-node-critical
  securityContext:
    seccompProfile:
      type: RuntimeDefault
  volumes:
  - hostPath:
      path: /etc/kubernetes/pki/etcd
      type: DirectoryOrCreate
    name: etcd-certs
  - hostPath:
      path: /var/lib/etcd
      type: DirectoryOrCreate
    name: etcd-data
status: {}

controlplane ~ ➜  #6

controlplane ~ ➜  #7

controlplane ~ ➜  ps -aux | grep kubelet
bad data in /proc/uptime
root        3226  0.0  0.4 1516240 276096 ?      Ssl  13:08   0:33 kube-apiserver --advertise-address=10.244.241.21 --allow-privileged=true --authorization-mode=Node,RBAC --client-ca-file=/etc/kubernetes/pki/ca.crt --enable-admission-plugins=NodeRestriction --enable-bootstrap-token-auth=true --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key --etcd-servers=https://127.0.0.1:2379 --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key --requestheader-allowed-names=front-proxy-client --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt --requestheader-extra-headers-prefix=X-Remote-Extra- --requestheader-group-headers=X-Remote-Group --requestheader-username-headers=X-Remote-User --secure-port=6443 --service-account-issuer=https://kubernetes.default.svc.cluster.local --service-account-key-file=/etc/kubernetes/pki/sa.pub --service-account-signing-key-file=/etc/kubernetes/pki/sa.key --service-cluster-ip-range=172.20.0.0/16 --tls-cert-file=/etc/kubernetes/pki/apiserver.crt --tls-private-key-file=/etc/kubernetes/pki/apiserver.key
root        3780  0.0  0.1 2987460 91564 ?       Ssl  13:08   0:20 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml
root       17887  0.0  0.0   6932  2432 pts/2    S+   13:35   0:00 grep --color=auto kubelet

controlplane ~ ➜  cat /etc/kubernetes/manifests/kube-apiserver.yaml 
apiVersion: v1
kind: Pod
metadata:
  annotations:
    kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint: 10.244.241.21:6443
  labels:
    component: kube-apiserver
    tier: control-plane
  name: kube-apiserver
  namespace: kube-system
spec:
  containers:
  - command:
    - kube-apiserver
    - --advertise-address=10.244.241.21
    - --allow-privileged=true
    - --authorization-mode=Node,RBAC
    - --client-ca-file=/etc/kubernetes/pki/ca.crt
    - --enable-admission-plugins=NodeRestriction
    - --enable-bootstrap-token-auth=true
    - --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt
    - --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt
    - --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key
    - --etcd-servers=https://127.0.0.1:2379
    - --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt
    - --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key
    - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
    - --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt
    - --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key
    - --requestheader-allowed-names=front-proxy-client
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
      failureThreshold: 8
      httpGet:
        host: 10.244.241.21
        path: /livez
        port: probe-port
        scheme: HTTPS
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 15
    name: kube-apiserver
    ports:
    - containerPort: 6443
      name: probe-port
      protocol: TCP
    readinessProbe:
      failureThreshold: 3
      httpGet:
        host: 10.244.241.21
        path: /readyz
        port: probe-port
        scheme: HTTPS
      periodSeconds: 1
      timeoutSeconds: 15
    resources:
      requests:
        cpu: 250m
    startupProbe:
      failureThreshold: 24
      httpGet:
        host: 10.244.241.21
        path: /livez
        port: probe-port
        scheme: HTTPS
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 15
    volumeMounts:
    - mountPath: /etc/ssl/certs
      name: ca-certs
      readOnly: true
    - mountPath: /etc/ca-certificates
      name: etc-ca-certificates
      readOnly: true
    - mountPath: /etc/kubernetes/pki
      name: k8s-certs
      readOnly: true
    - mountPath: /usr/local/share/ca-certificates
      name: usr-local-share-ca-certificates
      readOnly: true
    - mountPath: /usr/share/ca-certificates
      name: usr-share-ca-certificates
      readOnly: true
  hostNetwork: true
  priority: 2000001000
  priorityClassName: system-node-critical
  securityContext:
    seccompProfile:
      type: RuntimeDefault
  volumes:
  - hostPath:
      path: /etc/ssl/certs
      type: DirectoryOrCreate
    name: ca-certs
  - hostPath:
      path: /etc/ca-certificates
      type: DirectoryOrCreate
    name: etc-ca-certificates
  - hostPath:
      path: /etc/kubernetes/pki
      type: DirectoryOrCreate
    name: k8s-certs
  - hostPath:
      path: /usr/local/share/ca-certificates
      type: DirectoryOrCreate
    name: usr-local-share-ca-certificates
  - hostPath:
      path: /usr/share/ca-certificates
      type: DirectoryOrCreate
    name: usr-share-ca-certificates
status: {}

controlplane ~ ➜  #8

controlplane ~ ➜  k run static-busybox --image=busybox -n default --dry-run=client =oyaml command sleep 1000 > static-busybox.yaml

controlplane ~ ➜  ls
static-busybox.yaml

controlplane ~ ➜  cp static-busybox.yaml /etc/kubernetes/manifests

controlplane ~ ➜  ls /etc/kubernetes/manifests
etcd.yaml  kube-apiserver.yaml  kube-controller-manager.yaml  kube-scheduler.yaml  static-busybox.yaml

controlplane ~ ➜  k get pod -A
NAMESPACE      NAME                                   READY   STATUS    RESTARTS   AGE
kube-flannel   kube-flannel-ds-t8x5r                  1/1     Running   0          30m
kube-flannel   kube-flannel-ds-zm9kp                  1/1     Running   0          31m
kube-system    coredns-6f6c7df987-ldpzs               1/1     Running   0          31m
kube-system    coredns-6f6c7df987-ljptr               1/1     Running   0          31m
kube-system    etcd-controlplane                      1/1     Running   0          31m
kube-system    kube-apiserver-controlplane            1/1     Running   0          31m
kube-system    kube-controller-manager-controlplane   1/1     Running   0          31m
kube-system    kube-proxy-9bvng                       1/1     Running   0          31m
kube-system    kube-proxy-m6crs                       1/1     Running   0          30m
kube-system    kube-scheduler-controlplane            1/1     Running   0          31m

controlplane ~ ➜  k get pod -A -w
NAMESPACE      NAME                                   READY   STATUS    RESTARTS   AGE
kube-flannel   kube-flannel-ds-t8x5r                  1/1     Running   0          31m
kube-flannel   kube-flannel-ds-zm9kp                  1/1     Running   0          31m
kube-system    coredns-6f6c7df987-ldpzs               1/1     Running   0          31m
kube-system    coredns-6f6c7df987-ljptr               1/1     Running   0          31m
kube-system    etcd-controlplane                      1/1     Running   0          31m
kube-system    kube-apiserver-controlplane            1/1     Running   0          31m
kube-system    kube-controller-manager-controlplane   1/1     Running   0          31m
kube-system    kube-proxy-9bvng                       1/1     Running   0          31m
kube-system    kube-proxy-m6crs                       1/1     Running   0          31m
kube-system    kube-scheduler-controlplane            1/1     Running   0          31m
^C^C
controlplane ~ ✖ vi static-busybox.yaml 

controlplane ~ ➜  k run static-box --image=busybox -n default --dry-run=client -oyaml --command -- sleep 1000 > /etc/kubernetes/manifests/static-busybox.yaml

controlplane ~ ➜  vi /etc/kubernetes/manifests/static-busybox.yaml

controlplane ~ ➜  vi /etc/kubernetes/manifests/static-busybox.yaml

controlplane ~ ➜  ls /etc/kubernetes/manifests/
etcd.yaml  kube-apiserver.yaml  kube-controller-manager.yaml  kube-scheduler.yaml  static-busybox.yaml

controlplane ~ ➜  vi /etc/kubernetes/manifests/static-busybox.yaml

controlplane ~ ➜  #9

controlplane ~ ➜  vi /etc/kubernetes/manifests/static-busybox.yaml

controlplane ~ ➜  vi /etc/kubernetes/manifests/static-busybox.yaml

controlplane ~ ➜  vi /etc/kubernetes/manifests/static-busybox.yaml

controlplane ~ ➜  #10

controlplane ~ ➜  ls /etc/kubernetes/manifests/
etcd.yaml  kube-apiserver.yaml  kube-controller-manager.yaml  kube-scheduler.yaml  static-busybox.yaml

controlplane ~ ➜  ssh node01
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.8.0-90-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

This system has been minimized by removing packages and content that are
not required on a system that users do not log into.

To restore this content, you can run the 'unminimize' command.

node01 ~ ➜  ls

node01 ~ ➜  ls /etc/kubernetes/manifests

node01 ~ ➜  ls --all
.  ..  .bash_profile  .bashrc  .cache  .config  .profile  .ssh  .terminal_logs  .vim  .vimrc  .wget-hsts

node01 ~ ➜  ls /var/lib/kubelet/config.yaml
/var/lib/kubelet/config.yaml

node01 ~ ➜  cat /var/lib/kubelet/config.yaml
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    cacheTTL: 0s
    enabled: true
  x509:
    clientCAFile: /etc/kubernetes/pki/ca.crt
authorization:
  mode: Webhook
  webhook:
    cacheAuthorizedTTL: 0s
    cacheUnauthorizedTTL: 0s
cgroupDriver: systemd
clusterDNS:
- 172.20.0.10
clusterDomain: cluster.local
containerRuntimeEndpoint: unix:///var/run/containerd/containerd.sock
cpuManagerReconcilePeriod: 0s
crashLoopBackOff: {}
evictionPressureTransitionPeriod: 0s
fileCheckFrequency: 0s
healthzBindAddress: 127.0.0.1
healthzPort: 10248
httpCheckFrequency: 0s
imageMaximumGCAge: 0s
imageMinimumGCAge: 0s
kind: KubeletConfiguration
logging:
  flushFrequency: 0
  options:
    json:
      infoBufferSize: "0"
    text:
      infoBufferSize: "0"
  verbosity: 0
memorySwap: {}
nodeStatusReportFrequency: 0s
nodeStatusUpdateFrequency: 0s
rotateCertificates: true
runtimeRequestTimeout: 0s
shutdownGracePeriod: 0s
shutdownGracePeriodCriticalPods: 0s
staticPodPath: /etc/just-to-mess-with-you
streamingConnectionIdleTimeout: 0s
syncFrequency: 0s
volumeStatsAggPeriod: 0s

node01 ~ ➜  ls /etc/just-to-mess-with-you/
greenbox.yaml

node01 ~ ➜  vi /etc/just-to-mess-with-you/greenbox.yaml 

node01 ~ ➜  rm /etc/just-to-mess-with-you/greenbox.yaml 

node01 ~ ➜  ls /etc/just-to-mess-with-you/

node01 ~ ➜  
logout
Connection to node01 closed.

controlplane ~ ➜  k get pods -A -o wide
NAMESPACE      NAME                                   READY   STATUS    RESTARTS   AGE   IP               NODE           NOMINATED NODE   READINESS GATES
default        static-busybox-controlplane            1/1     Running   0          10m   172.17.0.6       controlplane   <none>           <none>
kube-flannel   kube-flannel-ds-t8x5r                  1/1     Running   0          51m   10.244.220.232   node01         <none>           <none>
kube-flannel   kube-flannel-ds-zm9kp                  1/1     Running   0          52m   10.244.241.21    controlplane   <none>           <none>
kube-system    coredns-6f6c7df987-ldpzs               1/1     Running   0          52m   172.17.0.2       controlplane   <none>           <none>
kube-system    coredns-6f6c7df987-ljptr               1/1     Running   0          52m   172.17.0.3       controlplane   <none>           <none>
kube-system    etcd-controlplane                      1/1     Running   0          52m   10.244.241.21    controlplane   <none>           <none>
kube-system    kube-apiserver-controlplane            1/1     Running   0          52m   10.244.241.21    controlplane   <none>           <none>
kube-system    kube-controller-manager-controlplane   1/1     Running   0          52m   10.244.241.21    controlplane   <none>           <none>
kube-system    kube-proxy-9bvng                       1/1     Running   0          52m   10.244.241.21    controlplane   <none>           <none>
kube-system    kube-proxy-m6crs                       1/1     Running   0          51m   10.244.220.232   node01         <none>           <none>
kube-system    kube-scheduler-controlplane            1/1     Running   0          52m   10.244.241.21    controlplane   <none>           <none>

controlplane ~ ➜  ssh node01
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.8.0-90-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

This system has been minimized by removing packages and content that are
not required on a system that users do not log into.

To restore this content, you can run the 'unminimize' command.
Last login: Thu May 28 13:54:48 2026 from 10.244.241.21

node01 ~ ➜  ps -ef | grep /usr/bin/kubelet
root       21626       1  0 13:52 ?        00:00:04 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml
root       29458   29291  0 14:04 pts/0    00:00:00 grep /usr/bin/kubelet

node01 ~ ➜  grep - staticpod /var/lib/kubelet/config.yaml
grep: staticpod: No such file or directory
/var/lib/kubelet/config.yaml:- 172.20.0.10
/var/lib/kubelet/config.yaml:staticPodPath: /etc/just-to-mess-with-you

node01 ~ ✖ grep -i staticpod /var/lib/kubelet/config.yaml
staticPodPath: /etc/just-to-mess-with-you

node01 ~ ➜  histroy
-bash: histroy: command not found

node01 ~ ✖ history
    1  ls
    2  ls /etc/kubernetes/manifests
    3  ls --all
    4  ls /var/lib/kubelet/config.yaml
    5  cat /var/lib/kubelet/config.yaml
    6  ls /etc/just-to-mess-with-you/
    7  vi /etc/just-to-mess-with-you/greenbox.yaml 
    8  rm /etc/just-to-mess-with-you/greenbox.yaml 
    9  ls /etc/just-to-mess-with-you/
   10  ps -ef | grep /usr/bin/kubelet
   11  grep - staticpod /var/lib/kubelet/config.yaml
   12  grep -i staticpod /var/lib/kubelet/config.yaml
   13  histroy
   14  history

node01 ~ ➜  
logout
Connection to node01 closed.

controlplane ~ ➜  history
    1  k get po -A
    2  #1
    3  #2
    4  #3
    5  #4
    6  k get po -A -o ưide
    7  k get po -A -o wide
    8  #5
    9  cat /var/lib/kubelet/config.yaml
   10  ls /etc/kubernetes/manifests
   11  cat /etc/kubernetes/manifests/etcd.yaml 
   12  #6
   13  #7
   14  ps -aux | grep kubelet
   15  cat /etc/kubernetes/manifests/kube-apiserver.yaml 
   16  #8
   17  k run static-busybox --image=busybox -n default --dry-run=client =oyaml command sleep 1000 > static-busybox.yaml
   18  ls
   19  cp static-busybox.yaml /etc/kubernetes/manifests
   20  ls /etc/kubernetes/manifests
   21  k get pod -A
   22  k get pod -A -w
   23  vi static-busybox.yaml 
   24  k run static-box --image=busybox -n default --dry-run=client -oyaml --command -- sleep 1000 > /etc/kubernetes/manifests/static-busybox.yaml
   25  vi /etc/kubernetes/manifests/static-busybox.yaml
   26  ls /etc/kubernetes/manifests/
   27  vi /etc/kubernetes/manifests/static-busybox.yaml
   28  #9
   29  vi /etc/kubernetes/manifests/static-busybox.yaml
   30  #10
   31  ls /etc/kubernetes/manifests/
   32  ssh node01
   33  k get pods -A -o wide
   34  ssh node01
   35  history
```
## 6.1 DaemonSets 
```cmd
       Welcome to the KodeKloud Hands-On lab                                                                       
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
            All rights reserved                                                                                    

controlplane ~ ➜  k get ds -a
error: unknown shorthand flag: 'a' in -a
See 'kubectl get --help' for usage.

controlplane ~ ✖ k get ds -A
NAMESPACE      NAME              DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
kube-flannel   kube-flannel-ds   1         1         1       1            1           <none>                   9m45s
kube-system    kube-proxy        1         1         1       1            1           kubernetes.io/os=linux   9m46s

controlplane ~ ➜  k get ds --help
Display one or many resources.

 Prints a table of the most important information about the specified resources. You can filter the list using a label
selector and the --selector flag. If the desired resource type is namespaced you will only see results in the current
namespace if you don't specify any namespace.

 By specifying the output as 'template' and providing a Go template as the value of the --template flag, you can filter
the attributes of the fetched resources.

Use "kubectl api-resources" for a complete list of supported resources.

Examples:
  # List all pods in ps output format
  kubectl get pods
  
  # List all pods in ps output format with more information (such as node name)
  kubectl get pods -o wide
  
  # List a single replication controller with specified NAME in ps output format
  kubectl get replicationcontroller web
  
  # List deployments in JSON output format, in the "v1" version of the "apps" API group
  kubectl get deployments.v1.apps -o json
  
  # List a single pod in JSON output format
  kubectl get -o json pod web-pod-13je7
  
  # List a pod identified by type and name specified in "pod.yaml" in JSON output format
  kubectl get -f pod.yaml -o json
  
  # List resources from a directory with kustomization.yaml - e.g. dir/kustomization.yaml
  kubectl get -k dir/
  
  # Return only the phase value of the specified pod
  kubectl get -o template pod/web-pod-13je7 --template={{.status.phase}}
  
  # List resource information in custom columns
  kubectl get pod test-pod -o custom-columns=CONTAINER:.spec.containers[0].name,IMAGE:.spec.containers[0].image
  
  # List all replication controllers and services together in ps output format
  kubectl get rc,services
  
  # List one or more resources by their type and names
  kubectl get rc/web service/frontend pods/web-pod-13je7
  
  # List the 'status' subresource for a single pod
  kubectl get pod web-pod-13je7 --subresource status
  
  # List all deployments in namespace 'backend'
  kubectl get deployments.apps --namespace backend
  
  # List all pods existing in all namespaces
  kubectl get pods --all-namespaces

Options:
    -A, --all-namespaces=false:
        If present, list the requested object(s) across all namespaces. Namespace in current context is ignored even
        if specified with --namespace.

    --allow-missing-template-keys=true:
        If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to
        golang and jsonpath output formats.

    --chunk-size=500:
        Return large lists in chunks rather than all at once. Pass 0 to disable.

    --field-selector='':
        Selector (field query) to filter on, supports '=', '==', and '!='.(e.g. --field-selector
        key1=value1,key2=value2). The server only supports a limited number of field queries per type.

    -f, --filename=[]:
        Filename, directory, or URL to files identifying the resource to get from a server.

    --ignore-not-found=false:
        If set to true, suppresses NotFound error for specific objects that do not exist. Using this flag with
        commands that query for collections of resources has no effect when no resources are found.

    -k, --kustomize='':
        Process the kustomization directory. This flag can't be used together with -f or -R.

    -L, --label-columns=[]:
        Accepts a comma separated list of labels that are going to be presented as columns. Names are case-sensitive.
        You can also use multiple flag options like -L label1 -L label2...

    --no-headers=false:
        When using the default or custom-column output format, don't print headers (default print headers).

    -o, --output='':
        Output format. One of: (json, yaml, kyaml, name, go-template, go-template-file, template, templatefile,
        jsonpath, jsonpath-as-json, jsonpath-file, custom-columns, custom-columns-file, wide). See custom columns
        [https://kubernetes.io/docs/reference/kubectl/#custom-columns], golang template
        [http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template
        [https://kubernetes.io/docs/reference/kubectl/jsonpath/].

    --output-watch-events=false:
        Output watch event objects when --watch or --watch-only is used. Existing objects are output as initial ADDED
        events.

    --raw='':
        Raw URI to request from the server.  Uses the transport specified by the kubeconfig file.

    -R, --recursive=false:
        Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests
        organized within the same directory.

    -l, --selector='':
        Selector (label query) to filter on, supports '=', '==', '!=', 'in', 'notin'.(e.g. -l
        key1=value1,key2=value2,key3 in (value3)). Matching objects must satisfy all of the specified label
        constraints.

    --server-print=true:
        If true, have the server return the appropriate table output. Supports extension APIs and CRDs.

    --show-kind=false:
        If present, list the resource type for the requested object(s).

    --show-labels=false:
        When printing, show all labels as the last column (default hide labels column)

    --show-managed-fields=false:
        If true, keep the managedFields when printing objects in JSON or YAML format.

    --sort-by='':
        If non-empty, sort list types using this field specification.  The field specification is expressed as a
        JSONPath expression (e.g. '{.metadata.name}'). The field in the API resource specified by this JSONPath
        expression must be an integer or a string.

    --subresource='':
        If specified, gets the subresource of the requested object.

    --template='':
        Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format
        is golang templates [http://golang.org/pkg/text/template/#pkg-overview].

    -w, --watch=false:
        After listing/getting the requested object, watch for changes.

    --watch-only=false:
        Watch for changes to the requested object(s), without listing/getting first.

Usage:
  kubectl get
[(-o|--output=)json|yaml|kyaml|name|go-template|go-template-file|template|templatefile|jsonpath|jsonpath-as-json|jsonpath-file|custom-columns|custom-columns-file|wide]
(TYPE[.VERSION][.GROUP] [NAME | -l label] | TYPE[.VERSION][.GROUP]/NAME ...) [flags] [options]

Use "kubectl options" for a list of global command-line options (applies to all commands).

controlplane ~ ➜  #1 above

controlplane ~ ➜  #2

controlplane ~ ➜  k get ds -A -o wide
NAMESPACE      NAME              DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE   CONTAINERS     IMAGES                               SELECTOR
kube-flannel   kube-flannel-ds   1         1         1       1            1           <none>                   11m   kube-flannel   docker.io/flannel/flannel:v0.23.0    app=flannel,k8s-app=flannel
kube-system    kube-proxy        1         1         1       1            1           kubernetes.io/os=linux   11m   kube-proxy     registry.k8s.io/kube-proxy:v1.35.0   k8s-app=kube-proxy

controlplane ~ ➜  k describe ds kube-proxy -n kube-system
Name:           kube-proxy
Namespace:      kube-system
Selector:       k8s-app=kube-proxy
Node-Selector:  kubernetes.io/os=linux
Labels:         k8s-app=kube-proxy
Annotations:    deprecated.daemonset.template.generation: 1
Desired Number of Nodes Scheduled: 1
Current Number of Nodes Scheduled: 1
Number of Nodes Scheduled with Up-to-date Pods: 1
Number of Nodes Scheduled with Available Pods: 1
Number of Nodes Misscheduled: 0
Pods Status:  1 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:           k8s-app=kube-proxy
  Service Account:  kube-proxy
  Containers:
   kube-proxy:
    Image:      registry.k8s.io/kube-proxy:v1.35.0
    Port:       <none>
    Host Port:  <none>
    Command:
      /usr/local/bin/kube-proxy
      --config=/var/lib/kube-proxy/config.conf
      --hostname-override=$(NODE_NAME)
    Environment:
      NODE_NAME:   (v1:spec.nodeName)
    Mounts:
      /lib/modules from lib-modules (ro)
      /run/xtables.lock from xtables-lock (rw)
      /var/lib/kube-proxy from kube-proxy (rw)
  Volumes:
   kube-proxy:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      kube-proxy
    Optional:  false
   xtables-lock:
    Type:          HostPath (bare host directory volume)
    Path:          /run/xtables.lock
    HostPathType:  FileOrCreate
   lib-modules:
    Type:               HostPath (bare host directory volume)
    Path:               /lib/modules
    HostPathType:       
  Priority Class Name:  system-node-critical
  Node-Selectors:       kubernetes.io/os=linux
  Tolerations:          op=Exists
Events:
  Type    Reason            Age   From                  Message
  ----    ------            ----  ----                  -------
  Normal  SuccessfulCreate  16m   daemonset-controller  Created pod: kube-proxy-2s4zh

controlplane ~ ➜  #4

controlplane ~ ➜  #5

controlplane ~ ➜  k describe ds kube-flannel-ds
Error from server (NotFound): daemonsets.apps "kube-flannel-ds" not found

controlplane ~ ✖ k describe ds kube-flannel-ds -n kube-flannel 
Name:           kube-flannel-ds
Namespace:      kube-flannel
Selector:       app=flannel,k8s-app=flannel
Node-Selector:  <none>
Labels:         app=flannel
                k8s-app=flannel
                tier=node
Annotations:    deprecated.daemonset.template.generation: 1
Desired Number of Nodes Scheduled: 1
Current Number of Nodes Scheduled: 1
Number of Nodes Scheduled with Up-to-date Pods: 1
Number of Nodes Scheduled with Available Pods: 1
Number of Nodes Misscheduled: 0
Pods Status:  1 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:           app=flannel
                    k8s-app=flannel
                    tier=node
  Service Account:  flannel
  Init Containers:
   install-cni-plugin:
    Image:      docker.io/flannel/flannel-cni-plugin:v1.2.0
    Port:       <none>
    Host Port:  <none>
    Command:
      cp
    Args:
      -f
      /flannel
      /opt/cni/bin/flannel
    Environment:  <none>
    Mounts:
      /opt/cni/bin from cni-plugin (rw)
   install-cni:
    Image:      docker.io/flannel/flannel:v0.23.0
    Port:       <none>
    Host Port:  <none>
    Command:
      cp
    Args:
      -f
      /etc/kube-flannel/cni-conf.json
      /etc/cni/net.d/10-flannel.conflist
    Environment:  <none>
    Mounts:
      /etc/cni/net.d from cni (rw)
      /etc/kube-flannel/ from flannel-cfg (rw)
  Containers:
   kube-flannel:
    Image:      docker.io/flannel/flannel:v0.23.0
    Port:       <none>
    Host Port:  <none>
    Command:
      /opt/bin/flanneld
    Args:
      --ip-masq
      --kube-subnet-mgr
      --iface=eth0
    Requests:
      cpu:     100m
      memory:  50Mi
    Environment:
      POD_NAME:            (v1:metadata.name)
      POD_NAMESPACE:       (v1:metadata.namespace)
      EVENT_QUEUE_DEPTH:  5000
    Mounts:
      /etc/kube-flannel/ from flannel-cfg (rw)
      /run/flannel from run (rw)
      /run/xtables.lock from xtables-lock (rw)
  Volumes:
   run:
    Type:          HostPath (bare host directory volume)
    Path:          /run/flannel
    HostPathType:  
   cni-plugin:
    Type:          HostPath (bare host directory volume)
    Path:          /opt/cni/bin
    HostPathType:  
   cni:
    Type:          HostPath (bare host directory volume)
    Path:          /etc/cni/net.d
    HostPathType:  
   flannel-cfg:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      kube-flannel-cfg
    Optional:  false
   xtables-lock:
    Type:               HostPath (bare host directory volume)
    Path:               /run/xtables.lock
    HostPathType:       FileOrCreate
  Priority Class Name:  system-node-critical
  Node-Selectors:       <none>
  Tolerations:          :NoSchedule op=Exists
Events:
  Type    Reason            Age   From                  Message
  ----    ------            ----  ----                  -------
  Normal  SuccessfulCreate  17m   daemonset-controller  Created pod: kube-flannel-ds-rlgph

controlplane ~ ➜  k describe ds kube-flannel-ds -n kube-flannel | grep -i image
    Image:      docker.io/flannel/flannel-cni-plugin:v1.2.0
    Image:      docker.io/flannel/flannel:v0.23.0
    Image:      docker.io/flannel/flannel:v0.23.0

controlplane ~ ➜  k describe ds kube-flannel-ds -n kube-flannel | grep -i image -A5
    Image:      docker.io/flannel/flannel-cni-plugin:v1.2.0
    Port:       <none>
    Host Port:  <none>
    Command:
      cp
    Args:
--
    Image:      docker.io/flannel/flannel:v0.23.0
    Port:       <none>
    Host Port:  <none>
    Command:
      cp
    Args:
--
    Image:      docker.io/flannel/flannel:v0.23.0
    Port:       <none>
    Host Port:  <none>
    Command:
      /opt/bin/flanneld
    Args:

controlplane ~ ➜  #6
stem --image=registry.k8s.io/fluentd-elasticsearch:1.2
controlplane ~ ➜  k create ds elasticsearch -n kube-system --image=registry.k8s.io/fluentd-elasticsearch:1.20
error: unknown flag: --image
See 'kubectl create --help' for usage.

controlplane ~ ✖ k create ds --help
Create a resource from a file or from stdin.

 JSON and YAML formats are accepted.

Examples:
  # Create a pod using the data in pod.json
  kubectl create -f ./pod.json
  
  # Create a pod based on the JSON passed into stdin
  cat pod.json | kubectl create -f -
  
  # Edit the data in registry.yaml in JSON then create the resource using the edited data
  kubectl create -f registry.yaml --edit -o json

Available Commands:
  clusterrole           Create a cluster role
  clusterrolebinding    Create a cluster role binding for a particular cluster role
  configmap             Create a config map from a local file, directory or literal value
  cronjob               Create a cron job with the specified name
  deployment            Create a deployment with the specified name
  ingress               Create an ingress with the specified name
  job                   Create a job with the specified name
  namespace             Create a namespace with the specified name
  poddisruptionbudget   Create a pod disruption budget with the specified name
  priorityclass         Create a priority class with the specified name
  quota                 Create a quota with the specified name
  role                  Create a role with single rule
  rolebinding           Create a role binding for a particular role or cluster role
  secret                Create a secret using a specified subcommand
  service               Create a service using a specified subcommand
  serviceaccount        Create a service account with the specified name
  token                 Request a service account token

Options:
    --allow-missing-template-keys=true:
        If true, ignore any errors in templates when a field or map key is missing in the
        template. Only applies to golang and jsonpath output formats.

    --dry-run='none':
        Must be "none", "server", or "client". If client strategy, only print the object that
        would be sent, without sending it. If server strategy, submit server-side request without
        persisting the resource.

    --edit=false:
        Edit the API resource before creating

    --field-manager='kubectl-create':
        Name of the manager used to track field ownership.

    -f, --filename=[]:
        Filename, directory, or URL to files to use to create the resource

    -k, --kustomize='':
        Process the kustomization directory. This flag can't be used together with -f or -R.

    -o, --output='':
        Output format. One of: (json, yaml, kyaml, name, go-template, go-template-file, template,
        templatefile, jsonpath, jsonpath-as-json, jsonpath-file).

    --raw='':
        Raw URI to POST to the server.  Uses the transport specified by the kubeconfig file.

    -R, --recursive=false:
        Process the directory used in -f, --filename recursively. Useful when you want to manage
        related manifests organized within the same directory.

    --save-config=false:
        If true, the configuration of current object will be saved in its annotation. Otherwise,
        the annotation will be unchanged. This flag is useful when you want to perform kubectl
        apply on this object in the future.

    -l, --selector='':
        Selector (label query) to filter on, supports '=', '==', '!=', 'in', 'notin'.(e.g. -l
        key1=value1,key2=value2,key3 in (value3)). Matching objects must satisfy all of the
        specified label constraints.

    --show-managed-fields=false:
        If true, keep the managedFields when printing objects in JSON or YAML format.

    --template='':
        Template string or path to template file to use when -o=go-template, -o=go-template-file.
        The template format is golang templates
        [http://golang.org/pkg/text/template/#pkg-overview].

    --validate='strict':
        Must be one of: strict (or true), warn, ignore (or false). "true" or "strict" will use a
        schema to validate the input and fail the request if invalid. It will perform server side
        validation if ServerSideFieldValidation is enabled on the api-server, but will fall back
        to less reliable client-side validation if not. "warn" will warn about unknown or
        duplicate fields without blocking the request if server-side field validation is enabled
        on the API server, and behave as "ignore" otherwise. "false" or "ignore" will not perform
        any schema validation, silently dropping any unknown or duplicate fields.

    --windows-line-endings=false:
        Only relevant if --edit=true. Defaults to the line ending native to your platform.

Usage:
  kubectl create -f FILENAME [options]

Use "kubectl create <command> --help" for more information about a given command.
Use "kubectl options" for a list of global command-line options (applies to all commands).

controlplane ~ ➜  k create deployment elasticsarch -n kube-system -oyaml q6.yaml
error: required flag(s) "image" not set

controlplane ~ ✖ k create deployment elasticsarch --image=registry.k8s.io/fluentd-elasticsearch:1.20 -n kube-system
 -oyaml > q6.yaml

controlplane ~ ➜  vi q6.yaml 

controlplane ~ ➜  k apply -f q6.yaml 
Error from server (BadRequest): error when creating "q6.yaml": DaemonSet in version "v1" cannot be handled as a DaemonSet: strict decoding error: unknown field "spec.progressDeadlineSeconds", unknown field "spec.replicas", unknown field "spec.strategy"

controlplane ~ ✖ vi q6.yaml 

controlplane ~ ➜  k create pod elasticsarch --image=registry.k8s.io/fluentd-elasticsearch:1.20 -n kube-system -oyam
l > q6.yaml
error: unknown flag: --image
See 'kubectl create --help' for usage.

controlplane ~ ✖ k run elasticsarch --image=registry.k8s.io/fluentd-elasticsearch:1.20 -n kube-system -oyaml > q6-1.yaml

controlplane ~ ➜  vi q6-

controlplane ~ ➜  vi q6-1.yaml 

controlplane ~ ➜  k apply -f q6-1.yaml 
error: resource mapping not found for name: "elasticsarch" namespace: "kube-system" from "q6-1.yaml": no matches for kind "DaemonSet" in version "v1"
ensure CRDs are installed first

controlplane ~ ✖ kpg
-bash: kpg: command not found

controlplane ~ ✖ k api-resources | grep -i Daemon
daemonsets                          ds           apps/v1                           true         DaemonSet

controlplane ~ ➜  k api-resources | grep -i Daemon -A7
daemonsets                          ds           apps/v1                           true         DaemonSet
deployments                         deploy       apps/v1                           true         Deployment
replicasets                         rs           apps/v1                           true         ReplicaSet
statefulsets                        sts          apps/v1                           true         StatefulSet
selfsubjectreviews                               authentication.k8s.io/v1          false        SelfSubjectReview
tokenreviews                                     authentication.k8s.io/v1          false        TokenReview
localsubjectaccessreviews                        authorization.k8s.io/v1           true         LocalSubjectAccessReview
selfsubjectaccessreviews                         authorization.k8s.io/v1           false        SelfSubjectAccessReview

controlplane ~ ➜  vi q6-1.yaml 

controlplane ~ ➜  k apply -f q6-1.yaml 
Error from server (BadRequest): error when creating "q6-1.yaml": DaemonSet in version "v1" cannot be handled as a DaemonSet: strict decoding error: unknown field "spec.containers", unknown field "spec.dnsPolicy", unknown field "spec.enableServiceLinks", unknown field "spec.preemptionPolicy", unknown field "spec.priority", unknown field "spec.restartPolicy", unknown field "spec.schedulerName", unknown field "spec.securityContext", unknown field "spec.serviceAccount", unknown field "spec.serviceAccountName", unknown field "spec.terminationGracePeriodSeconds", unknown field "spec.tolerations", unknown field "spec.volumes", unknown field "status.phase", unknown field "status.qosClass"

controlplane ~ ✖ k create deployment elasticsearch --image=registry.k8s.io/fluentd-elasticsearch:1.20 -n kub
e-system -oyaml > fluentd.yaml

controlplane ~ ➜  vi fluentd.yaml 

controlplane ~ ➜  k apply -f fluentd.yaml 
Error from server (BadRequest): error when creating "fluentd.yaml": DaemonSet in version "v1" cannot be handled as a DaemonSet: json: cannot unmarshal object into Go struct field LabelSelector.spec.selector.matchLabels of type string

controlplane ~ ✖ vi fluentd.yaml 

controlplane ~ ➜  kubectl create deployment elasticsearch
--image=registry.k8s.io/fluentd-elasticsearch:1.20
-n kube-system --dry-run=client -o yaml > fluentd2.yaml
error: required flag(s) "image" not set
-bash: --image=registry.k8s.io/fluentd-elasticsearch:1.20: No such file or directory
-bash: -n: command not found

controlplane ~ ✖ kubectl create deployment elasticsearch --image=registry.k8s.io/fluentd-elasticsearch:1.20 -n kube-system --dry-run=client -o yaml > fluentd2.yaml

controlplane ~ ➜  vi fluentd2.yaml 

controlplane ~ ➜  k create -f fluentd2.yaml
daemonset.apps/elasticsearch created

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

# 5 History++
## 5.5 Resource limits
```cmd
         Welcome to the KodeKloud Hands-On lab                                                                                                      
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
               All rights reserved                                                                                                                  

controlplane ~ ➜  k describe po rabbit
Name:             rabbit
Namespace:        default
Priority:         0
Service Account:  default
Node:             controlplane/10.244.154.14
Start Time:       Mon, 25 May 2026 04:36:11 +0000
Labels:           <none>
Annotations:      <none>
Status:           Running
IP:               10.22.0.9
IPs:
  IP:  10.22.0.9
Containers:
  cpu-stress:
    Container ID:  containerd://f1a466cd78e67ebfc458461aed810cec3b5a9c7b6995e8cf97aaea99186b2ccd
    Image:         ubuntu
    Image ID:      docker.io/library/ubuntu@sha256:f3d28607ddd78734bb7f71f117f3c6706c666b8b76cbff7c9ff6e5718d46ff64
    Port:          <none>
    Host Port:     <none>
    Args:
      sleep
      1000
    State:          Running
      Started:      Mon, 25 May 2026 04:36:15 +0000
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:  1
    Requests:
      cpu:        500m
    Environment:  <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-p9xvk (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  kube-api-access-p9xvk:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    Optional:                false
    DownwardAPI:             true
QoS Class:                   Burstable
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  27s   default-scheduler  Successfully assigned default/rabbit to controlplane
  Normal  Pulling    26s   kubelet            spec.containers{cpu-stress}: Pulling image "ubuntu"
  Normal  Pulled     24s   kubelet            spec.containers{cpu-stress}: Successfully pulled image "ubuntu" in 2.486s (2.486s including waiting). Image size: 41567720 bytes.
  Normal  Created    24s   kubelet            spec.containers{cpu-stress}: Container created
  Normal  Started    23s   kubelet            spec.containers{cpu-stress}: Container started

controlplane ~ ➜  k delete po rabbit 
pod "rabbit" deleted from default namespace

controlplane ~ ➜  #1 + 2

controlplane ~ ➜  #3

controlplane ~ ➜  k describe po elephant 
Name:             elephant
Namespace:        default
Priority:         0
Service Account:  default
Node:             controlplane/10.244.154.14
Start Time:       Mon, 25 May 2026 04:38:07 +0000
Labels:           <none>
Annotations:      <none>
Status:           Running
IP:               10.22.0.10
IPs:
  IP:  10.22.0.10
Containers:
  mem-stress:
    Container ID:  containerd://f7a73b0dc1ae02f65b3d0ec0400863e5fece4948c74ff7543e6521c177718fa7
    Image:         polinux/stress
    Image ID:      docker.io/polinux/stress@sha256:b6144f84f9c15dac80deb48d3a646b55c7043ab1d83ea0a697c09097aaad21aa
    Port:          <none>
    Host Port:     <none>
    Command:
      stress
    Args:
      --vm
      1
      --vm-bytes
      15M
      --vm-hang
      1
    State:          Terminated
      Reason:       OOMKilled
      Exit Code:    137
      Started:      Mon, 25 May 2026 04:38:23 +0000
      Finished:     Mon, 25 May 2026 04:38:23 +0000
    Last State:     Terminated
      Reason:       OOMKilled
      Exit Code:    137
      Started:      Mon, 25 May 2026 04:38:10 +0000
      Finished:     Mon, 25 May 2026 04:38:10 +0000
    Ready:          False
    Restart Count:  2
    Limits:
      memory:  10Mi
    Requests:
      memory:     5Mi
    Environment:  <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-sk5df (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       False 
  ContainersReady             False 
  PodScheduled                True 
Volumes:
  kube-api-access-sk5df:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    Optional:                false
    DownwardAPI:             true
QoS Class:                   Burstable
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason     Age               From               Message
  ----     ------     ----              ----               -------
  Normal   Scheduled  23s               default-scheduler  Successfully assigned default/elephant to controlplane
  Normal   Pulled     21s               kubelet            spec.containers{mem-stress}: Successfully pulled image "polinux/stress" in 1.178s (1.178s including waiting). Image size: 4041495 bytes.
  Normal   Pulled     20s               kubelet            spec.containers{mem-stress}: Successfully pulled image "polinux/stress" in 313ms (313ms including waiting). Image size: 4041495 bytes.
  Normal   Pulling    8s (x3 over 22s)  kubelet            spec.containers{mem-stress}: Pulling image "polinux/stress"
  Normal   Created    8s (x3 over 21s)  kubelet            spec.containers{mem-stress}: Container created
  Normal   Pulled     8s                kubelet            spec.containers{mem-stress}: Successfully pulled image "polinux/stress" in 345ms (345ms including waiting). Image size: 4041495 bytes.
  Normal   Started    7s (x3 over 21s)  kubelet            spec.containers{mem-stress}: Container started
  Warning  BackOff    7s (x3 over 19s)  kubelet            spec.containers{mem-stress}: Back-off restarting failed container mem-stress in pod elephant_default(b7e8fd15-2a56-4895-9691-7a9e977239ec)

controlplane ~ ➜  #4

controlplane ~ ➜  ls
sample.yaml

controlplane ~ ➜  k edit pod elephant 
Error detected while processing /root/.vimrc:
line    2:
E117: Unknown function: pathogen#infect
line    4:
E185: Cannot find color scheme 'dracula'
Press ENTER or type command to continue
error: pods "elephant" is invalid
Error detected while processing /root/.vimrc:
line    2:
E117: Unknown function: pathogen#infect
line    4:
E185: Cannot find color scheme 'dracula'
Press ENTER or type command to continue
A copy of your changes has been stored to "/tmp/kubectl-edit-3615486420.yaml"
error: Edit cancelled, no valid changes were saved.

controlplane ~ ✖ k edit pod elephant 
Error detected while processing /root/.vimrc:
line    2:
E117: Unknown function: pathogen#infect
line    4:
E185: Cannot find color scheme 'dracula'
Press ENTER or type command to continue
error: pods "elephant" is invalid
Error detected while processing /root/.vimrc:
line    2:
E117: Unknown function: pathogen#infect
line    4:
E185: Cannot find color scheme 'dracula'
Press ENTER or type command to continue
A copy of your changes has been stored to "/tmp/kubectl-edit-1654243837.yaml"
error: Edit cancelled, no valid changes were saved.

controlplane ~ ✖ k replace --force -f /tmp/kubectl-edit-1654243837.yaml
pod "elephant" deleted from default namespace
pod/elephant replaced

controlplane ~ ➜  #6

controlplane ~ ➜  k get pod -o wide
NAME       READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
elephant   1/1     Running   0          18s   10.22.0.11   controlplane   <none>           <none>

controlplane ~ ➜  k delet po el
error: unknown command "delet" for "kubectl"

Did you mean this?
        delete

controlplane ~ ✖ k delete po elephant 
pod "elephant" deleted from default namespace

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
# 5.4 Node affinity
```cmd
       Welcome to the KodeKloud Hands-On lab                                                                        
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
            All rights reserved                                                                                     

controlplane ~ ➜  k de
debug     (Create debugging sessions for troubleshooting workloads and nodes)
delete    (Delete resources by file names, stdin, resources and names, or by resources and …)
describe  (Show details of a specific resource or group of resources)

controlplane ~ ➜  k describe node node01 | grep -i "labels" -A5
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=node01
                    kubernetes.io/os=linux
Annotations:        flannel.alpha.coreos.com/backend-data: {"VNI":1,"VtepMAC":"5a:f1:9e:5c:e5:ea"}

controlplane ~ ➜  #1 

controlplane ~ ➜  #2

controlplane ~ ➜  #3

controlplane ~ ➜  k label node nod01 color=blue
Error from server (NotFound): nodes "nod01" not found

controlplane ~ ✖ k label node node01 color=blue
node/node01 labeled

controlplane ~ ➜  k label --help
Update the labels on a resource.

  *  A label key and value must begin with a letter or number, and may contain
letters, numbers, hyphens, dots, and underscores, up to 63 characters each.
  *  Optionally, the key can begin with a DNS subdomain prefix and a single '/',
like example.com/my-app.
  *  If --overwrite is true, then existing labels can be overwritten, otherwise
attempting to overwrite a label will result in an error.
  *  If --resource-version is specified, then updates will use this resource
version, otherwise the existing resource-version will be used.

Examples:
  # Update pod 'foo' with the label 'unhealthy' and the value 'true'
  kubectl label pods foo unhealthy=true
  
  # Update pod 'foo' with the label 'status' and the value 'unhealthy',
overwriting any existing value
  kubectl label --overwrite pods foo status=unhealthy
  
  # Update all pods in the namespace
  kubectl label pods --all status=unhealthy
  
  # Update a pod identified by the type and name in "pod.json"
  kubectl label -f pod.json status=unhealthy
  
  # Update pod 'foo' only if the resource is unchanged from version 1
  kubectl label pods foo status=unhealthy --resource-version=1
  
  # Update pod 'foo' by removing a label named 'bar' if it exists
  # Does not require the --overwrite flag
  kubectl label pods foo bar-

Options:
    --all=false:
        Select all resources, in the namespace of the specified resource types

    -A, --all-namespaces=false:
        If true, check the specified action in all namespaces.

    --allow-missing-template-keys=true:
        If true, ignore any errors in templates when a field or map key is
        missing in the template. Only applies to golang and jsonpath output
        formats.

    --dry-run='none':
        Must be "none", "server", or "client". If client strategy, only print
        the object that would be sent, without sending it. If server strategy,
        submit server-side request without persisting the resource.

    --field-manager='kubectl-label':
        Name of the manager used to track field ownership.

    --field-selector='':
        Selector (field query) to filter on, supports '=', '==', and
        '!='.(e.g. --field-selector key1=value1,key2=value2). The server only
        supports a limited number of field queries per type.

    -f, --filename=[]:
        Filename, directory, or URL to files identifying the resource to
        update the labels

    -k, --kustomize='':
        Process the kustomization directory. This flag can't be used together
        with -f or -R.

    --list=false:
        If true, display the labels for a given resource.

    --local=false:
        If true, label will NOT contact api-server but run locally.

    -o, --output='':
        Output format. One of: (json, yaml, kyaml, name, go-template,
        go-template-file, template, templatefile, jsonpath, jsonpath-as-json,
        jsonpath-file).

    --overwrite=false:
        If true, allow labels to be overwritten, otherwise reject label
        updates that overwrite existing labels.

    -R, --recursive=false:
        Process the directory used in -f, --filename recursively. Useful when
        you want to manage related manifests organized within the same
        directory.

    --resource-version='':
        If non-empty, the labels update will only succeed if this is the
        current resource-version for the object. Only valid when specifying a
        single resource.

    -l, --selector='':
        Selector (label query) to filter on, supports '=', '==', '!=', 'in',
        'notin'.(e.g. -l key1=value1,key2=value2,key3 in (value3)). Matching
        objects must satisfy all of the specified label constraints.

    --show-managed-fields=false:
        If true, keep the managedFields when printing objects in JSON or YAML
        format.

    --template='':
        Template string or path to template file to use when -o=go-template,
        -o=go-template-file. The template format is golang templates
        [http://golang.org/pkg/text/template/#pkg-overview].

Usage:
  kubectl label [--overwrite] (-f FILENAME | TYPE NAME) KEY_1=VAL_1 ...
KEY_N=VAL_N [--resource-version=version] [options]

Use "kubectl options" for a list of global command-line options (applies to all
commands).

controlplane ~ ➜  k label --help | grep -i "Node" A9
grep: A9: No such file or directory

controlplane ~ ✖ k label --help | grep -i "Node" -A9

controlplane ~ ✖ #4

controlplane ~ ✖ k create deploy blue --image=nginx --replicas=3
deployment.apps/blue created

controlplane ~ ➜  #5

controlplane ~ ➜  k get nodes
NAME           STATUS   ROLES           AGE   VERSION
controlplane   Ready    control-plane   35m   v1.35.0
node01         Ready    <none>          35m   v1.35.0

controlplane ~ ➜  k describe controlplane | grep -i "Taints" -A9
error: the server doesn't have a resource type "controlplane"

controlplane ~ ✖ k describe node controlplane | grep -i "Taints" -A9
Taints:             <none>
Unschedulable:      false
Lease:
  HolderIdentity:  controlplane
  AcquireTime:     <unset>
  RenewTime:       Mon, 25 May 2026 04:08:11 +0000
Conditions:
  Type                 Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----                 ------  -----------------                 ------------------                ------                       -------
  NetworkUnavailable   False   Mon, 25 May 2026 03:31:57 +0000   Mon, 25 May 2026 03:31:57 +0000   FlannelIsUp                  Flannel is running on this node

controlplane ~ ➜  k describe node node01 | grep -i "Taints" -A9
Taints:             <none>
Unschedulable:      false
Lease:
  HolderIdentity:  node01
  AcquireTime:     <unset>
  RenewTime:       Mon, 25 May 2026 04:08:18 +0000
Conditions:
  Type                 Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----                 ------  -----------------                 ------------------                ------                       -------
  NetworkUnavailable   False   Mon, 25 May 2026 03:32:24 +0000   Mon, 25 May 2026 03:32:24 +0000   FlannelIsUp                  Flannel is running on this node

controlplane ~ ➜  #6

controlplane ~ ➜  k edit node01
error: the server doesn't have a resource type "node01"

controlplane ~ ✖ k edit node node01
Edit cancelled, no changes made.

controlplane ~ ➜  

controlplane ~ ➜  k edit deployments.apps 
deployment.apps/blue edited

controlplane ~ ➜  k label node node01 color=blue
node/node01 not labeled

controlplane ~ ➜  k label node node01 color=blue
node/node01 not labeled

controlplane ~ ➜  

controlplane ~ ➜  k label node node01 color=red
error: 'color' already has a value (blue), and --overwrite is false

controlplane ~ ✖ k get po 
NAME                    READY   STATUS    RESTARTS   AGE
blue-6d68b79d57-gqs46   1/1     Running   0          58s
blue-6d68b79d57-hc28s   1/1     Running   0          62s
blue-6d68b79d57-hdp7n   1/1     Running   0          60s

controlplane ~ ➜  cat deployment blue
cat: deployment: No such file or directory
cat: blue: No such file or directory

controlplane ~ ✖ k edit deploy blue -o yaml > q6.yaml
Vim: Warning: Output is not to a terminal

[1]+  Stopped                 kubectl edit deploy blue -o yaml > q6.yaml

controlplane ~ ✦ ✖ k get pods -o wide
NAME                    READY   STATUS    RESTARTS   AGE    IP           NODE     NOMINATED NODE   READINESS GATES
blue-6d68b79d57-gqs46   1/1     Running   0          3m5s   172.17.1.6   node01   <none>           <none>
blue-6d68b79d57-hc28s   1/1     Running   0          3m9s   172.17.1.4   node01   <none>           <none>
blue-6d68b79d57-hdp7n   1/1     Running   0          3m7s   172.17.1.5   node01   <none>           <none>

controlplane ~ ✦ ➜  #7

controlplane ~ ✦ ➜  #8

controlplane ~ ✦ ➜  k create deployment red --image=nginx --replicas=2 dry-run=client -o yaml > q8.yaml
error: exactly one NAME is required, got 2
See 'kubectl create deployment -h' for help and examples

controlplane ~ ✦ ✖ 

controlplane ~ ✦ ✖ k create deployment red --image=nginx --replicas=2 --dry-run=client -o yaml > q8.yaml

controlplane ~ ✦ ➜  vi q8.yaml 

[2]+  Stopped                 vi q8.yaml

controlplane ~ ✦2 ➜  cat q8.yaml 
metadata:
  labels:
    app: red
  name: red
spec:
  replicas: 2
  selector:
    matchLabels:
      app: red
  strategy: {}
  template:
    metadata:
      labels:
        app: red
    spec:
      affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: disktype
            op
      containers:
      - image: nginx
        name: nginx
        resources: {}
status: {}

controlplane ~ ✦2 ➜  k apply -f q8.yaml 
error: error parsing q8.yaml: error converting YAML to JSON: yaml: line 23: could not find expected ':'

controlplane ~ ✦2 ✖ vi q8.yaml 

controlplane ~ ✦2 ➜  k apply -f q8.yaml 
error: error validating "q8.yaml": error validating data: [apiVersion not set, kind not set]; if you choose to ignore these errors, turn validation off with --validate=false

controlplane ~ ✦2 ✖ rm q8
rm: cannot remove 'q8': No such file or directory

controlplane ~ ✦2 ✖ rm q8.yaml 

controlplane ~ ✦2 ➜  ls
q6.yaml  sample.yaml

controlplane ~ ✦2 ➜  
controlplane ~ ✦ ✖^C

controlplane ~ ✦2 ✖ k create deployment red --image=nginx --replicas=2 --dry-run=client -o yaml > q8.yaml

controlplane ~ ✦2 ➜  vi q8.yaml 

controlplane ~ ✦2 ✖ rm q8.yaml.swap
rm: cannot remove 'q8.yaml.swap': No such file or directory

controlplane ~ ✦2 ✖ ls -A
.bash_profile  .cache   .kube     q6.yaml  .q8.yaml.swp  .ssh            .vim      .vimrc
.bashrc        .config  .profile  q8.yaml  sample.yaml   .terminal_logs  .viminfo  .wget-hsts

controlplane ~ ✦2 ➜  rm .q8.yaml.swp 

controlplane ~ ✦2 ➜  vi q8.yaml 

controlplane ~ ✦2 ➜  cat q8.yaml 
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: red
  name: red
spec:
  replicas: 2
  selector:
    matchLabels:
      app: red
  strategy: {}
  template:
    metadata:
      labels:
        app: red
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: node-role.kubernetes.io/control-plane
                operator: Exists
      containers:
      - image: nginx
        name: nginx
        resources: {}
status: {}

controlplane ~ ✦2 ➜  k apply -f q8.yaml 
deployment.apps/red created

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
```
## 5.1 Manual Scheduling
```
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
```
## 5.2 Selectors
```
      Welcome to the KodeKloud Hands-On lab                                                   
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
          All rights reserved                                                                 

controlplane ~ ➜  #1

controlplane ~ ➜  k get po --env=dev
error: unknown flag: --env
See 'kubectl get --help' for usage.

controlplane ~ ✖ k get ns 
NAME              STATUS   AGE
default           Active   20m
kube-node-lease   Active   20m
kube-public       Active   20m
kube-system       Active   20m

controlplane ~ ➜  k get labels
error: the server doesn't have a resource type "labels"

controlplane ~ ✖ k get po -o wide
NAME          READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
app-1-7qbgp   1/1     Running   0          80s   10.22.0.9    controlplane   <none>           <none>
app-1-tq2qz   1/1     Running   0          80s   10.22.0.11   controlplane   <none>           <none>
app-1-xd8jg   1/1     Running   0          80s   10.22.0.10   controlplane   <none>           <none>
app-1-zzxdf   1/1     Running   0          80s   10.22.0.19   controlplane   <none>           <none>
app-2-tfrhq   1/1     Running   0          80s   10.22.0.12   controlplane   <none>           <none>
auth          1/1     Running   0          80s   10.22.0.14   controlplane   <none>           <none>
db-1-9gtz4    1/1     Running   0          80s   10.22.0.16   controlplane   <none>           <none>
db-1-gwscj    1/1     Running   0          80s   10.22.0.15   controlplane   <none>           <none>
db-1-lzr2c    1/1     Running   0          80s   10.22.0.18   controlplane   <none>           <none>
db-1-tgcsm    1/1     Running   0          80s   10.22.0.17   controlplane   <none>           <none>
db-2-6v6bn    1/1     Running   0          80s   10.22.0.13   controlplane   <none>           <none>

controlplane ~ ➜  k get po --selector env=dev
NAME          READY   STATUS    RESTARTS   AGE
app-1-7qbgp   1/1     Running   0          2m4s
app-1-tq2qz   1/1     Running   0          2m4s
app-1-xd8jg   1/1     Running   0          2m4s
db-1-9gtz4    1/1     Running   0          2m4s
db-1-gwscj    1/1     Running   0          2m4s
db-1-lzr2c    1/1     Running   0          2m4s
db-1-tgcsm    1/1     Running   0          2m4s

controlplane ~ ➜  k get po --selector env=dev --no-headers | wc -l 
7

controlplane ~ ➜  #2

controlplane ~ ➜  k get po --selector bu=finance --no-headers | wc -l 

6

controlplane ~ ➜  

controlplane ~ ➜  #3

controlplane ~ ➜  k get all --selector env=prod --no-headers | wc -l
7

controlplane ~ ➜  k get all --selector env=prod
NAME              READY   STATUS    RESTARTS   AGE
pod/app-1-zzxdf   1/1     Running   0          4m55s
pod/app-2-tfrhq   1/1     Running   0          4m55s
pod/auth          1/1     Running   0          4m55s
pod/db-2-6v6bn    1/1     Running   0          4m55s

NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/app-1   ClusterIP   10.43.152.141   <none>        3306/TCP   4m55s

NAME                    DESIRED   CURRENT   READY   AGE
replicaset.apps/app-2   1         1         1       4m55s
replicaset.apps/db-2    1         1         1       4m55s

controlplane ~ ➜  #4

controlplane ~ ➜  k get po --selector env=prod,bu=finance,tier=frontend
NAME          READY   STATUS    RESTARTS   AGE
app-1-zzxdf   1/1     Running   0          7m14s

controlplane ~ ➜  #5

controlplane ~ ➜  k apply -f replicaset-definition-1.yaml 
The ReplicaSet "replicaset-1" is invalid: spec.template.metadata.labels: Invalid value: {"tier":"nginx"}: `selector` does not match template `labels`

controlplane ~ ✖ vi replicaset-definition-1.yaml 

controlplane ~ ➜  k apply -f replicaset-definition-1.yaml 

replicaset.apps/replicaset-1 created

controlplane ~ ➜  

controlplane ~ ➜  k get rs
NAME           DESIRED   CURRENT   READY   AGE
app-1          3         3         3       8m50s
app-2          1         1         1       8m50s
db-1           4         4         4       8m50s
db-2           1         1         1       8m50s
replicaset-1   2         2         2       13s

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
```

## 5.3 Taints and Tolerations
```cmd
controlplane ~ ➜  #1

controlplane ~ ➜  k get nodes
NAME           STATUS   ROLES           AGE   VERSION
controlplane   Ready    control-plane   49m   v1.35.0
node01         Ready    <none>          49m   v1.35.0

controlplane ~ ➜  k get nodes -A
NAME           STATUS   ROLES           AGE   VERSION
controlplane   Ready    control-plane   50m   v1.35.0
node01         Ready    <none>          49m   v1.35.0

controlplane ~ ➜  #2

controlplane ~ ➜  k describe nodes node01
Name:               node01
Roles:              <none>
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=node01
                    kubernetes.io/os=linux
Annotations:        flannel.alpha.coreos.com/backend-data: {"VNI":1,"VtepMAC":"3a:e1:66:dc:c5:d5"}
                    flannel.alpha.coreos.com/backend-type: vxlan
                    flannel.alpha.coreos.com/kube-subnet-manager: true
                    flannel.alpha.coreos.com/public-ip: 10.244.102.197
                    node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Mon, 25 May 2026 02:56:17 +0000
Taints:             <none>
Unschedulable:      false
Lease:
  HolderIdentity:  node01
  AcquireTime:     <unset>
  RenewTime:       Mon, 25 May 2026 03:45:57 +0000
Conditions:
  Type                 Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----                 ------  -----------------                 ------------------                ------                       -------
  NetworkUnavailable   False   Mon, 25 May 2026 02:56:22 +0000   Mon, 25 May 2026 02:56:22 +0000   FlannelIsUp                  Flannel is running on this node
  MemoryPressure       False   Mon, 25 May 2026 03:45:39 +0000   Mon, 25 May 2026 02:56:17 +0000   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure         False   Mon, 25 May 2026 03:45:39 +0000   Mon, 25 May 2026 02:56:17 +0000   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure          False   Mon, 25 May 2026 03:45:39 +0000   Mon, 25 May 2026 02:56:17 +0000   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready                True    Mon, 25 May 2026 03:45:39 +0000   Mon, 25 May 2026 02:56:20 +0000   KubeletReady                 kubelet is posting ready status
Addresses:
  InternalIP:  10.244.102.197
  Hostname:    node01
Capacity:
  cpu:                16
  ephemeral-storage:  457717264Ki
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             64932556Ki
  pods:               110
Allocatable:
  cpu:                16
  ephemeral-storage:  421832229804
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             64830156Ki
  pods:               110
System Info:
  Machine ID:                 8857e26bcf0549a5b7055ed0c10221b6
  System UUID:                6eb7d6dc-4f59-11ef-82ee-53f656d72c64
  Boot ID:                    43fc6623-cb6d-46c7-ade9-f3265b9277e8
  Kernel Version:             6.8.0-90-generic
  OS Image:                   Ubuntu 22.04.5 LTS
  Operating System:           linux
  Architecture:               amd64
  Container Runtime Version:  containerd://1.7.22
  Kubelet Version:            v1.35.0
  Kube-Proxy Version:         
PodCIDR:                      172.17.1.0/24
PodCIDRs:                     172.17.1.0/24
Non-terminated Pods:          (2 in total)
  Namespace                   Name                     CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
  ---------                   ----                     ------------  ----------  ---------------  -------------  ---
  kube-flannel                kube-flannel-ds-b4g69    100m (0%)     0 (0%)      50Mi (0%)        0 (0%)         49m
  kube-system                 kube-proxy-qq28v         0 (0%)        0 (0%)      0 (0%)           0 (0%)         49m
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests   Limits
  --------           --------   ------
  cpu                100m (0%)  0 (0%)
  memory             50Mi (0%)  0 (0%)
  ephemeral-storage  0 (0%)     0 (0%)
  hugepages-1Gi      0 (0%)     0 (0%)
  hugepages-2Mi      0 (0%)     0 (0%)
Events:
  Type    Reason          Age   From             Message
  ----    ------          ----  ----             -------
  Normal  RegisteredNode  49m   node-controller  Node node01 event: Registered Node node01 in Controller

controlplane ~ ➜  #3

controlplane ~ ➜  k taint nodes node01 spray=mortein:NoSchedule
node/node01 tainted

controlplane ~ ➜  #4

controlplane ~ ➜  k run mosquito --image=nginx
pod/mosquito created

controlplane ~ ➜  #5

controlplane ~ ➜  k get pod mosquito 
NAME       READY   STATUS    RESTARTS   AGE
mosquito   0/1     Pending   0          34s

controlplane ~ ➜  #6

controlplane ~ ➜  k describe po mosquito 
Name:             mosquito
Namespace:        default
Priority:         0
Service Account:  default
Node:             <none>
Labels:           run=mosquito
Annotations:      <none>
Status:           Pending
IP:               
IPs:              <none>
Containers:
  mosquito:
    Image:        nginx
    Port:         <none>
    Host Port:    <none>
    Environment:  <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-bw5c8 (ro)
Conditions:
  Type           Status
  PodScheduled   False 
Volumes:
  kube-api-access-bw5c8:
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
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  60s   default-scheduler  0/2 nodes are available: 2 node(s) had untolerated taint(s). no new claims to deallocate, preemption: 0/2 nodes are available: 2 Preemption is not helpful for scheduling.

controlplane ~ ➜  #7

controlplane ~ ➜  k run be --image=nginx --dry-run=client -oyaml q7.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: be
  name: be
spec:
  containers:
  - args:
    - q7.yaml
    image: nginx
    name: be
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

controlplane ~ ➜  vi q7.yaml

controlplane ~ ➜  k create be --image=nginx --dry-run=client -oyaml q7.yaml
error: unknown flag: --image
See 'kubectl create --help' for usage.

controlplane ~ ✖ k run be --image=nginx --dry-run=client -o yaml > q7.yaml

controlplane ~ ➜  vi q7.yaml 

controlplane ~ ➜  cat q7.yaml 
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: be
  name: be
spec:
 tolerations:
  - key: "spray"
    operator: "Equal"
    value: "mortein"
    effect: "NoSchedule" 
  containers:
  - image: nginx
    name: be
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

controlplane ~ ➜  k apply -f q7.yaml 
error: error parsing q7.yaml: error converting YAML to JSON: yaml: line 12: did not find expected '-' indicator

controlplane ~ ✖ vi q7.yaml 

controlplane ~ ➜  k apply -f q7.yaml 
pod/be created

controlplane ~ ➜  cat q7.yaml 
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: be
  name: be
spec:
  tolerations:
  - key: "spray"
    operator: "Equal"
    value: "mortein"
    effect: "NoSchedule" 
  containers:
  - image: nginx
    name: be
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

controlplane ~ ➜  vi q7.yaml 

controlplane ~ ➜  vi q7.yaml 

controlplane ~ ➜  k apply -f q7.yaml 
pod/bee created

controlplane ~ ➜  #8

controlplane ~ ➜  k get po bee
NAME   READY   STATUS    RESTARTS   AGE
bee    1/1     Running   0          21s

controlplane ~ ➜  k get po bee -o wide
NAME   READY   STATUS    RESTARTS   AGE   IP           NODE     NOMINATED NODE   READINESS GATES
bee    1/1     Running   0          25s   172.17.1.3   node01   <none>           <none>

controlplane ~ ➜  #9

controlplane ~ ➜  k decribe node controlplane
error: unknown command "decribe" for "kubectl"

Did you mean this?
        describe

controlplane ~ ✖ k describe node controlplane
Name:               controlplane
Roles:              control-plane
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/arch=amd64
                    kubernetes.io/hostname=controlplane
                    kubernetes.io/os=linux
                    node-role.kubernetes.io/control-plane=
                    node.kubernetes.io/exclude-from-external-load-balancers=
Annotations:        flannel.alpha.coreos.com/backend-data: {"VNI":1,"VtepMAC":"d2:79:98:3b:ab:16"}
                    flannel.alpha.coreos.com/backend-type: vxlan
                    flannel.alpha.coreos.com/kube-subnet-manager: true
                    flannel.alpha.coreos.com/public-ip: 10.244.220.250
                    node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Mon, 25 May 2026 02:55:41 +0000
Taints:             node-role.kubernetes.io/control-plane:NoSchedule
Unschedulable:      false
Lease:
  HolderIdentity:  controlplane
  AcquireTime:     <unset>
  RenewTime:       Mon, 25 May 2026 03:56:35 +0000
Conditions:
  Type                 Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----                 ------  -----------------                 ------------------                ------                       -------
  NetworkUnavailable   False   Mon, 25 May 2026 02:55:56 +0000   Mon, 25 May 2026 02:55:56 +0000   FlannelIsUp                  Flannel is running on this node
  MemoryPressure       False   Mon, 25 May 2026 03:54:04 +0000   Mon, 25 May 2026 02:55:40 +0000   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure         False   Mon, 25 May 2026 03:54:04 +0000   Mon, 25 May 2026 02:55:40 +0000   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure          False   Mon, 25 May 2026 03:54:04 +0000   Mon, 25 May 2026 02:55:40 +0000   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready                True    Mon, 25 May 2026 03:54:04 +0000   Mon, 25 May 2026 02:55:54 +0000   KubeletReady                 kubelet is posting ready status
Addresses:
  InternalIP:  10.244.220.250
  Hostname:    controlplane
Capacity:
  cpu:                16
  ephemeral-storage:  457717264Ki
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             64932560Ki
  pods:               110
Allocatable:
  cpu:                16
  ephemeral-storage:  421832229804
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             64830160Ki
  pods:               110
System Info:
  Machine ID:                 8857e26bcf0549a5b7055ed0c10221b6
  System UUID:                35a0914c-58c5-11f0-8833-71b12cb4357b
  Boot ID:                    55d9e2a1-c9f5-4c91-8007-89fb7e89c7a5
  Kernel Version:             6.8.0-90-generic
  OS Image:                   Ubuntu 22.04.5 LTS
  Operating System:           linux
  Architecture:               amd64
  Container Runtime Version:  containerd://1.7.22
  Kubelet Version:            v1.35.0
  Kube-Proxy Version:         
PodCIDR:                      172.17.0.0/24
PodCIDRs:                     172.17.0.0/24
Non-terminated Pods:          (8 in total)
  Namespace                   Name                                    CPU Requests  CPU Limits  Memory Requests  Memory Limits  Age
  ---------                   ----                                    ------------  ----------  ---------------  -------------  ---
  kube-flannel                kube-flannel-ds-87jxw                   100m (0%)     0 (0%)      50Mi (0%)        0 (0%)         60m
  kube-system                 coredns-6f6c7df987-dwtbr                100m (0%)     0 (0%)      70Mi (0%)        170Mi (0%)     60m
  kube-system                 coredns-6f6c7df987-hvk8d                100m (0%)     0 (0%)      70Mi (0%)        170Mi (0%)     60m
  kube-system                 etcd-controlplane                       100m (0%)     0 (0%)      100Mi (0%)       0 (0%)         60m
  kube-system                 kube-apiserver-controlplane             250m (1%)     0 (0%)      0 (0%)           0 (0%)         60m
  kube-system                 kube-controller-manager-controlplane    200m (1%)     0 (0%)      0 (0%)           0 (0%)         60m
  kube-system                 kube-proxy-wjhpb                        0 (0%)        0 (0%)      0 (0%)           0 (0%)         60m
  kube-system                 kube-scheduler-controlplane             100m (0%)     0 (0%)      0 (0%)           0 (0%)         60m
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests    Limits
  --------           --------    ------
  cpu                950m (5%)   0 (0%)
  memory             290Mi (0%)  340Mi (0%)
  ephemeral-storage  0 (0%)      0 (0%)
  hugepages-1Gi      0 (0%)      0 (0%)
  hugepages-2Mi      0 (0%)      0 (0%)
Events:
  Type    Reason          Age   From             Message
  ----    ------          ----  ----             -------
  Normal  RegisteredNode  60m   node-controller  Node controlplane event: Registered Node controlplane in Controller

controlplane ~ ➜  k describe node controlplane | grep -i taint -a9
                    node-role.kubernetes.io/control-plane=
                    node.kubernetes.io/exclude-from-external-load-balancers=
Annotations:        flannel.alpha.coreos.com/backend-data: {"VNI":1,"VtepMAC":"d2:79:98:3b:ab:16"}
                    flannel.alpha.coreos.com/backend-type: vxlan
                    flannel.alpha.coreos.com/kube-subnet-manager: true
                    flannel.alpha.coreos.com/public-ip: 10.244.220.250
                    node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Mon, 25 May 2026 02:55:41 +0000
Taints:             node-role.kubernetes.io/control-plane:NoSchedule
Unschedulable:      false
Lease:
  HolderIdentity:  controlplane
  AcquireTime:     <unset>
  RenewTime:       Mon, 25 May 2026 03:57:06 +0000
Conditions:
  Type                 Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----                 ------  -----------------                 ------------------                ------                       -------
  NetworkUnavailable   False   Mon, 25 May 2026 02:55:56 +0000   Mon, 25 May 2026 02:55:56 +0000   FlannelIsUp                  Flannel is running on this node

controlplane ~ ➜  k taint nodes controlplane node-role.kubernetes.io/control-plane-
node/controlplane untainted

controlplane ~ ➜  k describe node controlplane | grep -i taint -a9
                    node-role.kubernetes.io/control-plane=
                    node.kubernetes.io/exclude-from-external-load-balancers=
Annotations:        flannel.alpha.coreos.com/backend-data: {"VNI":1,"VtepMAC":"d2:79:98:3b:ab:16"}
                    flannel.alpha.coreos.com/backend-type: vxlan
                    flannel.alpha.coreos.com/kube-subnet-manager: true
                    flannel.alpha.coreos.com/public-ip: 10.244.220.250
                    node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Mon, 25 May 2026 02:55:41 +0000
Taints:             <none>
Unschedulable:      false
Lease:
  HolderIdentity:  controlplane
  AcquireTime:     <unset>
  RenewTime:       Mon, 25 May 2026 03:58:49 +0000
Conditions:
  Type                 Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----                 ------  -----------------                 ------------------                ------                       -------
  NetworkUnavailable   False   Mon, 25 May 2026 02:55:56 +0000   Mon, 25 May 2026 02:55:56 +0000   FlannelIsUp                  Flannel is running on this node

controlplane ~ ➜  #11

controlplane ~ ➜  k get po mosquito 
NAME       READY   STATUS    RESTARTS   AGE
mosquito   1/1     Running   0          11m

controlplane ~ ➜  #12

controlplane ~ ➜  k get po mosquito -o wide
NAME       READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
mosquito   1/1     Running   0          12m   172.17.0.4   controlplane   <none>           <none>

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
```


# 4 
# 4.4 Microservices
```text
k run nginx --image=nginx --port=80       # create nginx pod
k expose pod nginx --port=80              # create a ClusterIP Service named "nginx"
k run client --image=busybox:1.35 ...     # create a client pod in the same namespace
k exec -it client -- sh
wget -qO- http://nginx                    # ✅ works!
```
```cmd
root@controlplane:~$ k run nginx --image=nginx --port=80
pod/nginx created
root@controlplane:~$ k expose pod nginx --port=80
service/nginx exposed
root@controlplane:~$ k run client --image=busybox:1.35 -- sleep 3600
pod/client created
root@controlplane:~$ k exec -it client -- sh
/ # wget -qO- http://nginx
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, nginx is successfully installed and working.
Further configuration is required for the web server, reverse proxy, 
API gateway, load balancer, content cache, or other features.</p>

<p>For online documentation and support please refer to
<a href="https://nginx.org/">nginx.org</a>.<br/>
To engage with the community please visit
<a href="https://community.nginx.org/">community.nginx.org</a>.<br/>
For enterprise grade support, professional services, additional 
security features and capabilities please refer to
<a href="https://f5.com/nginx">f5.com/nginx</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
/ # exit
root@controlplane:~$ 

root@controlplane:~$ k create ns test
namespace/test created
root@controlplane:~$ k run client -n test --image=busybox:1.35 -- sleep 3600
pod/client created
root@controlplane:~$ k exec -it -n test client -- sh
/ # wget -qO- nginx
wget: bad address 'nginx'
/ # wget -qO- nginx.default
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, nginx is successfully installed and working.
Further configuration is required for the web server, reverse proxy, 
API gateway, load balancer, content cache, or other features.</p>

<p>For online documentation and support please refer to
<a href="https://nginx.org/">nginx.org</a>.<br/>
To engage with the community please visit
<a href="https://community.nginx.org/">community.nginx.org</a>.<br/>
For enterprise grade support, professional services, additional 
security features and capabilities please refer to
<a href="https://f5.com/nginx">f5.com/nginx</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
/ # wget -qO- nginx.default.svc.cluster.local
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, nginx is successfully installed and working.
Further configuration is required for the web server, reverse proxy, 
API gateway, load balancer, content cache, or other features.</p>

<p>For online documentation and support please refer to
<a href="https://nginx.org/">nginx.org</a>.<br/>
To engage with the community please visit
<a href="https://community.nginx.org/">community.nginx.org</a>.<br/>
For enterprise grade support, professional services, additional 
security features and capabilities please refer to
<a href="https://f5.com/nginx">f5.com/nginx</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
/ # exit
```

