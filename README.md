#terminal-send-notification
A little utility to send notification to the Mac Notification Center from the terminal

```bash
./send-notification -t 'Example Notification' -s 'Subtitle Notification' -m 'Main Message'
```

![alt text](https://raw.githubusercontent.com/jonathansm/terminal-send-notification/master/example-images/notification-no-logo.png "Notification without logo")

```bash
./send-notification -t 'Example Notification' -s 'Subtitle Notification' -m 'Main Message' -p ~/Desktop/logo.png
```
![alt text](https://raw.githubusercontent.com/jonathansm/terminal-send-notification/master/example-images/notification-logo.png "Notification with logo")



##Help
```bash
Usage: ./send-notification
Options: [-t <TEXT>] [-s TEXT] [-m TEXT] [-p TEXT]
-t Title
-s Subtitle
-m Main message
-p Path to a icon you want to use for the notification, if not set Terminal icon will be used.
-t or -m is required
Example:
./send-notification -t 'Example Notification' -s 'Subtitle Notification' -m 'Main Message'
-----------------------------------\n
|                                 |\n
| Example Notification            |\n
| Subtitle Notification           |\n
| Main Message                    |\n
|                                 |\n
-----------------------------------\n
```

###Future
I would like to update this so that you can specify actions for the notification
