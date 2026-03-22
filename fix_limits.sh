#!/bin/bash
# Allow fetch user to lock unlimited memory and set realtime priority
cat >> /etc/security/limits.conf << 'EOF'
fetch soft memlock unlimited
fetch hard memlock unlimited
fetch soft nice -20
fetch hard nice -20
fetch soft rtprio 99
fetch hard rtprio 99
EOF
echo "Done. New limits for fetch user:"
grep "^fetch" /etc/security/limits.conf
