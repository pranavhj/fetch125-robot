#!/bin/bash
# Installs the working base_only launch as the boot service launch file.
# Must be run with sudo: sudo bash /home/fetch/install_robot_launch.sh

set -e

DEST=/etc/ros/noetic/robot.launch

cp "$DEST" "${DEST}.bak.$(date +%Y%m%d_%H%M%S)"
echo "Backed up original to ${DEST}.bak.*"

cp /home/fetch/base_only.launch "$DEST"
chmod 644 "$DEST"
echo "Installed /home/fetch/base_only.launch -> $DEST"

# Make sure param/controller files are readable by ros user
chmod 644 /home/fetch/base_driver_params_false.json
chmod 644 /home/fetch/base_only_controllers.yaml
echo "Set permissions on param files"

echo "Done. Restart the service with: sudo systemctl restart robot.service"
