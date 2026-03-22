# ISSUE-006: Robot suspends to sleep mid-session

## Symptom
Robot PC would unexpectedly go offline during operation. SSH sessions showed "crash" in `last` output. No warning before shutdown.

## Root Cause
Ubuntu default power management was enabled. After an idle period (~20 minutes), the system entered deep suspend (`systemd-sleep`). The `last` command reports this as a "crash" since there's no clean logout.

Confirmed via `journalctl -b -1`:
```
systemd[1]: Reached target Sleep.
systemd[1]: Starting Suspend...
systemd-sleep[3745]: Suspending system...
kernel: PM: suspend entry (deep)
```

## Fix
Permanently masked all sleep targets:
```bash
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

## How Found
Checked `last -x` which showed `shutdown` entry followed by immediate `reboot`. Checked `journalctl -b -1` tail which showed suspend sequence.
