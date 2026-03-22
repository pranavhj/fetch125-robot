# ISSUE-008: Robot internal network lost after cable swap

## Symptom
After reconnecting Ethernet cables, mainboard at 10.42.42.42 became unreachable. `ip link show eth1` showed `NO-CARRIER`.

## Root Cause
The robot internal network cable was plugged into the wrong Ethernet port (eth0 instead of eth1). The static IP 10.42.42.1/24 is hardcoded to `eth1` in `/etc/netplan/99-fetch-ethernet.yaml`. eth0 gets a DHCP address for external/WiFi network. Swapping the cable to eth0 leaves eth1 with no carrier and no route to the mainboard.

## Fix
Plug the robot internal network cable (going to mainboard/SICK laser) into the **eth1** port specifically. The port labeled or physically identified as eth1 on the robot PC.

## Key Config
`/etc/netplan/99-fetch-ethernet.yaml`:
```yaml
network:
  version: 2
  ethernets:
    eth1:
      addresses: [10.42.42.1/24]
```

## How Found
`ip link show eth1` → `NO-CARRIER`. `ip link show eth0` → UP but no 10.42.42.x address. Checked netplan config which hardcodes eth1.
