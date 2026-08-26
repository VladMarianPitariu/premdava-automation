# PremDava Infrastructure Automation

Centralized monitoring remediation and controlled automation for the PremDava on-premise infrastructure.

## Scope

- Grafana, Prometheus and Blackbox alert integration
- Semaphore job orchestration and audit
- Windows runners on Hyper-V hosts
- PowerShell operations executed under the approved PremDava gMSA
- Controlled Hyper-V and VM remediation
- Ansible over SSH for Ubuntu VMs
- Configuration and drift validation

## Initial PoC

The first implementation target is node 7. After validation, the same model will be extended to the other Hyper-V hosts.

```text
Grafana / Prometheus
        |
        v
Semaphore
        |
        v
Windows runner on Hyper-V host
        |
        v
PremDava gMSA
        |
        v
Hyper-V host and local VMs
```

## Repository layout

- `docs/` — architecture, operations and audit documentation
- `powershell/` — controlled Windows runner scripts
- `semaphore/` — Semaphore templates and job definitions
- `ansible/` — Ubuntu VM playbooks
- `inventory/` — host and VM mappings

## Security principles

- No gMSA password is stored in Semaphore or Kubernetes.
- PowerShell execution is allowlisted; arbitrary commands are rejected.
- Inputs from Grafana are validated against known hosts, VMs and actions.
- Remediation includes pre-checks, post-checks, cooldown and retry limits.
- All operations must be traceable to an alert, job and target.
# premdava-automation
