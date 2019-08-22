blueswitch
==========

## Description

This is a tiny utility plus a launchd daemon definition to ensure desired Bluetooth dongle (aka HCI host controller) remains active, e.g. after Mac reboot. Bluetooth Explorer (by Apple) HCI Controller Selector function was so far the only to switch from built-in device to USB dongle. This selection is however NOT retained after a restart.

Many sites suggest using `sudo nvram bluetoothHostControllerSwitchBehavior=always` to ensure that USB dongle is preferred, but this DOES NOT work for me as for Mojave 10.14.6. I have reported that to Apple.

[macforums]: https://forums.macrumors.com/threads/mac-mini-2018-bluetooth-issues.2157086/

## Story

I have created this little tool to mitigate bad MacMini 2018 built-in Bluetooth reception as reported by many users at [MacForums][macforums]. This tool uses some private `IOBluetooth` framework `BluetoothHCISwitchToSelectedHostController` function, the same as one used by Bluetooth Explorer utility, to switch to desired host controller.

I was frustrated by stuttering and jumping of my Magic Mouse cursor, numerous disconnections of the mouse and keyboard of new MacMini 2018. It took me a while to find out that MacMini Bluetooth hardware is flawed. Replaced Magic Mouse batteries, cleaned the contacts, almost bought new Magic Mouse. But finally found this [MacForums][macforums] thread.

Of course putting Bluetooth dongle into MacMini USB would be too easy to have it working. Apple provided cumbersome way to make it active and no freaking way to make it remain active after the reboot. Was this all experience fun? Nope!

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
