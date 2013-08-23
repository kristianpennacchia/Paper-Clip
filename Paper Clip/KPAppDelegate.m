//
//  KPAppDelegate.m
//  Paper Clip
//
//  Created by Kristian Pennacchia on 9/08/13.
//  Copyright (c) 2013 Kristian Pennacchia. All rights reserved.
//

#import "KPAppDelegate.h"
#import "KPTableViewController.h"
#import "KPArticle.h"
#import "KPArticleRepository.h"

@implementation KPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    self.articles = [[NSMutableArray alloc] init];
    
    self.viewController = [[KPTableViewController alloc] initWithNibName:@"KPTableViewController" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = self.navController;
    
    // NOTE: Should this and it's methods be in KPArticleRepository instead?
    // Register this class as an observer for the kReachabilityChangedNotification event
    [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(reachabilityChanged:)
                                                  name:kReachabilityChangedNotification
                                                object:nil];
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    // Check right now to see if we can access the internet
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == NotReachable)
        self.isReachable = NO;
    else
        self.isReachable = YES;
    
    // Start the event notification
    [reach startNotifier];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSString *)stringFromStatus:(NetworkStatus)status
{
    NSString *string;
    switch (status) {
        case NotReachable:
            string = @"Not Reachable";
            break;
        case ReachableViaWiFi:
            string = @"Reachable via WiFi";
            break;
        case ReachableViaWWAN:
            string = @"Reachable via WWAN";
            break;
        default:
            string = @"Unknown";
            break;
    }
    return string;
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability *reach = [notification object];
    if ([reach isKindOfClass:[Reachability class]]) {
        NetworkStatus status = [reach currentReachabilityStatus];
        NSLog(@"Reachability: %@", [self stringFromStatus:status]);
        
        if (status == NotReachable) {
            self.isReachable = NO;
        }
        else {
            self.isReachable = YES;
            self.viewController.refreshControl.attributedTitle = nil;
            
            // If articles array is empty and the internet is reachable again
            // after not being reachable: Refresh.
            if ([self.articles count] == 0) {
                [self.viewController.tableView setHidden:NO];
                [self.viewController refresh];
            }
        }
    }
}

@end
