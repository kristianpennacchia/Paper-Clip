//
//  KPAddRSSController.h
//  Paper Clip
//
//  Created by Kristian Pennacchia on 1/10/13.
//  Copyright (c) 2013 Kristian Pennacchia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KPAddRSSController : UIViewController
{
    NSString *title;
    NSString *feed;
}

@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UITextField *feedField;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;

- (void)save:(id)sender;
- (void)cancel:(id)sender;

@end
