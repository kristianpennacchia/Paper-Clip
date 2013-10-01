//
//  KPArticleController.m
//  Paper Clip
//
//  Created by Kristian Pennacchia on 9/08/13.
//  Copyright (c) 2013 Kristian Pennacchia. All rights reserved.
//

#import "KPArticleController.h"
#import "KPAppDelegate.h"
#import "KPArticle.h"
#import "NSString+KPStringHTMLHandling.h"

@interface KPArticleController ()

@end

@implementation KPArticleController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithIndexPath:(NSIndexPath *)indexPath
{
    if ((self = [super init])) {
        index = indexPath;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Add buttons to the navigation bar
    UIBarButtonItem *brightnessButton = [[UIBarButtonItem alloc] initWithTitle:@"BR"
                                                                        style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(brightnessSlider:)];
    UIBarButtonItem *nightModeButton = [[UIBarButtonItem alloc] initWithTitle:@"NM"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(toggleNightMode)];
    UIBarButtonItem *galleryButton = [[UIBarButtonItem alloc] initWithTitle:@"Gallery"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                     action:@selector(gallery:)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                 target:self
                                                                                 action:@selector(share:)];
    NSArray *buttonsArray = [[NSArray alloc] initWithObjects:shareButton,
                                                            galleryButton,
                                                            nightModeButton,
                                                            brightnessButton, nil];
    [self.navigationItem setRightBarButtonItems:buttonsArray];
    
    // Set the default properties
    isNightMode = NO;
    
    // Load the content
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    KPAppDelegate *delegate = (KPAppDelegate *)[[UIApplication sharedApplication] delegate];
    KPArticle *thisArticle = [delegate.articles objectAtIndex:index.row];
    
    //self.title = thisArticle.title;
    
    // Strip all of the HTML elements from the text
    thisArticle.completeText = [NSString stringByStrippingHTML:thisArticle.completeText];
    
    NSMutableString *mutableString =
        [[NSMutableString alloc] initWithFormat:@"%@\nby %@\n%@%@\n\n%@",
                                          thisArticle.title,
                                          thisArticle.author,
                                          thisArticle.date, thisArticle.time,
                                          thisArticle.completeText];
    
    articleView.text = mutableString;
    
    if (delegate.isReachable == NO && thisArticle.isArticleLoaded == NO) {
        [mutableString setString:@"No Internet Connection"];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"No Internet Connection";
        label.center = delegate.window.center;
        
        [self.view addSubview:label];
        [self.view bringSubviewToFront:label];
        
        [articleView setHidden:YES];
    }
    
    articleView.text = mutableString;
}

- (void)brightnessSlider:(id)sender
{
    int x = (self.view.bounds.size.width / 2) - (slider.bounds.size.width / 2);
    int y = 10;
    int w = 150;
    int h = 35;
    slider = [[UISlider alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    
    int min = 0.0;
    int max = 1.0;
    [slider setMinimumValue:min];
    [slider setMaximumValue:max];
    slider.value = [[UIScreen mainScreen] brightness];
    slider.backgroundColor = [UIColor lightGrayColor];
    
    slider.continuous = YES;
    
    // Add a gesture reognizer to the article controller view and navbar
    // that detects a tap. When a tap is detected, remove the slider view.
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(sliderDismiss:)];
    [self.view addSubview:slider];
    [self.view addGestureRecognizer:recognizer];
}

- (void)sliderDismiss:(id)sender
{
    [slider removeFromSuperview];
    [self.view removeGestureRecognizer:sender];
}

- (void)sliderAction:(id)sender
{
    [[UIScreen mainScreen] setBrightness:slider.value];
}

- (void)toggleNightMode
{
    // Animate with a fade-in transition (use animation blocks?)
    if (isNightMode == YES) {
        articleView.backgroundColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor whiteColor];
        articleView.textColor = [UIColor blackColor];
        isNightMode = NO;
    }
    else {
        articleView.backgroundColor = [UIColor blackColor];
        self.view.backgroundColor = [UIColor blackColor];
        articleView.textColor = [UIColor whiteColor];
        isNightMode = YES;
    }
}

- (void)share:(id)sender
{
    KPAppDelegate *delegate = (KPAppDelegate *)[[UIApplication sharedApplication] delegate];
    KPArticle *thisArticle = [delegate.articles objectAtIndex:index.row];

    NSArray *activityItems = [[NSArray alloc] initWithObjects:
                              [NSURL URLWithString:thisArticle.link], nil];
    
    UIActivityViewController *activityController =
                        [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                          applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (void)gallery:(id)sender
{
    
}

@end
