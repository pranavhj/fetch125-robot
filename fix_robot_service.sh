#!/bin/bash
# Must be run with: sudo bash /home/fetch/fix_robot_service.sh
set -e

cat > /lib/systemd/system/robot.service << 'EOF'
[Unit]
Description=Job that launches the robot drivers once roscore has started
After=roscore.service
BindsTo=roscore.service

[Install]
WantedBy=roscore.service

[Service]
Environment="ROS_LOG_DIR=/var/log/ros"
Restart=on-failure
StandardOutput=append:/var/log/ros/robot.log
StandardError=append:/var/log/ros/robot.log

User=ros
ExecStart=/usr/bin/bash -c ". /opt/ros/noetic/setup.bash && . /home/fetch/fetch_ws/devel/setup.bash && roslaunch /etc/ros/noetic/robot.launch --wait"
EOF

systemctl daemon-reload
echo "Done. Verify with: cat /lib/systemd/system/robot.service"
