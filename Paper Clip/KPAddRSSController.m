//
//  KPAddRSSController.m
//  Paper Clip
//
//  Created by Kristian Pennacchia on 1/10/13.
//  Copyright (c) 2013 Kristian Pennacchia. All rights reserved.
//

#import "KPAddRSSController.h"
#import "KPAppDelegate.h"
#import "KPArticleRepository.h"

@interface KPAddRSSController ()

@end

@implementation KPAddRSSController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Add the title
    self.title = @"Add Feed";
    
    // Add done button
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                target:self
                                                                                action:@selector(save:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                target:self
                                                                                action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)save:(id)sender
{
    title = [self.titleField text];
    feed = [self.feedField text];
    
    // Check if feed is valid
    KPArticleRepository *repository = [[KPArticleRepository alloc] init];
    BOOL isValid = [repository validateRSS:feed];
    
    // If valid, add to NSDictionary and dismiss
    if (isValid) {
        // Add to the dictionary
        KPAppDelegate *delegate = (KPAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.rssFeeds setObject:feed forKey:title];
        
        // Write to feeds.plist
        [delegate writeFeedsToPlist];
        
        // Dismiss
        [self.errorLabel setHidden:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        // Not valid
        // Tell user (through label with red coloured text). Don't dismiss
        [self.errorLabel setHidden:NO];
    }
}

- (void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
