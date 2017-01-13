#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <Cocoa/Cocoa.h>

#pragma mark - Send Notification NSBundle

NSString *fakeBundleIdentifier = nil;

@implementation NSBundle(notification)

- (NSString *)__bundleIdentifier
{
    if (self == [NSBundle mainBundle]) {
        return fakeBundleIdentifier ? fakeBundleIdentifier : @"com.send-notification";
    } else {
        return [self __bundleIdentifier];
    }
}

@end

BOOL installNSBundleHook()
{
    Class class = objc_getClass("NSBundle");
    if (class) {
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(bundleIdentifier)),
                                       class_getInstanceMethod(class, @selector(__bundleIdentifier)));
        return YES;
    }
    return NO;
}

#pragma mark - NotificationCenterDelegate

@interface NotificationCenterDelegate : NSObject<NSUserNotificationCenterDelegate>

@property (nonatomic, assign) BOOL notificationNotSent;

@end

@implementation NotificationCenterDelegate

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification
{
    self.notificationNotSent = NO;
}

@end

#pragma mark -

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        if (installNSBundleHook()) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            fakeBundleIdentifier = [defaults stringForKey:@"i"];
            
            NSUserNotificationCenter *notificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
            NotificationCenterDelegate *notificationCenterDelegate = [[NotificationCenterDelegate alloc]init];
            notificationCenterDelegate.notificationNotSent = YES;
            notificationCenter.delegate = notificationCenterDelegate;
            
            NSUserNotification *notification = [[NSUserNotification alloc] init];
            notification.title = [defaults stringForKey:@"t"];
            notification.subtitle = [defaults stringForKey:@"s"];
            notification.informativeText = [defaults stringForKey:@"m"];
            notification.hasActionButton = YES;
            
            [notification setValue:@YES forKey:@"_ignoresDoNotDisturb"];
            
            NSImage *notificationImage = [[NSImage alloc] initWithContentsOfFile:[defaults stringForKey:@"p"]];
            
            if (notificationImage != nil) {
                [notification setValue:notificationImage forKey:@"_identityImage"];
                [notification setValue:@NO forKey:@"_identityImageHasBorder"];
            }
            
            if (!(notification.title || notification.informativeText)) {
                printf("\nUsage: ./send-notification\n");
                printf("Options: [-t <TEXT>] [-s TEXT] [-m TEXT] [-p TEXT]\n");
                printf("-t Title\n");
                printf("-s Subtitle\n");
                printf("-m Main message\n");
                printf("-p Path to a icon you want to use for the notification, if not set Terminal icon will be used.\n");
                printf("-t or -m is required\n");
                printf("Example:\n");
                printf("./send-notification -t 'Example Notification' -s 'Subtitle Notification' -m 'Main Message'\n");
                printf("-----------------------------------\n");
                printf("|                                 |\n");
                printf("| Example Notification            |\n");
                printf("| Subtitle Notification           |\n");
                printf("| Main Message                    |\n");
                printf("|                                 |\n");
                printf("-----------------------------------\n");
                printf("\n");
            }
            else
            {
                
                [notificationCenter deliverNotification:notification];
                
                while (notificationCenterDelegate.notificationNotSent) {
                    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
                }
            }
            
        }
    }
    return 0;
}


