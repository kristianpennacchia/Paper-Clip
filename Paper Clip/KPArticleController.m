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
#import <MobileCoreServices/MobileCoreServices.h>

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
        
        // init this here so the image we last viewed will be displayed
        // straight away when re-opening the gallery
        imageIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Add buttons to the navigation bar
    UIBarButtonItem *nightModeButton = [[UIBarButtonItem alloc] initWithTitle:@"NM"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(toggleNightMode)];
    galleryButton = [[UIBarButtonItem alloc] initWithTitle:@"Gallery"
                                                    style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(gallery:)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                 target:self
                                                                                 action:@selector(share:)];
    NSArray *buttonsArray = [[NSArray alloc] initWithObjects:shareButton,
                                                            galleryButton,
                                                            nightModeButton, nil];
    [self.navigationItem setRightBarButtonItems:buttonsArray];
    
    // Set the default properties
    isNightMode = NO;
    galleryButton.enabled = NO;
    
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
    thisArticle.completeText = [NSString stringByStrippingHTML:thisArticle.completeHTML];
    
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
    
    // Now that the most important data has been loaded (the article text)
    // get the image links from the HTML article
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [detector matchesInString:thisArticle.completeHTML
                                         options:0
                                           range:NSMakeRange(0, [thisArticle.completeHTML length])];
    
    // This array will hold all of the links that are valid images
    imageLinks = [[NSMutableArray alloc] init];
    
    for (NSTextCheckingResult *result in matches) {
        // Convert result to a string
        NSString *s = [[result URL] absoluteString];
        
        // Get the files extensions
        CFStringRef fileExtension = (__bridge CFStringRef)[s pathExtension];
        
        // Get the files uniform type identifier
        CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
        
        // If the link is an image type, add it to the imageLinks array
        if (UTTypeConformsTo(fileUTI, kUTTypeImage)) {
            [imageLinks addObject:s];
        }
    }
    
    if ([imageLinks count] > 0) {
        // Enable the Gallery button
        galleryButton.enabled = YES;
    }
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
    // Get the image link to load in the webview
    NSURL *url = [NSURL URLWithString:[imageLinks objectAtIndex:imageIndex]];
    
    // Load the link in the webview
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    // Create a view controller and add the view to it
    webViewController = [[UIViewController alloc] init];
    [webViewController setView:viewForWebView];
    
    // Create the buttons used in the toolbar at the bottom of the screen
    previous = [[UIBarButtonItem alloc] initWithTitle:@"Previous"
                                                style:UIBarButtonItemStylePlain
                                                target:self
                                                action:@selector(previousImage:)];
    next = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                            style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(nextImage:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:self
                                                                           action:nil];
    
    NSArray *items = [NSArray arrayWithObjects:previous, space, next, nil];
    
    // Add the buttons to the toolbar
    [webViewToolbar setItems:items animated:YES];
    
    // Check if toolbar buttons should be enabled or disabled
    if ([imageLinks count] == 1) {
        // Disable the toolbar buttons
        [webViewToolbar setHidden:YES];
    }
    
    // Disable and enable the navigation buttons based on the image index
    if (imageIndex == 0) {
        [previous setEnabled:NO];
    }
    else if (imageIndex == ([imageLinks count] - 1)) {
        [next setEnabled:NO];
    }
    
    // Display the webview
    [self presentViewController:webViewController animated:YES completion:nil];
}

- (void)doneButton
{
    [webViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)previousImage:(id)sender
{
    // Disable and enable the navigation buttons based on the image index
    if (imageIndex > 0) {
        --imageIndex;
        [next setEnabled:YES];
    }
    if (imageIndex == 0) {
        [previous setEnabled:NO];
    }
    
    NSURL *url = [NSURL URLWithString:[imageLinks objectAtIndex:imageIndex]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)nextImage:(id)sender
{
    // Disable and enable the navigation buttons based on the image index
    if (imageIndex < ([imageLinks count] - 1)) {
        ++imageIndex;
        [previous setEnabled:YES];
    }
    if (imageIndex == ([imageLinks count] - 1)) {
        [next setEnabled:NO];
    }
    
    NSURL *url = [NSURL URLWithString:[imageLinks objectAtIndex:imageIndex]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
