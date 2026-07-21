# Question 13 — Create and Switch the Default StorageClass

## Background

Manage StorageClasses without touching existing workloads.

---

## Tasks

- Create a StorageClass named:

  ```
  local-fast
  ```

  using provisioner:

  ```
  rancher.io/local-path
  ```

  with:

  ```
  volumeBindingMode: WaitForFirstConsumer
  ```

  **Do not** mark it as the default StorageClass when creating it.

- Patch it afterward to become the default StorageClass.

- Ensure **local-fast** is the **only** default StorageClass (the existing default is named **standard**).

- Do **not** modify any existing Deployment or PVC.

---

## Validation

After completing the task, verify your solution:

```bash
./verify.sh
```