# Section 18 - Helm Basics (Lab)
https://helm.sh/docs/intro/quickstart/

# Practice Test - Installing Helm (7)
```cmd
         Welcome to the KodeKloud Hands-On lab                                                                                                      
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
               All rights reserved                                                                                                                  

controlplane ~ ➜  #1

controlplane ~ ➜  helm -v
-bash: helm: command not found

controlplane ~ ✖ #2

controlplane ~ ✖ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 get_helm.sh
./get_helm.sh
Downloading https://get.helm.sh/helm-v4.2.3-linux-amd64.tar.gz
Verifying checksum... Done.
Preparing to install helm into /usr/local/bin
helm installed into /usr/local/bin/helm

controlplane ~ ➜  helm -v
Error: flag needs an argument: 'v' in -v

controlplane ~ ✖ helm --version
Error: unknown flag: --version

controlplane ~ ✖ helm list
NAME    NAMESPACE       REVISION        UPDATED STATUS  CHART   APP VERSION

controlplane ~ ➜   helm search hub podinfo
URL                                                     CHART VERSION   APP VERSION     DESCRIPTION                               
https://artifacthub.io/packages/helm/podinfo/po...      6.14.0          6.14.0          Podinfo Helm chart for Kubernetes         
https://artifacthub.io/packages/helm/flagger/po...      6.1.4           6.1.3           Flagger canary deployment demo application

controlplane ~ ➜  #3

controlplane ~ ➜  helm version
version.BuildInfo{Version:"v4.2.3", GitCommit:"43e8b7feece8beb0fcba47059ec9b522fd929a64", GitTreeState:"clean", GoVersion:"go1.26.5", KubeClientVersion:"v1.36"}

controlplane ~ ➜  #4

controlplane ~ ➜  helm --help | grep -i "debug" -C5
| Name                               | Description                                                                                                |
|------------------------------------|------------------------------------------------------------------------------------------------------------|
| $HELM_CACHE_HOME                   | set an alternative location for storing cached files.                                                      |
| $HELM_CONFIG_HOME                  | set an alternative location for storing Helm configuration.                                                |
| $HELM_DATA_HOME                    | set an alternative location for storing Helm data.                                                         |
| $HELM_DEBUG                        | indicate whether or not Helm is running in Debug mode                                                      |
| $HELM_DRIVER                       | set the backend storage driver. Values are: configmap, secret, memory, sql.                                |
| $HELM_DRIVER_SQL_CONNECTION_STRING | set the connection string the SQL storage driver should use.                                               |
| $HELM_MAX_HISTORY                  | set the maximum number of helm release history.                                                            |
| $HELM_NAMESPACE                    | set the namespace used for the helm operations.                                                            |
| $HELM_NO_PLUGINS                   | disable plugins. Set HELM_NO_PLUGINS=1 to disable plugins.                                                 |
--
Flags:
      --burst-limit int                 client-side default throttling limit (default 100)
      --color string                    use colored output (never, auto, always) (default "auto")
      --colour string                   use colored output (never, auto, always) (default "auto")
      --content-cache string            path to the directory containing cached content (e.g. charts) (default "/root/.cache/helm/content")
      --debug                           enable verbose output
  -h, --help                            help for helm
      --kube-apiserver string           the address and the port for the Kubernetes API server
      --kube-as-group stringArray       group to impersonate for the operation, this flag can be repeated to specify multiple groups.
      --kube-as-user string             username to impersonate for the operation
      --kube-ca-file string             the certificate authority file for the Kubernetes API server connection

controlplane ~ ➜  #5

controlplane ~ ➜  helm --help | grep -i "flags" -A20
Flags:
      --burst-limit int                 client-side default throttling limit (default 100)
      --color string                    use colored output (never, auto, always) (default "auto")
      --colour string                   use colored output (never, auto, always) (default "auto")
      --content-cache string            path to the directory containing cached content (e.g. charts) (default "/root/.cache/helm/content")
      --debug                           enable verbose output
  -h, --help                            help for helm
      --kube-apiserver string           the address and the port for the Kubernetes API server
      --kube-as-group stringArray       group to impersonate for the operation, this flag can be repeated to specify multiple groups.
      --kube-as-user string             username to impersonate for the operation
      --kube-ca-file string             the certificate authority file for the Kubernetes API server connection
      --kube-context string             name of the kubeconfig context to use
      --kube-insecure-skip-tls-verify   if true, the Kubernetes API server's certificate will not be checked for validity. This will make your HTTPS connections insecure
      --kube-tls-server-name string     server name to use for Kubernetes API server certificate validation. If it is not provided, the hostname used to contact the server is used
      --kube-token string               bearer token used for authentication
      --kubeconfig string               path to the kubeconfig file
  -n, --namespace string                namespace scope for this request
      --qps float32                     queries per second used when communicating with the Kubernetes API, not including bursting
      --registry-config string          path to the registry config file (default "/root/.config/helm/registry/config.json")
      --repository-cache string         path to the directory containing cached repository indexes (default "/root/.cache/helm/repository")
      --repository-config string        path to the file containing repository names and URLs (default "/root/.config/helm/repositories.yaml")

controlplane ~ ➜  helm --help | grep -i "flags" -A50
Flags:
      --burst-limit int                 client-side default throttling limit (default 100)
      --color string                    use colored output (never, auto, always) (default "auto")
      --colour string                   use colored output (never, auto, always) (default "auto")
      --content-cache string            path to the directory containing cached content (e.g. charts) (default "/root/.cache/helm/content")
      --debug                           enable verbose output
  -h, --help                            help for helm
      --kube-apiserver string           the address and the port for the Kubernetes API server
      --kube-as-group stringArray       group to impersonate for the operation, this flag can be repeated to specify multiple groups.
      --kube-as-user string             username to impersonate for the operation
      --kube-ca-file string             the certificate authority file for the Kubernetes API server connection
      --kube-context string             name of the kubeconfig context to use
      --kube-insecure-skip-tls-verify   if true, the Kubernetes API server's certificate will not be checked for validity. This will make your HTTPS connections insecure
      --kube-tls-server-name string     server name to use for Kubernetes API server certificate validation. If it is not provided, the hostname used to contact the server is used
      --kube-token string               bearer token used for authentication
      --kubeconfig string               path to the kubeconfig file
  -n, --namespace string                namespace scope for this request
      --qps float32                     queries per second used when communicating with the Kubernetes API, not including bursting
      --registry-config string          path to the registry config file (default "/root/.config/helm/registry/config.json")
      --repository-cache string         path to the directory containing cached repository indexes (default "/root/.cache/helm/repository")
      --repository-config string        path to the file containing repository names and URLs (default "/root/.config/helm/repositories.yaml")

Use "helm [command] --help" for more information about a command.

controlplane ~ ➜  #6

controlplane ~ ➜  helm get --help

This command consists of multiple subcommands which can be used to
get extended information about the release, including:

- The values used to generate the release
- The generated manifest file
- The notes provided by the chart of the release
- The hooks associated with the release
- The metadata of the release

Usage:
  helm get [command]

Available Commands:
  all         download all information for a named release
  hooks       download all hooks for a named release
  manifest    download the manifest for a named release
  metadata    This command fetches metadata for a given release
  notes       download the notes for a named release
  values      download the values file for a named release

Flags:
  -h, --help   help for get

Global Flags:
      --burst-limit int                 client-side default throttling limit (default 100)
      --color string                    use colored output (never, auto, always) (default "auto")
      --colour string                   use colored output (never, auto, always) (default "auto")
      --content-cache string            path to the directory containing cached content (e.g. charts) (default "/root/.cache/helm/content")
      --debug                           enable verbose output
      --kube-apiserver string           the address and the port for the Kubernetes API server
      --kube-as-group stringArray       group to impersonate for the operation, this flag can be repeated to specify multiple groups.
      --kube-as-user string             username to impersonate for the operation
      --kube-ca-file string             the certificate authority file for the Kubernetes API server connection
      --kube-context string             name of the kubeconfig context to use
      --kube-insecure-skip-tls-verify   if true, the Kubernetes API server's certificate will not be checked for validity. This will make your HTTPS connections insecure
      --kube-tls-server-name string     server name to use for Kubernetes API server certificate validation. If it is not provided, the hostname used to contact the server is used
      --kube-token string               bearer token used for authentication
      --kubeconfig string               path to the kubeconfig file
  -n, --namespace string                namespace scope for this request
      --qps float32                     queries per second used when communicating with the Kubernetes API, not including bursting
      --registry-config string          path to the registry config file (default "/root/.config/helm/registry/config.json")
      --repository-cache string         path to the directory containing cached repository indexes (default "/root/.cache/helm/repository")
      --repository-config string        path to the file containing repository names and URLs (default "/root/.config/helm/repositories.yaml")

Use "helm get [command] --help" for more information about a command.

controlplane ~ ➜  #7

controlplane ~ ➜  history
    1  #1
    2  helm -v
    3  #2
    4  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
    5  chmod 700 get_helm.sh
    6  ./get_helm.sh
    7  helm -v
    8  helm --version
    9  helm list
   10  #3
   11  helm version
   12  #4
   13  helm --help | grep -i "debug" -C5
   14  #5
   15  helm --help | grep -i "flags" -A20
   16  helm --help | grep -i "flags" -A50
   17  #6
   18  helm get --help
   19  #7
   20  history
```
# Practice Test - Using Helm to Deploy a chart (12)
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

controlplane ~ ➜  helm ls
NAME    NAMESPACE       REVISION        UPDATED STATUS  CHART   APP VERSION

controlplane ~ ➜  #3

controlplane ~ ➜  helm sarch hub consul
Error: unknown command "sarch" for "helm"

Did you mean this?
        search

Run 'helm --help' for usage.

controlplane ~ ✖ #4

controlplane ~ ✖ helm search hub consul
URL                                                     CHART VERSION   APP VERSION     DESCRIPTION                                       
https://artifacthub.io/packages/helm/wener/consul       2.0.1           2.0.1           Official HashiCorp Consul Chart                   
https://artifacthub.io/packages/helm/hashicorp/...      2.0.1           2.0.1           Official HashiCorp Consul Chart                   
https://artifacthub.io/packages/helm/bitnami/co...      11.4.32         1.21.4          HashiCorp Consul is a tool for discovering and ...
https://artifacthub.io/packages/helm/smo-helm-c...      6.0.0                           ONAP Consul Agent                                 
https://artifacthub.io/packages/helm/wenerme/co...      2.0.1           2.0.1           Official HashiCorp Consul Chart                   
https://artifacthub.io/packages/helm/warjiang/c...      1.3.0           1.17.0          Official HashiCorp Consul Chart                   
https://artifacthub.io/packages/helm/bitnami-ak...      10.9.2          1.13.2          HashiCorp Consul is a tool for discovering and ...
https://artifacthub.io/packages/helm/kubegemsap...      9.2.14          1.10.0          Highly available and distributed service discov...
https://artifacthub.io/packages/helm/riftbit/co...      9.3.6           1.10.2          Highly available and distributed service discov...
https://artifacthub.io/packages/helm/intel/consul       0.8.1           1.14.2          A Helm chart for Kubernetes                       
https://artifacthub.io/packages/helm/cloudnativ...      4.2.5           1.5.0           Highly available and distributed service discov...
https://artifacthub.io/packages/helm/zahori/zah...      1.0.1           1.1.2           Consul of Zahori                                  
https://artifacthub.io/packages/helm/prometheus...      1.1.1           v0.13.0         A Helm chart for the Prometheus Consul Exporter   
https://artifacthub.io/packages/helm/cloudnativ...      0.1.3           0.4.0           A Helm chart for the Prometheus Consul Exporter   
https://artifacthub.io/packages/helm/prometheus...      0.4.0           0.4.0           A Helm chart for the Prometheus Consul Exporter   
https://artifacthub.io/packages/helm/nativechat...      0.5.1           0.5.0           A Helm chart for the consul-merge-controller      
https://artifacthub.io/packages/helm/kubegemsap...      0.5.0           0.4.0           A Helm chart for the Prometheus Consul Exporter   
https://artifacthub.io/packages/helm/mintel/hyb...      0.0.3                           A Helm chart for defining Consul CRDs             
https://artifacthub.io/packages/helm/intel/evi-...      3.0.3           1.14.2          A Helm chart for Kubernetes                       
https://artifacthub.io/packages/helm/wenerme/me...      1.0.55          v1.0.55         Meshery chart for deploying Meshery and Meshery...
https://artifacthub.io/packages/helm/wener/meshery      1.0.55          v1.0.55         Meshery chart for deploying Meshery and Meshery...
https://artifacthub.io/packages/helm/kubesphere...      0.5.0                           Meshery chart for deploying Meshery and Meshery...
https://artifacthub.io/packages/helm/kubesphere...      0.5.0                           Meshery chart for deploying Meshery and Meshery...
https://artifacthub.io/packages/helm/meshery/me...      1.0.55          v1.0.55         Meshery chart for deploying Meshery and Meshery...
https://artifacthub.io/packages/helm/consul-hel...      1.1.0           1.1.0           A Helm chart for Deploying the Percona PostgreS...

controlplane ~ ➜  #5

controlplane ~ ➜  helm repo add https://charts.bitnami.com/bitnami
Error: "helm repo add" requires 2 arguments

Usage:  helm repo add [NAME] [URL] [flags]

controlplane ~ ✖ helm repo add bitnami https://charts.bitnami.com/bitnami
"bitnami" has been added to your repositories

controlplane ~ ➜  hlm repo list
-bash: hlm: command not found

controlplane ~ ✖ helm repo list
NAME    URL                               
bitnami https://charts.bitnami.com/bitnami

controlplane ~ ➜  #6

controlplane ~ ➜  helm search repo wordpress
NAME                    CHART VERSION   APP VERSION     DESCRIPTION                                       
bitnami/wordpress       32.1.12         7.0.1           WordPress is the world's most popular blogging ...
bitnami/wordpress-intel 2.1.31          6.1.1           DEPRECATED WordPress for Intel is the most popu...

controlplane ~ ➜  #7

controlplane ~ ➜  helm repo list
NAME            URL                                                 
bitnami         https://charts.bitnami.com/bitnami                  
puppet          https://puppetlabs.github.io/puppetserver-helm-chart
hashicorp       https://helm.releases.hashicorp.com                 

controlplane ~ ➜  #8

controlplane ~ ➜  helm install amaze-surf bitnami/apache
Pulled: us-central1-docker.pkg.dev/kk-lab-prod/helm-charts/bitnami/apache:11.3.2
Digest: sha256:1bd45c97bb7a0000534e3abc5797143661e34ea7165aa33068853c567e6df9f2
NAME: amaze-surf
LAST DEPLOYED: Mon Jul 13 13:01:27 2026
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: apache
CHART VERSION: 11.3.2
APP VERSION: 2.4.63

Did you know there are enterprise versions of the Bitnami catalog? For enhanced secure software supply chain features, unlimited pulls from Docker, LTS support, or application customization, see Bitnami Premium or Tanzu Application Catalog. See https://www.arrow.com/globalecs/na/vendors/bitnami for more information.

** Please be patient while the chart is being deployed **

1. Get the Apache URL by running:

** Please ensure an external IP is associated to the amaze-surf-apache service before proceeding **
** Watch the status using: kubectl get svc --namespace default -w amaze-surf-apache **

  export SERVICE_IP=$(kubectl get svc --namespace default amaze-surf-apache --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
  echo URL            : http://$SERVICE_IP/


WARNING: You did not provide a custom web application. Apache will be deployed with a default page. Check the README section "Deploying your custom web application" in https://github.com/bitnami/charts/blob/main/bitnami/apache/README.md#deploying-a-custom-web-application.



WARNING: There are "resources" sections in the chart not set. Using "resourcesPreset" is not recommended for production. For production installations, please set the following values according to your workload needs:
  - resources
+info https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

controlplane ~ ➜  #9#9

controlplane ~ ➜  helm chart ls
Error: unknown command "chart" for "helm"
Run 'helm --help' for usage.

controlplane ~ ✖ helm show all
Error: "helm show all" requires 1 argument

Usage:  helm show all [CHART] [flags]

controlplane ~ ✖ helm show all amaze-surf
Error: non-absolute URLs should be in form of repo_name/path_to_chart, got: amaze-surf

controlplane ~ ✖ helm show all bitnami/amaze-surf
Error: Unable to locate any tags in provided repository: oci://us-central1-docker.pkg.dev/kk-lab-prod/helm-charts/bitnami/amaze-surf

controlplane ~ ✖ helm list
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
amaze-surf      default         1               2026-07-13 13:01:27.316315276 +0000 UTC deployed        apache-11.3.2   2.4.63     

controlplane ~ ➜  #10

controlplane ~ ➜  #10

controlplane ~ ➜  helm list
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
amaze-surf      default         1               2026-07-13 13:01:27.316315276 +0000 UTC deployed        apache-11.3.2   2.4.63     
crazy-web       default         1               2026-07-13 13:03:40.268410004 +0000 UTC deployed        nginx-19.0.0    1.27.4     
happy-browse    default         1               2026-07-13 13:03:36.424943592 +0000 UTC deployed        nginx-19.0.0    1.27.4     

controlplane ~ ➜  #11

controlplane ~ ➜  helm uninstall happy-browse
release "happy-browse" uninstalled

controlplane ~ ➜  #12

controlplane ~ ➜  helm repo remove hashicorp
"hashicorp" has been removed from your repositories

controlplane ~ ➜  history
    1  #1
    2  #2
    3  helm ls
    4  #3
    5  helm sarch hub consul
    6  #4
    7  helm search hub consul
    8  #5
    9  helm repo add https://charts.bitnami.com/bitnami
   10  helm repo add bitnami https://charts.bitnami.com/bitnami
   11  hlm repo list
   12  helm repo list
   13  #6
   14  helm search repo wordpress
   15  #7
   16  helm repo list
   17  #8
   18  helm install amaze-surf bitnami/apache
   19  #9#9
   20  helm chart ls
   21  helm show all
   22  helm show all amaze-surf
   23  helm show all bitnami/amaze-surf
   24  helm list
   25  #10
   26  helm list
   27  #11
   28  helm uninstall happy-browse
   29  #12
   30  helm repo remove hashicorp
   31  history
```
# Practice Test - Upgrading a Helm Chart (7)
```cmd
         Welcome to the KodeKloud Hands-On lab                                                                                                      
    __ ______  ____  ________ __ __    ____  __  ______ 
   / //_/ __ \/ __ \/ ____/ //_// /   / __ \/ / / / __ \
  / ,< / / / / / / / __/ / ,<  / /   / / / / / / / / / /
 / /| / /_/ / /_/ / /___/ /| |/ /___/ /_/ / /_/ / /_/ / 
/_/ |_\____/_____/_____/_/ |_/_____/\____/\____/_____/  
                                                        
               All rights reserved                                                                                                                  

controlplane ~ ➜  #1

controlplane ~ ➜  helm repo add bitnami https://charts.bitnami.com/bitnami
"bitnami" has been added to your repositories

controlplane ~ ➜  #2

controlplane ~ ➜  helm list
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
dazzling-web    default         3               2026-07-13 13:07:07.922971978 +0000 UTC deployed        nginx-12.0.4    1.22.0     

controlplane ~ ➜  #3

controlplane ~ ➜  helm history
Error: "helm history" requires 1 argument

Usage:  helm history RELEASE_NAME [flags]

controlplane ~ ✖ helm history dazzling-web
REVISION        UPDATED                         STATUS          CHART           APP VERSION     DESCRIPTION     
1               Mon Jul 13 13:07:02 2026        superseded      nginx-12.0.4    1.22.0          Install complete
2               Mon Jul 13 13:07:04 2026        superseded      nginx-12.0.5    1.22.0          Upgrade complete
3               Mon Jul 13 13:07:07 2026        deployed        nginx-12.0.4    1.22.0          Upgrade complete

controlplane ~ ➜  #4

controlplane ~ ➜  #5

controlplane ~ ➜  

controlplane ~ ➜  

controlplane ~ ➜  

controlplane ~ ➜  helm history dazzling-web
REVISION        UPDATED                         STATUS          CHART           APP VERSION     DESCRIPTION     
1               Mon Jul 13 13:07:02 2026        superseded      nginx-12.0.4    1.22.0          Install complete
2               Mon Jul 13 13:07:04 2026        superseded      nginx-12.0.5    1.22.0          Upgrade complete
3               Mon Jul 13 13:07:07 2026        deployed        nginx-12.0.4    1.22.0          Upgrade complete

controlplane ~ ➜  

controlplane ~ ➜  helm upgrade dazzling-web bitnami/nginx --version 18.3.6
Pulled: us-central1-docker.pkg.dev/kk-lab-prod/helm-charts/bitnami/nginx:18.3.6
Digest: sha256:19a3e4578765369a8c361efd98fe167cc4e4d7f8b4ee42da899ae86e5f2be263
Release "dazzling-web" has been upgraded. Happy Helming!
NAME: dazzling-web
LAST DEPLOYED: Mon Jul 13 13:10:55 2026
NAMESPACE: default
STATUS: deployed
REVISION: 4
TEST SUITE: None
NOTES:
CHART NAME: nginx
CHART VERSION: 18.3.6
APP VERSION: 1.27.4

Did you know there are enterprise versions of the Bitnami catalog? For enhanced secure software supply chain features, unlimited pulls from Docker, LTS support, or application customization, see Bitnami Premium or Tanzu Application Catalog. See https://www.arrow.com/globalecs/na/vendors/bitnami for more information.

** Please be patient while the chart is being deployed **
NGINX can be accessed through the following DNS name from within your cluster:

    dazzling-web-nginx.default.svc.cluster.local (port 80)

To access NGINX from outside the cluster, follow the steps below:

1. Get the NGINX URL by running these commands:

  NOTE: It may take a few minutes for the LoadBalancer IP to be available.
        Watch the status with: 'kubectl get svc --namespace default -w dazzling-web-nginx'

    export SERVICE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].port}" services dazzling-web-nginx)
    export SERVICE_IP=$(kubectl get svc --namespace default dazzling-web-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    echo "http://${SERVICE_IP}:${SERVICE_PORT}"

WARNING: There are "resources" sections in the chart not set. Using "resourcesPreset" is not recommended for production. For production installations, please set the following values according to your workload needs:
  - cloneStaticSiteFromGit.gitSync.resources
  - resources
+info https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

controlplane ~ ➜  helm history dazzling-web
REVISION        UPDATED                         STATUS          CHART           APP VERSION     DESCRIPTION     
1               Mon Jul 13 13:07:02 2026        superseded      nginx-12.0.4    1.22.0          Install complete
2               Mon Jul 13 13:07:04 2026        superseded      nginx-12.0.5    1.22.0          Upgrade complete
3               Mon Jul 13 13:07:07 2026        superseded      nginx-12.0.4    1.22.0          Upgrade complete
4               Mon Jul 13 13:10:55 2026        deployed        nginx-18.3.6    1.27.4          Upgrade complete

controlplane ~ ➜  helm list
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
dazzling-web    default         4               2026-07-13 13:10:55.334684396 +0000 UTC deployed        nginx-18.3.6    1.27.4     

controlplane ~ ➜  #6

controlplane ~ ➜  #7

controlplane ~ ➜  helm rollback dazzling-web 3
Rollback was a success! Happy Helming!

controlplane ~ ➜  helm history dazzling-web
REVISION        UPDATED                         STATUS          CHART           APP VERSION     DESCRIPTION     
1               Mon Jul 13 13:07:02 2026        superseded      nginx-12.0.4    1.22.0          Install complete
2               Mon Jul 13 13:07:04 2026        superseded      nginx-12.0.5    1.22.0          Upgrade complete
3               Mon Jul 13 13:07:07 2026        superseded      nginx-12.0.4    1.22.0          Upgrade complete
4               Mon Jul 13 13:10:55 2026        superseded      nginx-18.3.6    1.27.4          Upgrade complete
5               Mon Jul 13 13:12:19 2026        deployed        nginx-12.0.4    1.22.0          Rollback to 3   

controlplane ~ ➜  helm rollback dazzling-web 2
Rollback was a success! Happy Helming!

controlplane ~ ➜  helm history dazzling-web
REVISION        UPDATED                         STATUS          CHART           APP VERSION     DESCRIPTION     
1               Mon Jul 13 13:07:02 2026        superseded      nginx-12.0.4    1.22.0          Install complete
2               Mon Jul 13 13:07:04 2026        superseded      nginx-12.0.5    1.22.0          Upgrade complete
3               Mon Jul 13 13:07:07 2026        superseded      nginx-12.0.4    1.22.0          Upgrade complete
4               Mon Jul 13 13:10:55 2026        superseded      nginx-18.3.6    1.27.4          Upgrade complete
5               Mon Jul 13 13:12:19 2026        superseded      nginx-12.0.4    1.22.0          Rollback to 3   
6               Mon Jul 13 13:12:42 2026        deployed        nginx-12.0.5    1.22.0          Rollback to 2   

controlplane ~ ➜  history
    1  #1
    2  helm repo add bitnami https://charts.bitnami.com/bitnami
    3  #2
    4  helm list
    5  #3
    6  helm history
    7  helm history dazzling-web
    8  #4
    9  #5
   10  helm history dazzling-web
   11  helm upgrade dazzling-web bitnami/nginx --version 18.3.6
   12  helm history dazzling-web
   13  helm list
   14  #6
   15  #7
   16  helm rollback dazzling-web 3
   17  helm history dazzling-web
   18  helm rollback dazzling-web 2
   19  helm history dazzling-web
   20  history
```

