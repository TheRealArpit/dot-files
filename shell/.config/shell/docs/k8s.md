# Kubernetes & Fyre Quick Reference

## Cluster Switching
| Function / Alias | Description |
| :--- | :--- |
| `kube-local` | Unsets `KUBECONFIG` and switches context to local (`rancher-desktop`) |
| `kube-stack` | Exports `KUBECONFIG="$HOME/Downloads/kubeconfig.config"` (stack cluster) |
| `kube-ctx` | Prints current active kubectl context |

## IDIG Operator Helpers
| Alias | Command / Description |
| :--- | :--- |
| `kn` | `kubectl -n idig-system` (scoped command runner) |
| `idig-status` | `kubectl get idig -n idig-system -o wide` |
| `idig-pods` | `kubectl get pods -n idig-system` |
| `idig-logs` | Stream logs for idig-operator deployment |
| `idig-events` | Tail last 20 events in idig namespace |
| `idig-run` | Full local dev clean, generate, CRD install, build, and run sequence |

## Fyre Cluster Management
| Function | Description |
| :--- | :--- |
| `fyre-create <name>` | Spin up 3-node k8s 1.33 SVL cluster with gateway API & registry credentials |
