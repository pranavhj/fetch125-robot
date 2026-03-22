#!/bin/bash
# Start Fetch125 mobile base (Freight 100, ROS Noetic)
# Uses fetch.urdf + has_fetch_arm:false + base-only controllers
# Result: ready=True, base_controller active, wheels respond to /base_controller/command

source /opt/ros/noetic/setup.bash
roslaunch /home/fetch/base_only.launch
