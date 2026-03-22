# ISSUE-003: robot_driver SIGSEGV with default_controllers.yaml + has_fetch_arm:false

## Symptom
After fixing the URDF issue, robot_driver still crashed with SIGSEGV. Crash occurred after URDF loaded successfully, during controller initialization.

## Root Cause
The default `default_controllers.yaml` (from fetch_bringup) includes `arm_controller` and `gravity_compensation`. These controllers attempt to set up control structures for torso_lift_link and arm joints. With `has_fetch_arm: false`, the driver has no arm board data, so those controller setup calls dereference null pointers → segfault.

## Fix
Created `/home/fetch/base_only_controllers.yaml` containing only `base_controller`:
```yaml
base_controller:
  type: "robot_controllers/DiffDriveBaseController"
  ...
  autostart: true

robot_driver:
  default_controllers:
    - "base_controller"
```
Loaded this file instead of the default controllers yaml in the launch file.

## How Found
Stack trace showed crash in controller manager during arm_controller initialization. Confirmed by checking binary strings in robot_driver — arm_controller/gravity_compensation referenced alongside arm board setup code.
