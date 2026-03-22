# ISSUE-007: roscore.service fails at boot — chown permission denied

## Symptom
After reboot, `roscore.service` and `robot.service` both failed to start. Robot had no ROS on boot.

## Root Cause
`/opt/ros/roscore_prestart.bash` runs at service start and does:
```bash
mkdir -p /var/log/ros/
chown ros:ros /var/log/ros/
```
When ROS was previously run manually as the `fetch` user (not via the service), it created files/directories under `/var/log/ros/` owned by `fetch`. The prestart script cannot reassign ownership from `fetch` to `ros` without root privileges — it runs in a restricted context — so it exits with code 1, aborting the service.

## Fix
```bash
sudo chown -R ros:ros /var/log/ros
```
This gives ownership back to `ros` so the prestart script's chown succeeds on subsequent boots.

## Prevention
Always start/stop ROS via `sudo systemctl start/stop robot.service` rather than running `roslaunch` manually as `fetch`. This ensures log files stay owned by `ros`.

## How Found
`journalctl -u roscore.service` showed `chown: changing ownership of '/var/log/ros/': Operation not permitted`. Checked `ls -la /var/log/ros/` — owned by `fetch` instead of `ros`.
