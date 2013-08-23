//
//  KPAppDelegate.h
//  Paper Clip
//
//  Created by Kristian Pennacchia on 9/08/13.
//  Copyright (c) 2013 Kristian Pennacchia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@class KPTableViewController;

@interface KPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) KPTableViewController *viewController;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) NSMutableArray *articles;
@property (nonatomic) BOOL isReachable;

- (NSString *)stringFromStatus:(NetworkStatus)status;
- (void)reachabilityChanged:(NSNotification *)notification;

@end
