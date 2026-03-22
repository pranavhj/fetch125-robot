#!/bin/bash
setcap 'cap_ipc_lock+ep cap_sys_nice+ep' /opt/ros/noetic/lib/fetch_drivers/robot_driver
getcap /opt/ros/noetic/lib/fetch_drivers/robot_driver
echo "Done."
