# Kubernetes & Fyre Quick Reference

── Cluster Switching ─────────────────────────────────────────────
  `kube-local`        Switch context to local rancher-desktop
  `kube-stack`        Switch KUBECONFIG to stack cluster (~/Downloads/kubeconfig.config)
  `kube-ctx`          Print active kubectl context

── IDIG Operator ─────────────────────────────────────────────────
  `kn <cmd>`          Run kubectl command scoped to idig-system namespace
  `idig-status`       Get IDIG CR status (-o wide)
  `idig-pods`         List all pods in idig-system
  `idig-logs`         Stream logs for idig-operator
  `idig-events`       Tail last 20 events in idig-system
  `idig-run`          Run full clean, manifest generate, CRD install & dev operator

── Fyre Cloud ────────────────────────────────────────────────────
  `fyre-create <n>`   Spin up 3-node SVL k8s cluster with gateway API
