# companion

Companion computer startup scripts and examples.

This repo is where you can contribute both feedback about (issues) and improvements to (PRs) ArduPilot companion computer support.


## Repo organisation

This repository is organized by board and then by OS. It follows the following structure:

```
Root
  |___Board1
  |     |___OS1
  |     |___OS2
  |
  |___Board2
  		|___OS1
  		|___OS2
```  
## Key links

* [Companion Computers](http://ardupilot.org/dev/docs/companion-computers.html) (Dev Wiki)
* [Gitter chat](https://gitter.im/ArduPilot/companion)


## Roadmap

201708
  APWeb

2017-PRIME
  SmartShots
  Allow flashing of firmware via APWeb
    Will require users to reflash their bootloader
  Change username/password to ardupilot/ardupilot?
  Get GPS accuracies into place

2017-PRIMEPRIME
  APWeb to drop privs
  CUAV
  Multipe IMUs on system tab
  Reinstate Map tab
  Reinstate motor-test tab


2017-PRIMEPRIMEPRIME
  Multi-Camera-Daemon
  Graph multiple sensors in Calibration screen
  OpenKAI

2018-?
  Support for returning password in system.html
    - requires TX1's Ubuntu to have an nmcli that supports -s properly
