# ISSUE-009: RealSense D435 cameras drop off USB after cold boot

## Symptom
After reboot, `lsusb` shows no RealSense devices on Bus 004. `rs-enumerate-devices` returns "No device detected". The RealSense ROS node logs "No RealSense devices were found!" repeatedly.

## Root Cause
USB enumeration fails at boot with `error -71` (EPROTO — protocol error) on the USB 3.0 ports the cameras are connected to. The kernel power-cycles the port and retries but the cameras still fail to enumerate. Likely a USB power delivery or timing issue during boot. The cameras work fine once physically reconnected.

```
dmesg output:
usb 4-x: device descriptor read/64, error -71
usb usb4-portX: attempt power cycle
usb 4-x: Device not responding to setup address.
usb usb4-portX: unable to enumerate USB device
```

## Workaround
After boot, physically unplug and replug the USB cables going to the RealSense cameras. They enumerate correctly after reconnect.

## Permanent Fix (not yet implemented)
A udev rule or systemd service could trigger a USB port reset automatically after boot. TBD.

## How Found
`dmesg | grep "usb 4"` showed enumeration errors at boot timestamps. Physical reconnect always resolved it.
