# Question 12 — Choose the Least-Permissive NetworkPolicy

## Background

There are two Deployments:

- **web-tier** (namespace **web-tier**)
- **api-tier** (namespace **api-tier**)

Three candidate NetworkPolicy files exist in:

```
/root/netpols/
```

---

## Tasks

- Review the three candidate policies.

- Apply the one that allows:

  - **web-tier** to reach **api-tier**
  - TCP port **8080**

  in the **least permissive** way possible.

---

## Validation

After completing the task, verify your solution:

```bash
./verify.sh
```