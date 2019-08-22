//
// blueswitch Copyright (c) 2019 Adam Strzelecki
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import <IOBluetooth/IOBluetooth.h>
#import <SystemConfiguration/SystemConfiguration.h>

int IOBluetoothLocalDeviceGetUSBProductID(int loc);
void BluetoothHCISwitchToSelectedHostController(int loc);

NSString *getConsoleUser() {
	return CFBridgingRelease(SCDynamicStoreCopyConsoleUser(NULL, NULL, NULL));
}

int main(int argc, char const *argv[])
{ @autoreleasepool {
	if (argc < 3) {
		NSLog(@"%s location mac", argv[0]);
		return 0;
	}
	int loc = strtol(argv[1], NULL, 16);
	NSString *addr = [[NSString stringWithCString:argv[2] encoding:NSUTF8StringEncoding] lowercaseString];
	NSLog(@"Switching to location: %x waiting for address: %@", loc, addr);

	while(TRUE) { @autoreleasepool {
		IOBluetoothHostController *host = [IOBluetoothHostController defaultController];
		if (host) {
			NSString *hostAddr = [host addressAsString];
			if ([hostAddr isEqualToString:addr]) {
				NSString *currentUser = getConsoleUser();
				if (currentUser && [currentUser length]) {
					NSLog(@"Host is found and user: %@ logged in. Exiting.", currentUser);
					break;
				} else {
					// NSLog(@"Host is found, but no user logged. Waiting.");
				}
			} else {
				NSLog(@"Current host has address: %@", hostAddr);
			}
		} else {
			NSLog(@"No host found.");
		}
		BluetoothHCISwitchToSelectedHostController(loc);
		[NSThread sleepForTimeInterval:1];
	} }

	return 0;
} }
