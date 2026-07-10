# Ingress
```cmd
controlplane ~ ➜  k create ingress -h | grep -i "rewrite" -C5

controlplane ~ ✖  kubectl create ingress annotated --class=default --rule="foo.com/bar=svc:port" \
  --annotation ingress.annotation1=foo \
  --annotation ingress.annotation2=bl --dry-run=client -oyaml > template.yaml
  
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
```