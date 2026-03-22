# ISSUE-001: robot_driver never reaches ready=True

## Symptom
`/robot_driver/is_ready` never published `True`. Motors would not actuate. Robot stuck waiting indefinitely at startup.

## Root Cause
The driver was configured with `has_fetch_arm: true` (default fetch_driver_params.json). This causes `robot_driver` (FreightDriver class) to wait for all arm MCBs to come online:
- 0x26–0x2c: 7 arm joint boards
- 0x13: torso
- 0x14: head_pan
- 0x15: head_tilt

This robot has none of those boards (mobile base only), so the driver waits forever.

## Fix
Created `/home/fetch/base_driver_params_false.json` with `"has_fetch_arm": false`.
Pointed robot_driver to it via `<param name="parampath" value="/home/fetch/base_driver_params_false.json" />` in launch file.

## How Found
Inspected driver binary strings to find `has_fetch_arm` param. Confirmed by checking which MCB board IDs the driver was waiting for vs which boards actually exist on the robot internal network (10.42.42.x).
