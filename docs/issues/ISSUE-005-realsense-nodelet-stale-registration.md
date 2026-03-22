# ISSUE-005: RealSense "Cannot load nodelet — same name already exists"

## Symptom
After restarting ROS (especially after kill -9 on rosmaster), the realsense2_camera nodelet failed to load with error about a nodelet with the same name already being registered.

## Root Cause
When rosmaster was killed with `kill -9`, it didn't cleanly unregister all nodes. Stale nodelet registrations remained in the new rosmaster instance's state, blocking the realsense nodelet from loading again.

## Fix
After `kill -9 rosmaster`, always run `rosnode cleanup` to wipe stale registrations, or restart the entire ros session cleanly via the service.

## How Found
Error message from nodelet manager log. Observed that clean ROS restarts (via systemctl) never hit this issue — only manual kill -9 sessions.
