cmd-line-notifications: send-notification.m Makefile
	gcc send-notification.m -o send-notification -ObjC -framework Foundation -framework AppKit
