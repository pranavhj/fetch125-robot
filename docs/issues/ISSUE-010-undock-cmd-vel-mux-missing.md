# ISSUE-010: Undock action aborts — robot doesn't move

## Symptom
Calling the `/undock` action returned `status: 4` (ABORTED) with log message "Undocking failed: timed out". The robot did not move despite the auto_dock node sending `linear.x: -0.1` backup commands to `/cmd_vel`.

## Root Cause
`base_only.launch` did not include the teleop launch (intentionally — no joystick needed). The `cmd_vel_mux` node is defined in `fetch_bringup/launch/include/teleop.launch.xml` and was therefore not running.

Without `cmd_vel_mux`, nothing was forwarding `/cmd_vel` to `/base_controller/command`. The auto_dock node publishes to `/cmd_vel`, not directly to `/base_controller/command`, so its velocity commands were never reaching the robot_driver.

Confirmed: `rostopic info /base_controller/command` showed `Publishers: None`.

## Fix
Added `cmd_vel_mux` node directly to `base_only.launch`:
```xml
<node name="cmd_vel_mux" pkg="topic_tools" type="mux" args="base_controller/command /cmd_vel /teleop/cmd_vel">
  <remap from="mux" to="cmd_vel_mux" />
  <param name="initial_topic" value="/cmd_vel" />
</node>
```
The `initial_topic` param ensures `/cmd_vel` is selected by default without needing a manual `rosservice call`.

## How Found
Observed `cmd_vel` receiving commands from auto_dock but wheels not moving. Checked `rostopic info /base_controller/command` → no publishers. Traced the mux node to `teleop.launch.xml` which was not included. Added directly to launch file.
