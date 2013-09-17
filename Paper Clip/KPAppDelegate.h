//
//  KPAppDelegate.h
//  Paper Clip
//
//  Created by Kristian Pennacchia on 9/08/13.
//  Copyright (c) 2013 Kristian Pennacchia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@class KPRSSViewController;
@class KPTableViewController;

@interface KPAppDelegate : UIResponder <UIApplicationDelegate>
{
    NSDate *bgDate;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) KPRSSViewController *rssViewController;
@property (strong, nonatomic) KPTableViewController *viewController;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) NSMutableArray *articles;
@property (strong, nonatomic) NSMutableDictionary *rssFeeds;
@property (nonatomic) BOOL isReachable;

- (NSString *)stringFromStatus:(NetworkStatus)status;
- (void)reachabilityChanged:(NSNotification *)notification;

@end
