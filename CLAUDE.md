# Fetch Freight 100 - Claude Code Notes

## Robot Config
- Platform: Fetch Freight 100 (mobile base only — no arm, torso, or head)
- OS: Ubuntu 20.04, ROS Noetic
- Hostname: fetch125
- Internal network: eth1 @ 10.42.42.1/24 (hardcoded — must use eth1 port specifically)
- Mainboard: 10.42.42.42
- SICK laser: 10.42.42.10:2112

## Key Files
- `/home/fetch/base_only.launch` — primary working launch file (keep in sync with /etc/ros/noetic/robot.launch)
- `/home/fetch/base_driver_params_false.json` — driver params with has_fetch_arm:false
- `/home/fetch/base_only_controllers.yaml` — base-only controllers (no arm_controller)
- `/etc/ros/noetic/robot.launch` — boot service launch (installed from base_only.launch)

## When You Find Issues or Learn Something
**Document in `/home/fetch/docs/issues/`** — one file per issue or discovery.
Use the format: `ISSUE-NNN-short-title.md`
This includes:
- Bugs fixed: symptom, root cause, fix, how found
- System knowledge: how subsystems work, topic topology, config explanations
- Quirks and workarounds: anything non-obvious about this robot's setup

## Boot Services
- `roscore.service` → `robot.service` (both enabled, run as `ros` user)
- If services fail at boot: check `journalctl -u roscore.service` — common cause is `/var/log/ros/` owned by `fetch` instead of `ros`. Fix: `sudo chown -R ros:ros /var/log/ros`

## Known Hardware Quirks
- RealSense D435 cameras (x2, USB 8086:0b07) drop off USB after cold boot with error -71. Workaround: physically unplug and replug USB cables after boot.
- Auto-suspend was enabled by default and would suspend the robot mid-session. Fixed by masking sleep targets (see ISSUE-006).
- eth1 is hardcoded for the robot internal network — plugging the internal cable into eth0 breaks mainboard connectivity.
