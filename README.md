blueswitch
==========

## Description

This is a tiny utility with launchd daemon definition to ensure desired Bluetooth dongle (aka HCI host controller) remains active, e.g. after Mac reboot. Bluetooth Explorer utility by Apple provides HCI Controller Selector functionality, but its selection is NOT retained after a restart.

Moreover I observed that reported host controller jumped forth and back after the reboot, so the utility is running until first user is logged in.

If we want to mitigate broken or erratic built-in Bluetooth behavior, we can buy some $20 dongle (e.g. one using CSR8510 supported out of the box by macOS). However Apple provides no elegant way to ensure that THIS device not built-in is currently handling Bluetooth communication.

Many sites suggest using `sudo nvram bluetoothHostControllerSwitchBehavior=always` to ensure that USB dongle is preferred, but this DOES NOT work for me as for Mojave 10.14.6. I have reported that to Apple.

[macforums]: https://forums.macrumors.com/threads/mac-mini-2018-bluetooth-issues.2157086/

I have created this little tool to mitigate bad MacMini 2018 built-in Bluetooth reception as reported on [MacForums][macforums]. This tool uses some private `IOBluetooth` framework `BluetoothHCISwitchToSelectedHostController` function, the same as one used by Bluetooth Explorer utility, to switch to desired host controller.

Frustrated by stuttering and jumping of my Magic Mouse cursor, numerous disconnections of the mouse and keyboard. It took me a while to find out that MacMini Bluetooth is flawed. Almost bought new Magic Mouse. But finally found this [MacForums][macforums] thread.

Of course putting USB dongle would be too easy. Apple provided no freaking way to make this dongle remain active after the reboot. Was this all experience fun? Nope!

## Installation

### Compiling:

    cc -Wall -o blueswitch blueswitch.m -framework Foundation -framework IOBluetooth -framework SystemConfiguration

### Installing

Make sure you update `com.nanoant.blueutil.plist` with your Dongle's location ID and MAC address. This can be looked up in Bluetooth Explorer.

### Checking

    log show --info --debug --predicate 'senderImagePath endswith "blueswitch"'

This should show something like this after reboot:
~~~
blueswitch: Switching to location: 12300000 waiting for address: 00-11-22-33-44-55
blueswitch: Current host has address: aa-bb-cc-dd-ee-ff
blueswitch: Host is found and user: me logged in. Exiting.
~~~

## License

Released under MIT license.

>
> blueswitch Copyright (c) 2019 Adam Strzelecki
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> SOFTWARE.
>
