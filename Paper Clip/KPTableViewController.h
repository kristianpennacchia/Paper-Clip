//
//  KPTableViewController.h
//  Paper Clip
//
//  Created by Kristian Pennacchia on 12/08/13.
//  Copyright (c) 2013 Kristian Pennacchia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KPTableViewController : UITableViewController <UITableViewDataSource,
                                                        UITableViewDelegate>
{
    NSString *key;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *bgLabel;

- (id)initWithKey:(NSObject *)keyString;
- (void)refresh;

@end
