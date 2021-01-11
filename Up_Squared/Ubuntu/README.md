# UP Squared (Ubuntu 18.04) setup scripts for use as companion computer

These instructions create an APSync image for the [UP Squared board](https://up-board.org/upsquared/specifications/) (UP2) based on the official Ubuntu 18.04 LTS images.

## 1. Back-up the existing system (Optional)

If you already have an existing system onboard the UP2, it would be beneficial to first back-up the system with [clonezilla](https://clonezilla.org/downloads.php).
See related instructions on how to:
- [Clone the disk](https://clonezilla.org/show-live-doc-content.php?topic=clonezilla-live/doc/01_Save_disk_image),
- [Restore the disk](https://clonezilla.org/show-live-doc-content.php?topic=clonezilla-live/doc/02_Restore_disk_image).

## 2. System description

The **hardware** components include:
- [UP Squared board](https://up-board.org/upsquared/specifications/) (UP2) with Wifi/Network connection,
- Serial connection to the FCU (not covered here, see [wiki](https://ardupilot.org/copter/docs/common-telemetry-port-setup.html)),
- Optional: [Realsense T265 tracking camera](https://www.intelrealsense.com/tracking-camera-t265/) and/or [Realsense Depth camera](https://www.intelrealsense.com/stereo-depth/) (tested with D435).

The **software** components on the companion computer include:
- Automatically creates a Wifi Access Point on startup,
- Automatically runs a light-weight webserver which allows the user to connect to the drone using a known URL and perform various actions,
- Automatically launch the `t265_to_mavlink.py` and `d4xx_to_mavlink.py` scripts,
- Real-time video streaming of the RGB image from the Realsense camera on the drone to the ground station.

> **Note**: ensure the flight controller as well as the cameras (Realsense T265/D4xx specifically) are not connected to the UP2 until all installation steps are completed.

The following configuration and installation steps should be modified/removed according to your actual system and requirements.

## 3. Install the OS and prerequisites

The general instructions can be found [here](https://wiki.up-community.org/Ubuntu_18.04). In short, the steps are:

- Download the [Ubuntu LTS image](https://releases.ubuntu.com/). 18.04 is the recommended image.

- Burn the image onto a USB flash drive using [Balena Etcher](https://www.balena.io/etcher/) or [Win32DiskImager](https://wiki.ubuntu.com/Win32DiskImager).  On an Ubuntu desktop, try, "Startup Disk Creator"

- Provide network connection to the UP2, either with ethernet cable / USB wifi dongle / wifi adapter card.

- Insert the USB in an empty port of the UP2. Boot up the UP2 and follow the normal Ubuntu installation.
  - minimal installation
  - install 3rd party graphics and network software
  - use username/password/hostname up2/ubuntu/up2
   - In all of the follow-up sections, we assume the login username/password is `up2/ubuntu`. If you use a different username, change `STD_USER` in the `config.env` file.
  - do NOT log in automatically; the apsync user might do that, but not this base up2 user.

- Enable [SSH on Ubuntu 18.04](https://linuxize.com/post/how-to-enable-ssh-on-ubuntu-18-04/) on the UP2 itself. Monitor, keyboard + mouse, internet connection are required. 
  - Open a terminal and run:
  ```console
  sudo apt update
  sudo apt install openssh-server
  sudo ufw allow ssh
  ```
  - Check SSH server status. You should see something like `Active: active (running)`:
  ```console
  sudo systemctl status ssh
  ```

ssh into the UP2 from the host machine:
```console
ssh up2@up2.local
```

> Note: if up2.local is not resolved into an IP address, run `ip addr show` on the up2 to find its address.

## 3.5. Install extra drivers
sudo add-apt-repository -y ppa:aaeon-cm/upboard
sudo apt update
sudo apt-get autoremove -y --purge 'linux-.*generic'  # force it if required...
sudo apt-get install -y linux-generic-hwe-18.04-edge-upboard
sudo reboot

## 4. Install the packages and other components

- Once you log in, clone the companion repository:
```console
sudo apt install git
cd
mkdir GitHub
pushd GitHub
git clone https://github.com/ardupilot/companion
```
- Change the configurations according to your hardware system:
```console
# System configuration
# - Change STD_USER to the current username
# - Change SETUP_DEPTH_CAMERA=0 if not using depth camera
# - NORMAL_USER should NOT be changed (apsync)
pushd companion/Up_Squared/Ubuntu
nano config.env

# Serial connection
# - Change [UartEndpoint to_fc] to the actual serial connection
nano mavlink-rounter.conf
```

- Run the 1st setup script: 
```console
sudo ./1_Setup_user_and_update.sh
```

- Reboot the UP2, log back in using the username/password `apsync/apsync`:
```console
sudo reboot
ssh apsync@up2.local # SSH into the UP2 from the host computer
pushd GitHub/companion/Up_Squared/Ubuntu
sudo ./2_Clone_Repo_Disable_console_sethost.sh
```

- The UP2 will automatically reboot.
- The UP2 will change hostname to "apsync", so you need to log in using a different hostname:
ssh apsync@apsync.local # SSH into the UP2 from the host computer
- You need to log back in as `apsync` and run the rest of the scripts to complete the installation. For each script, I suggest skimming through to get the idea behind, decide whether it applies to your case and skip any deemed unnecessary.
```console
pushd GitHub/companion/Up_Squared/Ubuntu
sudo ./3_Setup_Network_and_Packages.sh  # Common packages and wifi hotspot
sudo ./4_setup_apsync_components.sh     # Web-based user interface
sudo ./5_setup_mavproxy.sh              # MavProxy running on the companion computer
sudo ./6_setup_uhubctl.sh               # Auto cycle the USB hub, if there is one
sudo ./7_setup_realsense.sh             # librealsense driver installation
sudo ./8_setup_vision_to_mavros.sh      # vision_to_mavros scripts for T265 (default, always used) and D4xx (optional) cameras
```
> Note: The installation of `librealsense` may take 2-3 hours to finish.

- Setup the Wifi access point
> Note: There is no on-board WiFi module on the Up-squared.  You will need a dongle capable of running in master-mode to set up an access point.
```console
sudo ./install_wifi_access_point.sh     # Setup a wifi hotspot with ssid/password ArduPilot/ardupilot
```

- Reboot the device


This completes the installation of AP Sync you are now ready to prepare the image for cloning.

## 5. Verify the system is working

### 5.1 Main components
Following the description in the [APSync main wiki](https://ardupilot.org/dev/docs/apsync-intro.html) to test the main components. The data flows are described [here](https://ardupilot.org/dev/docs/apsync-intro.html#how-flight-controller-data-is-routed-to-various-programs).

- If Wifi hotspot is enabled, connect to the network `ArduPilot` with password `ardupilot`. If you have trouble connecting, consider disabling the password requirement. Once connected to the WiFi network it would be possible to:
  - Connect to AP Web server via the URL `http://10.0.1.128`. Details of available actions on the AP Web server can be found [here](https://ardupilot.org/dev/docs/apsync-intro.html#wifi-access-point-dataflash-logging).
  ![test_webap](https://i.imgur.com/tO0ATYT.png)
  - ssh to `10.0.1.128` username: `apsync`, password: `apsync`.

- In Mission Planner or other ground station:
  - Setting the connection to using “UDP”, port 14550.
  - Once connected, open `Ctrl-F` > `MAVLink inspector` and verify the data from the T265 (`VISION_POSITION_ESTIMATE`, `VISION_SPEED_ESTIMATE`) and D4xx (`OBSTACLE_DISTANCE`) cameras are being received:
  ![test_mavlink](https://i.imgur.com/NYgYWTG.png)

### 5.2 Video feed:
First, setup gstreamer feed in Mission Planner:
- Installation of [`gstreamer 1.0`](https://gstreamer.freedesktop.org/download/) is required, but should be done automatically by MP.
- On MP: right-click the HUD > `Video` > `Set GStreamer Source`.
  - Test MP's gstreamer by passing the test pipeline in the Gstreamer url window:
    ```console
    videotestsrc ! video/x-raw, width=1280, height=720,framerate=25/1 ! clockoverlay ! videoconvert ! video/x-raw,format=BGRA ! appsink name=outsink
    ```
  - You should see something similar to this:
    ![test_hud](https://i.imgur.com/QaGvWfk.png)

The script `d4xx_to_mavlink.py` has an option `RTSP_STREAMING_ENABLE`. If enabled (`True`), a video stream of the RGB image from the depth camera will be available at `rtsp://10.0.1.128:8554/d4xx`:
- Pass the following pipeline into the Gstreamer url window. Change the ip address if need to:
```console
rtspsrc location=rtsp://10.0.1.128:8554/d4xx caps=“application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264” latency=100 ! queue ! rtph264depay ! avdec_h264 ! videoconvert ! video/x-raw,format=BGRA ! appsink name=outsink
```
- You should see the RGB image overlay on the HUD. Additionally, open the Proximity View (`Ctrl-F` > `Proximity`) to visualize the obstacle avoidance data.
  ![img](https://i.imgur.com/NtVY49b.png)


## 6. Clean up ready for imaging

... sudo ./clean-for-imaging.sh


## 7. Create image
 - create USB flash drive containing clonezilla
  - https://clonezilla.org/liveusb.php
- plug in *another* USB flash drive to contain image
 - run through clonezilla to create image...
