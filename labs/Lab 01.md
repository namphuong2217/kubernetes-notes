# Setup Local Kubernetes Cluster - Minikube - Windows
Resource: https://blog.cloudmentor.pro/posts/cka-onboarding-chon-playground-tools-va-setup-minikube-de-bat-dau-lab-kubernetes
```text
Microsoft Windows [Version 10.0.26200.8246]
(c) Microsoft Corporation. All rights reserved.

C:\Users\nnguyen>kubectl cluster-info
Kubernetes control plane is running at https://scp-h7wkwlh6.hcp.germanywestcentral.azmk8s.io:443
CoreDNS is running at https://scp-h7wkwlh6.hcp.germanywestcentral.azmk8s.io:443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
Metrics-server is running at https://scp-h7wkwlh6.hcp.germanywestcentral.azmk8s.io:443/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

C:\Users\nnguyen>kubectl get nodes
NAME                               STATUS   ROLES    AGE     VERSION
aks-appnpgwc-38002954-vmss00000q   Ready    <none>   7d16h   v1.34.6
aks-appnpgwc-38002954-vmss0000al   Ready    <none>   7d16h   v1.34.6
aks-default-16098783-vmss00001p    Ready    <none>   7d16h   v1.34.6

C:\Users\nnguyen>kubectl get pods -A
NAMESPACE       NAME                                                  READY   STATUS      RESTARTS        AGE
cert-manager    cert-manager-7bfcc549f5-lkddg                         1/1     Running     0               7d16h
cert-manager    cert-manager-cainjector-5d8798687c-d5d5n              1/1     Running     0               7d16h
cert-manager    cert-manager-webhook-c77744d75-6bqmf                  1/1     Running     0               7d16h
dp-aeos         aeos-app-bb57fdff-j5wrw                               1/1     Running     0               7d16h
dp-agc          act-green-calculator-84d778598b-2f4dz                 1/1     Running     0               7d16h
dp-ats          ats-rp-auth-gw-6db5c4cd54-r4kjg                       1/1     Running     0               7d16h
dp-ats          ats-ui-57fdfd4cdc-8vkmk                               1/1     Running     0               7d16h
dp-ats          backend-proxy-6dd4f8b665-j2f9c                        1/1     Running     0               7d16h
dp-ats          echo-service-879c4d666-8hmpx                          1/1     Running     0               7d16h
dp-bcomp        bcomp-backend-85d48d84c9-886sx                        1/1     Running     0               7d16h
dp-bcomp        bcomp-frontend-7f6d64696-2kfnj                        1/1     Running     0               7d16h
dp-ddpuid       ddpuid-backend-7dc4bcf75d-gh7rc                       1/1     Running     0               7d16h
dp-ddpuid       ddpuid-ui-c548c6d76-fb6mn                             1/1     Running     0               7d16h
dp-ims          cm-acme-http-solver-4ndt4                             1/1     Running     0               7d16h
dp-ims          cm-acme-http-solver-n6fgr                             1/1     Running     0               7d16h
dp-ims          ims-frontend-dev-696ccd67fc-fcjpl                     1/1     Running     0               3h19m
dp-ims          ims-frontend-dev-696ccd67fc-l58rz                     1/1     Running     0               3h19m
dp-ims          ims-frontend-dev-696ccd67fc-sb7f9                     1/1     Running     0               3h20m
dp-ims          ims-redis-dev-66f8cb5779-t8kcd                        1/1     Running     0               7d16h
dp-rims         rims-backend-dev-667489d-9zm27                        1/1     Running     0               57m
dp-rims         rims-frontend-dev-7754ffd6b9-lrt68                    1/1     Running     0               57m
dp-rims         rims-scraper-dev-554bdf9557-cb6dt                     1/1     Running     0               57m
dp-tmt          tmt-backend-5dbf94dd96-bfhxt                          1/1     Running     0               7d16h
dp-tmt          tmt-ui-5cc4fbdf7f-t6f5r                               1/1     Running     0               7d16h
dp-totp         totp-generator-f79d749-pvl7w                          1/1     Running     0               7d16h
dp-tpf          tpf-backend-dev-578dff85f9-dqlqz                      1/1     Running     0               156m
dp-tpf          tpf-frontend-dev-6c7d7bd6f4-4shlj                     1/1     Running     0               3h57m
dp-ulc          ulc-backend-dev-846957549b-9p269                      1/1     Running     0               7d16h
dp-ulc          ulc-frontend-dev-7d8967fff7-622h4                     1/1     Running     0               7d16h
dp-xref         xref-dev-backend-57b7b7bf6d-hz8jr                     1/1     Running     0               5d1h
dp-xref         xref-dev-frontend-7966764785-jkpcv                    1/1     Running     0               5d1h
dp-xref         xref-dev-se-backend-799cf6fd67-w64pf                  1/1     Running     0               5d1h
flux-system     fluxconfig-agent-58b6d94475-gqgb8                     2/2     Running     0               7d16h
flux-system     fluxconfig-controller-66977c8f9b-l66x2                2/2     Running     0               7d16h
flux-system     helm-controller-68554876b6-h5n9m                      1/1     Running     0               7d16h
flux-system     image-automation-controller-844969b8b6-k8qn2          1/1     Running     0               7d16h
flux-system     kustomize-controller-85bd8f49f5-47jr4                 1/1     Running     0               7d16h
flux-system     notification-controller-fff497dd8-7c4c6               1/1     Running     1 (6d10h ago)   7d16h
flux-system     source-controller-95f7f556b-qmfx7                     1/1     Running     0               7d16h
ingress-nginx   ingress-nginx-controller-5dbf8cb769-22v46             1/1     Running     0               7d16h
ingress-nginx   ingress-nginx-controller-5dbf8cb769-tm6ks             1/1     Running     0               7d16h
kube-system     aks-secrets-store-csi-driver-9rvsz                    3/3     Running     0               7d16h
kube-system     aks-secrets-store-csi-driver-tsmvs                    3/3     Running     0               7d16h
kube-system     aks-secrets-store-csi-driver-x4m76                    3/3     Running     0               7d16h
kube-system     aks-secrets-store-provider-azure-tm22k                1/1     Running     0               7d16h
kube-system     aks-secrets-store-provider-azure-w6q5p                1/1     Running     0               7d16h
kube-system     aks-secrets-store-provider-azure-zvrn7                1/1     Running     0               7d16h
kube-system     ama-logs-bnpjk                                        3/3     Running     0               7d16h
kube-system     ama-logs-dgpw2                                        3/3     Running     0               7d16h
kube-system     ama-logs-gdt5v                                        3/3     Running     0               7d16h
kube-system     ama-logs-rs-6fb4445996-987q2                          2/2     Running     0               7d16h
kube-system     azure-cns-6vnkx                                       1/1     Running     0               4d11h
kube-system     azure-cns-ddszv                                       1/1     Running     0               4d11h
kube-system     azure-cns-zbxl2                                       1/1     Running     0               4d11h
kube-system     azure-ip-masq-agent-52sgg                             1/1     Running     0               3d11h
kube-system     azure-ip-masq-agent-htkqd                             1/1     Running     0               3d10h
kube-system     azure-ip-masq-agent-wxkxh                             1/1     Running     0               3d11h
kube-system     azure-wi-webhook-controller-manager-d8757cfcd-99rcf   1/1     Running     0               7d16h
kube-system     azure-wi-webhook-controller-manager-d8757cfcd-brv9q   1/1     Running     0               7d16h
kube-system     cilium-2fls9                                          3/3     Running     0               7d16h
kube-system     cilium-h8mcx                                          3/3     Running     0               7d16h
kube-system     cilium-operator-5675bbd7b7-g8s79                      1/1     Running     1 (6d10h ago)   7d16h
kube-system     cilium-qb8qn                                          3/3     Running     0               7d16h
kube-system     cloud-node-manager-926qw                              1/1     Running     0               7d16h
kube-system     cloud-node-manager-p6jnh                              1/1     Running     0               7d16h
kube-system     cloud-node-manager-wv8lh                              1/1     Running     0               7d16h
kube-system     coredns-5d6cc8c65f-gk7xm                              1/1     Running     0               7d16h
kube-system     coredns-5d6cc8c65f-rmphq                              1/1     Running     0               7d16h
kube-system     coredns-autoscaler-6f99596bbd-zj4ss                   1/1     Running     0               7d16h
kube-system     cost-analysis-agent-5786b76586-d9xmk                  3/3     Running     0               7d16h
kube-system     csi-azuredisk-node-69ddv                              3/3     Running     0               7d16h
kube-system     csi-azuredisk-node-9snww                              3/3     Running     0               7d16h
kube-system     csi-azuredisk-node-dbh8f                              3/3     Running     0               7d16h
kube-system     csi-azurefile-node-khqb7                              4/4     Running     0               7d16h
kube-system     csi-azurefile-node-mkzvd                              4/4     Running     0               7d16h
kube-system     csi-azurefile-node-r7xjp                              4/4     Running     0               7d16h
kube-system     keda-admission-webhooks-67b7d694bf-gtkjz              1/1     Running     0               7d16h
kube-system     keda-admission-webhooks-67b7d694bf-tx6rx              1/1     Running     0               7d16h
kube-system     keda-operator-747d4d7c67-8xv6m                        1/1     Running     0               7d16h
kube-system     keda-operator-747d4d7c67-wb5wf                        1/1     Running     0               7d16h
kube-system     keda-operator-metrics-apiserver-7b9bfd747b-7s78s      1/1     Running     0               7d16h
kube-system     keda-operator-metrics-apiserver-7b9bfd747b-84sdd      1/1     Running     0               7d16h
kube-system     konnectivity-agent-54f74b7c88-dtchb                   1/1     Running     0               7d16h
kube-system     konnectivity-agent-54f74b7c88-h5g4v                   1/1     Running     0               7d16h
kube-system     konnectivity-agent-autoscaler-776c759bd8-pzdf7        1/1     Running     0               7d16h
kube-system     metrics-server-5d8d48b979-7s8nd                       2/2     Running     0               7d16h
kube-system     metrics-server-5d8d48b979-jhvs8                       2/2     Running     0               7d16h
kube-system     overlay-vpa-cert-webhook-check-cd4cv                  0/1     Completed   0               11s
kube-system     vpa-admission-controller-595979c9d5-trkh2             1/1     Running     0               7d16h
kube-system     vpa-admission-controller-595979c9d5-v5dc2             1/1     Running     0               7d16h
kube-system     vpa-recommender-679bccf4dc-pc6dg                      1/1     Running     0               7d16h
kube-system     vpa-recommender-679bccf4dc-tw7ch                      1/1     Running     3 (2d12h ago)   7d16h
kube-system     vpa-updater-66c45b8b49-js4rk                          1/1     Running     0               7d16h
kube-system     vpa-updater-66c45b8b49-sf4jp                          1/1     Running     1 (2d12h ago)   7d16h
monitoring      prometheus-78d6bcbf87-g7z7p                           1/1     Running     0               7d16h
monitoring      prometheus-adapter-8f69fcf95-5nlmw                    1/1     Running     0               7d16h

C:\Users\nnguyen>kubectl explain pods
KIND:       Pod
VERSION:    v1

DESCRIPTION:
    Pod is a collection of containers that can run on a host. This resource is
    created by clients and scheduled onto hosts.

FIELDS:
  apiVersion    <string>
    APIVersion defines the versioned schema of this representation of an object.
    Servers should convert recognized schemas to the latest internal value, and
    may reject unrecognized values. More info:
    https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources

  kind  <string>
    Kind is a string value representing the REST resource this object
    represents. Servers may infer this from the endpoint the client submits
    requests to. Cannot be updated. In CamelCase. More info:
    https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds

  metadata      <ObjectMeta>
    Standard object's metadata. More info:
    https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata

  spec  <PodSpec>
    Specification of the desired behavior of the pod. More info:
    https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status

  status        <PodStatus>
    Most recently observed status of the pod. This data may not be up to date.
    Populated by the system. Read-only. More info:
    https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status



C:\Users\nnguyen>kubectl api-resources
NAME                                SHORTNAMES                          APIVERSION                               NAMESPACED   KIND
bindings                                                                v1                                       true         Binding
componentstatuses                   cs                                  v1                                       false        ComponentStatus
configmaps                          cm                                  v1                                       true         ConfigMap
endpoints                           ep                                  v1                                       true         Endpoints
events                              ev                                  v1                                       true         Event
limitranges                         limits                              v1                                       true         LimitRange
namespaces                          ns                                  v1                                       false        Namespace
nodes                               no                                  v1                                       false        Node
persistentvolumeclaims              pvc                                 v1                                       true         PersistentVolumeClaim
persistentvolumes                   pv                                  v1                                       false        PersistentVolume
pods                                po                                  v1                                       true         Pod
podtemplates                                                            v1                                       true         PodTemplate
replicationcontrollers              rc                                  v1                                       true         ReplicationController
resourcequotas                      quota                               v1                                       true         ResourceQuota
secrets                                                                 v1                                       true         Secret
serviceaccounts                     sa                                  v1                                       true         ServiceAccount
services                            svc                                 v1                                       true         Service
challenges                                                              acme.cert-manager.io/v1                  true         Challenge
orders                                                                  acme.cert-manager.io/v1                  true         Order
nodenetworkconfigs                  nnc                                 acn.azure.com/v1alpha                    true         NodeNetworkConfig
overlayextensionconfigs             oec                                 acn.azure.com/v1alpha1                   true         OverlayExtensionConfig
mutatingwebhookconfigurations                                           admissionregistration.k8s.io/v1          false        MutatingWebhookConfiguration
validatingadmissionpolicies                                             admissionregistration.k8s.io/v1          false        ValidatingAdmissionPolicy
validatingadmissionpolicybindings                                       admissionregistration.k8s.io/v1          false        ValidatingAdmissionPolicyBinding
validatingwebhookconfigurations                                         admissionregistration.k8s.io/v1          false        ValidatingWebhookConfiguration
configsyncstatuses                  akscss                              aks.clusterconfig.azure.com/v1beta1      true         ConfigSyncStatus
extensionconfigs                    aksec                               aks.clusterconfig.azure.com/v1beta1      true         ExtensionConfig
customresourcedefinitions           crd,crds                            apiextensions.k8s.io/v1                  false        CustomResourceDefinition
apiservices                                                             apiregistration.k8s.io/v1                false        APIService
controllerrevisions                                                     apps/v1                                  true         ControllerRevision
daemonsets                          ds                                  apps/v1                                  true         DaemonSet
deployments                         deploy                              apps/v1                                  true         Deployment
replicasets                         rs                                  apps/v1                                  true         ReplicaSet
statefulsets                        sts                                 apps/v1                                  true         StatefulSet
selfsubjectreviews                                                      authentication.k8s.io/v1                 false        SelfSubjectReview
tokenreviews                                                            authentication.k8s.io/v1                 false        TokenReview
localsubjectaccessreviews                                               authorization.k8s.io/v1                  true         LocalSubjectAccessReview
selfsubjectaccessreviews                                                authorization.k8s.io/v1                  false        SelfSubjectAccessReview
selfsubjectrulesreviews                                                 authorization.k8s.io/v1                  false        SelfSubjectRulesReview
subjectaccessreviews                                                    authorization.k8s.io/v1                  false        SubjectAccessReview
horizontalpodautoscalers            hpa                                 autoscaling/v2                           true         HorizontalPodAutoscaler
verticalpodautoscalercheckpoints    vpacheckpoint                       autoscaling.k8s.io/v1                    true         VerticalPodAutoscalerCheckpoint
verticalpodautoscalers              vpa                                 autoscaling.k8s.io/v1                    true         VerticalPodAutoscaler
cronjobs                            cj                                  batch/v1                                 true         CronJob
jobs                                                                    batch/v1                                 true         Job
certificaterequests                 cr,crs                              cert-manager.io/v1                       true         CertificateRequest
certificates                        cert,certs                          cert-manager.io/v1                       true         Certificate
clusterissuers                                                          cert-manager.io/v1                       false        ClusterIssuer
issuers                                                                 cert-manager.io/v1                       true         Issuer
certificatesigningrequests          csr                                 certificates.k8s.io/v1                   false        CertificateSigningRequest
ciliumcidrgroups                    ccg                                 cilium.io/v2                             false        CiliumCIDRGroup
ciliumclusterwidenetworkpolicies    ccnp                                cilium.io/v2                             false        CiliumClusterwideNetworkPolicy
ciliumendpoints                     cep,ciliumep                        cilium.io/v2                             true         CiliumEndpoint
ciliumendpointslices                ces                                 cilium.io/v2alpha1                       false        CiliumEndpointSlice
ciliumexternalworkloads             cew                                 cilium.io/v2                             false        CiliumExternalWorkload
ciliumidentities                    ciliumid                            cilium.io/v2                             false        CiliumIdentity
ciliuml2announcementpolicies        l2announcement                      cilium.io/v2alpha1                       false        CiliumL2AnnouncementPolicy
ciliumloadbalancerippools           ippools,ippool,lbippool,lbippools   cilium.io/v2                             false        CiliumLoadBalancerIPPool
ciliumlocalredirectpolicies         clrp                                cilium.io/v2                             true         CiliumLocalRedirectPolicy
ciliumnetworkpolicies               cnp,ciliumnp                        cilium.io/v2                             true         CiliumNetworkPolicy
ciliumnodeconfigs                                                       cilium.io/v2                             true         CiliumNodeConfig
ciliumnodes                         cn,ciliumn                          cilium.io/v2                             false        CiliumNode
ciliumpodippools                    cpip                                cilium.io/v2alpha1                       false        CiliumPodIPPool
fluxconfigs                         fc                                  clusterconfig.azure.com/v1alpha1         true         FluxConfig
fluxconfigsyncstatuses                                                  clusterconfig.azure.com/v1beta1          true         FluxConfigSyncStatus
leases                                                                  coordination.k8s.io/v1                   true         Lease
endpointslices                                                          discovery.k8s.io/v1                      true         EndpointSlice
cloudeventsources                                                       eventing.keda.sh/v1alpha1                true         CloudEventSource
clustercloudeventsources                                                eventing.keda.sh/v1alpha1                false        ClusterCloudEventSource
events                              ev                                  events.k8s.io/v1                         true         Event
flowschemas                                                             flowcontrol.apiserver.k8s.io/v1          false        FlowSchema
prioritylevelconfigurations                                             flowcontrol.apiserver.k8s.io/v1          false        PriorityLevelConfiguration
helmreleases                        hr                                  helm.toolkit.fluxcd.io/v2                true         HelmRelease
imagepolicies                                                           image.toolkit.fluxcd.io/v1beta2          true         ImagePolicy
imagerepositories                                                       image.toolkit.fluxcd.io/v1beta2          true         ImageRepository
imageupdateautomations                                                  image.toolkit.fluxcd.io/v1beta2          true         ImageUpdateAutomation
clustertriggerauthentications       cta,clustertriggerauth              keda.sh/v1alpha1                         false        ClusterTriggerAuthentication
scaledjobs                          sj                                  keda.sh/v1alpha1                         true         ScaledJob
scaledobjects                       so                                  keda.sh/v1alpha1                         true         ScaledObject
triggerauthentications              ta,triggerauth                      keda.sh/v1alpha1                         true         TriggerAuthentication
kustomizations                      ks                                  kustomize.toolkit.fluxcd.io/v1           true         Kustomization
nodes                                                                   metrics.k8s.io/v1beta1                   false        NodeMetrics
pods                                                                    metrics.k8s.io/v1beta1                   true         PodMetrics
ingressclasses                                                          networking.k8s.io/v1                     false        IngressClass
ingresses                           ing                                 networking.k8s.io/v1                     true         Ingress
ipaddresses                         ip                                  networking.k8s.io/v1                     false        IPAddress
networkpolicies                     netpol                              networking.k8s.io/v1                     true         NetworkPolicy
servicecidrs                                                            networking.k8s.io/v1                     false        ServiceCIDR
runtimeclasses                                                          node.k8s.io/v1                           false        RuntimeClass
alerts                                                                  notification.toolkit.fluxcd.io/v1beta3   true         Alert
providers                                                               notification.toolkit.fluxcd.io/v1beta3   true         Provider
receivers                                                               notification.toolkit.fluxcd.io/v1        true         Receiver
poddisruptionbudgets                pdb                                 policy/v1                                true         PodDisruptionBudget
clusterrolebindings                                                     rbac.authorization.k8s.io/v1             false        ClusterRoleBinding
clusterroles                                                            rbac.authorization.k8s.io/v1             false        ClusterRole
rolebindings                                                            rbac.authorization.k8s.io/v1             true         RoleBinding
roles                                                                   rbac.authorization.k8s.io/v1             true         Role
deviceclasses                                                           resource.k8s.io/v1                       false        DeviceClass
resourceclaims                                                          resource.k8s.io/v1                       true         ResourceClaim
resourceclaimtemplates                                                  resource.k8s.io/v1                       true         ResourceClaimTemplate
resourceslices                                                          resource.k8s.io/v1                       false        ResourceSlice
priorityclasses                     pc                                  scheduling.k8s.io/v1                     false        PriorityClass
secretproviderclasses                                                   secrets-store.csi.x-k8s.io/v1            true         SecretProviderClass
secretproviderclasspodstatuses                                          secrets-store.csi.x-k8s.io/v1            true         SecretProviderClassPodStatus
volumesnapshotclasses               vsclass,vsclasses                   snapshot.storage.k8s.io/v1               false        VolumeSnapshotClass
volumesnapshotcontents              vsc,vscs                            snapshot.storage.k8s.io/v1               false        VolumeSnapshotContent
volumesnapshots                     vs                                  snapshot.storage.k8s.io/v1               true         VolumeSnapshot
buckets                                                                 source.toolkit.fluxcd.io/v1              true         Bucket
gitrepositories                     gitrepo                             source.toolkit.fluxcd.io/v1              true         GitRepository
helmcharts                          hc                                  source.toolkit.fluxcd.io/v1              true         HelmChart
helmrepositories                    helmrepo                            source.toolkit.fluxcd.io/v1              true         HelmRepository
ocirepositories                     ocirepo                             source.toolkit.fluxcd.io/v1              true         OCIRepository
csidrivers                                                              storage.k8s.io/v1                        false        CSIDriver
csinodes                                                                storage.k8s.io/v1                        false        CSINode
csistoragecapacities                                                    storage.k8s.io/v1                        true         CSIStorageCapacity
storageclasses                      sc                                  storage.k8s.io/v1                        false        StorageClass
volumeattachments                                                       storage.k8s.io/v1                        false        VolumeAttachment
volumeattributesclasses             vac                                 storage.k8s.io/v1                        false        VolumeAttributesClass

C:\Users\nnguyen>minikube dashboard
* Profile "minikube" not found. Run "minikube profile list" to view all profiles.
  To start a cluster, run: "minikube start"

C:\Users\nnguyen>minikube start
* minikube v1.38.1 on Microsoft Windows 11 Enterprise 25H2
* Automatically selected the docker driver
! Starting v1.39.0, minikube will default to "containerd" container runtime. See #21973 for more info.
* Using Docker Desktop driver with root privileges
* Starting "minikube" primary control-plane node in "minikube" cluster
* Pulling base image v0.0.50 ...
* Downloading Kubernetes v1.35.1 preload ...
    > preloaded-images-k8s-v18-v1...:  272.45 MiB / 272.45 MiB  100.00% 3.02 Mi
    > gcr.io/k8s-minikube/kicbase...:  519.58 MiB / 519.58 MiB  100.00% 3.66 Mi
* Creating docker container (CPUs=2, Memory=8100MB) ...
* Preparing Kubernetes v1.35.1 on Docker 29.2.1 ...
* Configuring bridge CNI (Container Networking Interface) ...
* Verifying Kubernetes components...
  - Using image gcr.io/k8s-minikube/storage-provisioner:v5
* Enabled addons: storage-provisioner, default-storageclass
* Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default

C:\Users\nnguyen>minikube dashboard
* Enabling dashboard ...
  - Using image docker.io/kubernetesui/dashboard:v2.7.0
  - Using image docker.io/kubernetesui/metrics-scraper:v1.0.8
* Some dashboard features require the metrics-server addon. To enable all features please run:

        minikube addons enable metrics-server

* Verifying dashboard health ...
* Launching proxy ...
* Verifying proxy health ...
* Opening http://127.0.0.1:52875/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/ in your default browser...
^C
C:\Users\nnguyen>

C:\Users\nnguyen>minikube start --nodes 1 --driver=docker --cni=calico --memory=4096 --cpus=2
* minikube v1.38.1 on Microsoft Windows 11 Enterprise 25H2
* Using the docker driver based on existing profile
! You cannot change the number of nodes for an existing minikube cluster. Please use 'minikube node add' to add nodes to an existing cluster.
! You cannot change the memory size for an existing minikube cluster. Please first delete the cluster.
* Starting "minikube" primary control-plane node in "minikube" cluster
* Pulling base image v0.0.50 ...
* Updating the running docker "minikube" container ...
* Preparing Kubernetes v1.35.1 on Docker 29.2.1 ...
* Verifying Kubernetes components...
  - Using image gcr.io/k8s-minikube/storage-provisioner:v5
  - Using image docker.io/kubernetesui/dashboard:v2.7.0
  - Using image docker.io/kubernetesui/metrics-scraper:v1.0.8
* Some dashboard features require the metrics-server addon. To enable all features please run:

        minikube addons enable metrics-server

* Enabled addons: storage-provisioner, default-storageclass, dashboard
* Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default

C:\Users\nnguyen>minikube dashboard
* Verifying dashboard health ...
* Launching proxy ...
* Verifying proxy health ...
* Opening http://127.0.0.1:57645/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/ in your default browser...
^C
C:\Users\nnguyen>kubectl get nodes
NAME       STATUS   ROLES           AGE     VERSION
minikube   Ready    control-plane   5m38s   v1.35.1

C:\Users\nnguyen>kubectl run nginx --image=nginx
pod/nginx created

C:\Users\nnguyen>kubectl get pods
NAME    READY   STATUS              RESTARTS   AGE
nginx   0/1     ContainerCreating   0          5s

C:\Users\nnguyen>minikube dashboard
* Verifying dashboard health ...
* Launching proxy ...
* Verifying proxy health ...
* Opening http://127.0.0.1:65364/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/ in your default browser...

```

![](/homework/assets/Screenshot 2026-05-12 132935.png)