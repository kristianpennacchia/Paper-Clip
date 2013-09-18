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
#import "KPRSSViewController.h"

@implementation KPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    // The feeds.plist file needs to be created if it does not already exist
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self feedsPlistPath]]) {
        // it does not exist, create plist and give it the default RSS Feeds
        NSMutableDictionary *defaultFeeds = [[NSMutableDictionary alloc] init];
        [defaultFeeds setObject:@"http://www.theverge.com/rss/index.xml" forKey:@"The Verge"];
        [defaultFeeds setObject:@"http://www.polygon.com/rss/index.xml" forKey:@"Polygon"];
        [defaultFeeds setObject:@"http://9to5mac.com/feed/" forKey:@"9to5Mac"];
        
        [defaultFeeds writeToFile:[self feedsPlistPath] atomically:YES];
    }
    
    self.rssFeeds = [[NSMutableDictionary alloc] initWithContentsOfFile:[self feedsPlistPath]];
    self.articles = [[NSMutableArray alloc] init];
    
    self.rssViewController = [[KPRSSViewController alloc] initWithNibName:@"KPRSSViewController" bundle:nil];
    //self.viewController = [[KPTableViewController alloc] initWithNibName:@"KPTableViewController" bundle:nil];
    
    // Sets the default view to be displayed when the app launches
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.rssViewController];
    self.window.rootViewController = self.navController;
    
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
    
    bgDate = [NSDate date];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // If the app has been in the background for over 2 hours we will
    // automatically refresh the article list.
    
    // Get the current date and time
    bgDate = [NSDate date];
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
    
    // Compare the current date and time with the previous date and time that
    // was recorded when we resigned being active. If the time difference
    // is long enough, refresh the article list (RSS feed through API).
    int minutesToRefresh = 120;
    
    // Convert the interval from seconds to minutes using floor() for ease-of-use
    int timeDifference = floor([[NSDate date] timeIntervalSinceDate:bgDate] / 60);

    if (timeDifference >= minutesToRefresh) {
        [self.viewController refresh];
    }
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

- (NSString *)feedsPlistPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"feeds.plist"];
    return plistPath;
}

- (BOOL)writeFeedsToPlist
{
    return [self.rssFeeds writeToFile:[self feedsPlistPath] atomically:YES];
}

@end
