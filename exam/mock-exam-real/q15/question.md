# Câu 15 — Expose a Node.js Deployment via NodePort

## Background

Reconfigure the existing Deployment **web-front** in namespace **svc-lab** to expose port **3000/TCP** of the existing container **node-app** (a Node.js application).

## Tasks

- Add the container port **3000/TCP** to the existing container **node-app** in the Deployment **web-front**.
- Create a new Service named **web-front-svc** exposing the container port **3000/TCP**.
- Configure the new Service to also expose the individual Pods via **NodePort** (let Kubernetes auto-assign the NodePort).

## Validation

```bash
./verify.sh
```