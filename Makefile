CFLAGS  += -Wall
LDFLAGS += -framework Foundation -framework IOBluetooth -framework SystemConfiguration

LDPLIST := /Library/LaunchDaemons/com.nanoant.blueswitch.plist
BIN     := /usr/local/bin

all: $(BIN)/blueswitch $(LDPLIST)

$(LDPLIST): com.nanoant.blueswitch.plist
	sudo cp $< $@
	sudo launchctl unload -w $@
	sudo launchctl load -w $@

$(BIN)/blueswitch: blueswitch
	sudo install $< $@

blueswitch: blueswitch.m
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

reload: $(LDPLIST)
	sudo launchctl unload -w $<
	sudo launchctl load -w $<
