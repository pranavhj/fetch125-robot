# ISSUE-011: Understanding cmd_vel_mux — purpose and topology

## Topic Routing Topology
```
/cmd_vel          (navigation, auto_dock, scripts)  ─┐
                                                      ├─→ cmd_vel_mux → /base_controller/command → robot_driver → wheels
/teleop/cmd_vel   (joystick)                         ─┘
```

## Why It Exists
The mux allows runtime switching between two velocity sources without killing either node:
- `/cmd_vel` — autonomous/navigation commands (auto_dock, move_base, manual scripts)
- `/teleop/cmd_vel` — joystick/gamepad override

Switch active source with:
```bash
rosservice call /cmd_vel_mux/select "/cmd_vel"
rosservice call /cmd_vel_mux/select "/teleop/cmd_vel"
```

## On This Robot
No active joystick, so `/teleop/cmd_vel` is unused. But the mux is still required because `auto_dock` and any future navigation stack publish to `/cmd_vel`, and the mux is the only bridge to `/base_controller/command`.

Publishing directly to `/base_controller/command` bypasses the mux entirely and also works — useful for quick manual testing.

## Config in base_only.launch
```xml
<node name="cmd_vel_mux" pkg="topic_tools" type="mux" args="base_controller/command /cmd_vel /teleop/cmd_vel">
  <remap from="mux" to="cmd_vel_mux" />
  <param name="initial_topic" value="/cmd_vel" />
</node>
```
`initial_topic` ensures `/cmd_vel` is selected at startup without manual service call.
