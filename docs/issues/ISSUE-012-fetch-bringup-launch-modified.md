# ISSUE-012: fetch.launch in installed package was directly modified

## What Was Changed
`/opt/ros/noetic/share/fetch_bringup/launch/fetch.launch` was edited directly (not via a workspace overlay). The `parampath` param was redirected:

**Original** (from dpkg package `ros-noetic-fetch-bringup 0.9.3`):
```xml
<param name="parampath" value="$(find fetch_bringup)/config/fetch_driver_params.json"/>
```
*(assumed — original line not preserved)*

**Modified to:**
```xml
<param name="parampath" value="/home/fetch/fetch_driver_params.json"/>
```

## Why
Early attempt to redirect driver params to a custom file at `/home/fetch/fetch_driver_params.json`. That file still has `has_fetch_arm: true` so it did not solve the ready=False problem on its own.

## Current Impact
No impact — we no longer use `fetch.launch`. Boot service uses `/etc/ros/noetic/robot.launch` which is our `base_only.launch` with `base_driver_params_false.json`.

## Risk
If `ros-noetic-fetch-bringup` is ever upgraded via apt, the package manager may overwrite this file and restore the original `parampath`. This is not a problem for us but worth knowing.

## Note on Direct Package Edits
Avoid editing files under `/opt/ros/noetic/` directly — they are managed by apt and can be overwritten on upgrade. Prefer:
1. Custom launch files (what we do — `base_only.launch`)
2. Catkin workspace overlays that shadow installed packages
