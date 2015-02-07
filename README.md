Caretaker Home Automation  Server
=================================

Caretaker is a DIY home automation and survaillance project. The aim is to create a totally wireless and scaleable
system to control power switches (lamps and other electrical appliances) and measure values like temperatures,
brightness and power consumption. All devices should be controllable through local devices as well as mobile
devices over the internet. The goal is to use XBee modules which implement the ZigBee wireless protocol in every
device. ZigBee allows a bi-directional communication between all devices, so besides controlling a device it can
itself send asynchronous status update messages, i.e. pressing a physical button on a dimmer to switch a lamp on,
will also update a button in a remote control application, eliminating the need for periodically polling the
device status

This project contains the server side of the Caretaker project. Other projects contain schematics, PCB layouts and
firmware for the attached devices.

Installation
------------

For a minimal system setup, please refer to this
[installtion tutorial](http://www.grappendorf.net/projects/caretaker/minimal-caretaker-setup-guide) on the
[project webiste](http://www.grappendorf.net/projects/caretaker).

Licenses
--------

### Caretaker Server

The Caretaker Server code is licensed under the MIT license
You find the license in the attached LICENSE file

### Nuvola Icon Set

Uses some of the Nuvola icons, licensed under the GNU LGPL 2.1 license
You find the license at http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html
You find the icon set at http://www.icon-king.com/projects/nuvola/

### Third party gems

The used Ruby gems and JavaScript libraries either use the MIT license or the Apache Version 2.0 license.

You find the Apache license at http://opensource.org/licenses/Apache-2.0
You find the MIT license at http://opensource.org/licenses/MIT
