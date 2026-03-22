#!/bin/bash
echo "/opt/ros/noetic/lib" > /etc/ld.so.conf.d/ros-noetic.conf
ldconfig
echo "Done. Verifying liburdf.so:"
ldconfig -p | grep liburdf
