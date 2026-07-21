# Question 6 — Custom Resource Definitions (cert-manager)

## Background

The Kubernetes cluster already has the **cert-manager CustomResourceDefinitions (CRDs)** installed.

Your task is to inspect the CRDs using kubectl.

---

## Tasks

1. List all cert-manager CRDs and save the output to:

   ```
   /root/cm-crds.yaml
   ```

   Use **kubectl's default output format**.

2. Extract the documentation for the following field:

   ```
   Certificate.spec.dnsNames
   ```

   Save the output to:

   ```
   /root/dnsnames.yaml
   ```

   Any output format is acceptable for this task.

---

## Validation

After completing the task, verify your solution:

```bash
./verify.sh
```