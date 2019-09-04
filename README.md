blueswitch
==========

## Disclaimer

[macforums]: https://forums.macrumors.com/threads/mac-mini-2018-bluetooth-issues.2157086/page-17#post-27685411

This project is now obsolete, as it was intended to solve *Mac Mini* 2018 Bluetooth problem. But I finally found the reliable way to disable built-in Bluetooth radio via undocumented NVRAM setting:
~~~
sudo nvram SkipIOBluetoothHostControllerUARTTransport=%01
~~~
So external USB Bluetooth dongle can be used instead for HID devices such as Magic Keyboard or Mouse.

Full solution can be found [here at MacForums][macforums].

Still I leave the project for learning / research purposes. Pull it, and check the history if you are interested what I tried to do.
