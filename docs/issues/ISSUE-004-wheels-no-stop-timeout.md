# ISSUE-004: Wheels keep spinning after stop command

## Symptom
After sending a velocity command, wheels continued spinning even after sending zero velocity or stopping the rostopic pub process. Robot would not stop moving.

## Root Cause (part 1 — stale rostopic pub process)
`rostopic pub -r 20` processes survived `kill` attempts and kept publishing velocity commands. The base controller continued executing them.

Fix: `pkill -f "rostopic pub"` to ensure all publisher processes are killed.

## Root Cause (part 2 — DiffDriveBaseController no timeout)
Investigated whether `timeout` param could be added to base_only_controllers.yaml to auto-stop wheels if no command received. Confirmed via binary strings analysis of robot_driver that DiffDriveBaseController does NOT support a `timeout` parameter. Attempted config was reverted.

## Fix
- Always kill rostopic pub processes with `pkill -f "rostopic pub"`
- Use software runstop for emergency stop: `rostopic pub -1 /enable_software_runstop std_msgs/Bool "data: true"`
- Publish zero velocity at rate before stopping: `rostopic pub -r 10 /base_controller/command geometry_msgs/Twist "{}" ` then kill

## How Found
Checked DiffDriveBaseController binary strings — no `timeout` string found. Confirmed via ROS documentation and source review.
