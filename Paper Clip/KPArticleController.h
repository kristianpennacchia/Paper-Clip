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
    int imageIndex;
    BOOL isNightMode;
    UIBarButtonItem *galleryButton;
    UIBarButtonItem *previous;
    UIBarButtonItem *next;
    
    NSMutableArray *imageLinks;
    
    UIViewController *webViewController;
    IBOutlet UITextView *articleView;
    IBOutlet UIView *viewForWebView;
    IBOutlet UIWebView *webView;
    IBOutlet UIToolbar *webViewToolbar;
}

- (IBAction)doneButton;

- (id)initWithIndexPath:(NSIndexPath *)indexPath;
- (void)refresh;
- (void)toggleNightMode;
- (void)share:(id)sender;
- (void)gallery:(id)sender;
- (void)previousImage:(id)sender;
- (void)nextImage:(id)sender;

@end
