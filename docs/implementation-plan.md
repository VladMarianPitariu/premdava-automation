# Implementation plan

## Pilot: node 6

1. Validate the repository and Semaphore execution.
2. Run `ansible/monitoring/check-status.yml` in `report_only` mode against the Prometheus API on infra5.
3. Verify Prometheus labels and build `inventory/targets.yml` from them.
4. Add the Windows runner on node 6 under `gmsaPremDava$`.
5. Run Hyper-V read-only collectors and create the first stable checkpoint.
6. Add post-restart verification.
7. Enable one allowlisted remediation only after the dry run is accepted.

## Scheduling

- Monitoring/status task: every 30 minutes.
- Configuration drift task: periodic and after a successful remediation.
- Post-restart checkpoint: only after health checks pass.

## Safety

The initial mode is `report_only`. CPU, memory and GPU alerts do not trigger remediation. No webhook value may become a PowerShell command; targets and actions must come from an allowlist.
