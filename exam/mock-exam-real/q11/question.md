# Question 11 — Expose a Deployment via NodePort and Ingress

## Background

Expose the existing **echo-server** Deployment in namespace **echo-lab**.

---

## Tasks

- Create a Service named:

  ```
  echo-svc
  ```

  of type:

  ```
  NodePort
  ```

  exposing port:

  ```
  9090
  ```

- Create an Ingress named:

  ```
  echo-ing
  ```

  in namespace:

  ```
  echo-lab
  ```

  routing:

  ```
  http://echo.example.local/ping
  ```

  to the Service.

- Verify using:

  ```
  curl NODEIP:NODEPORT/ping
  ```

  and (if an Ingress controller and `/etc/hosts` entry are configured):

  ```
  curl -o /dev/null -s -w "%{http_code}\n" \
  http://echo.example.local/ping
  ```

---

## Validation

After completing the task, verify your solution:

```bash
./verify.sh
```