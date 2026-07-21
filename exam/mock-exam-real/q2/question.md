# Question 2 — Argo CD via Helm Template Without CRDs

## Background

Your Kubernetes cluster already has the Argo CD CustomResourceDefinitions (CRDs) installed.

Your task is to install Argo CD using Helm **without installing the CRDs again**.

---

## Tasks

1. Add the official Argo CD Helm repository with the name **argo-helm**.

   Repository:

   ```
   https://argoproj.github.io/argo-helm
   ```

2. Create a namespace named:

   ```
   gitops-ns
   ```

3. Generate a Helm template from the **Argo CD** chart using:

   - Chart Version: **7.9.0**
   - Namespace: **gitops-ns**

4. Ensure the generated manifest **does not contain any CRDs**.

5. Save the generated manifest to:

   ```
   /root/argocd-template.yaml
   ```

6. Install Argo CD using Helm with:

   - Release Name: **argocd**
   - Chart Version: **7.9.0**
   - Namespace: **gitops-ns**

7. Ensure the installation uses the **same configuration** as the generated template (CRDs disabled).

---

## Validation

After completing the task, verify your solution:

```bash
./verify.sh
```