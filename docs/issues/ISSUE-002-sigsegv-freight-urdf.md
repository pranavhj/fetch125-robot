# ISSUE-002: robot_driver SIGSEGV with freight.urdf + has_fetch_arm:false

## Symptom
After setting `has_fetch_arm: false`, robot_driver crashed with SIGSEGV immediately on startup.

## Root Cause
The original launch used `freight.urdf` which has no arm joint definitions. Even with `has_fetch_arm: false`, the driver still dereferences internal pointers to arm joint structures during initialization. With freight.urdf those joints don't exist in the robot_description, so the pointers are null → segfault.

## Fix
Switched `robot_description` to use `fetch.urdf` (full Fetch URDF including all joint definitions):
```xml
<param name="robot_description" textfile="$(find fetch_description)/robots/fetch.urdf" />
```
The driver can find all joint pointers even though the arm boards aren't present.

## How Found
Process of elimination: driver crashed before printing any log. Compared freight.urdf vs fetch.urdf — freight.urdf omits all arm joints. Switching to fetch.urdf resolved the segfault.
