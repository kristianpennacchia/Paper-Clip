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
    UISlider *slider;
}

- (id)initWithIndexPath:(NSIndexPath *)indexPath;
- (void)refresh;
- (void)brightnessSlider:(id)sender;
- (void)sliderDismiss:(id)sender;
- (void)sliderAction:(id)sender;
- (void)toggleNightMode;
- (void)share:(id)sender;

@end
