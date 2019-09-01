blueswitch
==========

## Description

This is a tiny utility plus a launchd daemon definition to ensure desired Bluetooth dongle (aka HCI host controller) remains active in *macOS*, e.g. after *Mac* reboot.

[apple]: https://developer.apple.com/bluetooth/

[Bluetooth Explorer][apple] from Apple Developer Tools contains HCI Controller Selector function that was so far the only way to switch from built-in Bluetooth host device to plugged in USB dongle. This selection is however NOT retained after a restart.

Many sites suggest using

    sudo nvram bluetoothHostControllerSwitchBehavior=always

to ensure that USB dongle is preferred and selected after *macOS* reboot, but this DOES NOT work for me as for Mojave 10.14.6. Maybe it once worked in macOS (or Mac OS X), but the functionality was silently removed or altered.

## Story

[macforums]: https://forums.macrumors.com/threads/mac-mini-2018-bluetooth-issues.2157086/

I have created this little tool to mitigate mediocre built-in Bluetooth radio reception as reported by many other users at [MacForums][macforums]. This tool uses private `IOBluetooth` framework `BluetoothHCISwitchToSelectedHostController` function - same way as Bluetooth Explorer does to switch to desired host controller.

I was frustrated by stuttering and jumpy behavior Magic Mouse connected to my new *MacMini* 2018. I have also experienced numerous disconnects of the mouse and keyboard. It took me a while to find out that *MacMini* Bluetooth hardware was to blame. After I have replaced Magic Mouse batteries, cleaned the contacts, almost bought new Magic Mouse, I found this [MacForums][macforums] thread.

Of course putting Bluetooth dongle into MacMini USB and expecting it to work would be too easy. Apple provided only one cumbersome way to make the dongle active using private API and no obvious way to make it remain active after the reboot.

Was this all experience fun? Nope! But this maybe spares you some dose of frustration.

## Installation

1. Update `com.nanoant.blueutil.plist` with your Dongle's location ID and MAC address. This can be looked up in [Bluetooth Explorer][apple].

2. Open terminal in the project folder and type:

   ~~~
   make
   ~~~

   You will be asked for password by `sudo` too install binary into `/usr/local/bin` and service definition into `/Library/LaunchDaemons`.

3. Verify the service was run by launchd:

   ~~~
   log show --info --debug --predicate 'senderImagePath endswith "blueswitch"'
   ~~~

   This should show something like this after reboot:
   ~~~
   blueswitch: Switching to location: 12300000 waiting for address: 00-11-22-33-44-55
   blueswitch: Current host has address: aa-bb-cc-dd-ee-ff
   blueswitch: Host is found and user: me logged in. Exiting.
   ~~~

   Repeat this after reboot if your dongle was not picked up after the reboot.

### Notes

This tool can be used as a simple command line utility, e.g.:

    blueswitch 12300000 00-11-22-33-44-55

This will switch to location `12300000` and wait to ensure current Bluetooth host's MAC address is `00-11-22-33-44-55`. If not it will initiate switch and wait again.

`blueswitch` contains the check if nobody is logged in (via `SCDynamicStoreCopyConsoleUser`) and in such case it will remain running even when desired host becomes active. This is to mitigate situation that *macOS* switches back (2nd time) to built-in radio after the reboot, as that was observed on my computer. However, it will quit once someone is logged in and desired host is active.

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
