//
//  KPArticleController.h
//  Paper Clip
//
//  Created by Kristian Pennacchia on 9/08/13.
//  Copyright (c) 2013 Kristian Pennacchia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KPArticleController : UIViewController
{
    NSIndexPath *index;
    BOOL isNightMode;
    
    IBOutlet UITextView *articleView;
}

- (id)initWithIndexPath:(NSIndexPath *)indexPath;
- (void)refresh;
- (void)toggleNightMode;
- (void)share:(id)sender;
- (void)gallery:(id)sender;

@end
