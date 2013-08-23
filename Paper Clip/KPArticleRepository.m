//
//  KPArticleRepository.m
//  Paper Clip
//
//  Created by Kristian Pennacchia on 9/08/13.
//  Copyright (c) 2013 Kristian Pennacchia. All rights reserved.
//

#import "KPArticleRepository.h"
#import "KPArticle.h"
#import "KPAppDelegate.h"
#import "KPTableViewController.h"
#import "KPArticleController.h"

#define kLoadCommandAPI @"https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q="
#define kArticlesToLoad @"&num=-1"  // -1 grabs the maximum amount. Change this to 25, then as the user
                                    // scrolls down the articles list, load the next 25 when they
                                    // get close to the bottom of the list
#define kParserAPI @"https://www.readability.com/api/content/v1/parser?url="
#define kParserAPIKey @"&token=a6a001e1120091c88c8aaa62b824154ee8954907"

// Google Feed (load) API: https://developers.google.com/feed/v1/jsondevguide#json_reference
// Readability Parser API: http://www.readability.com/developers/api/parser

@implementation KPArticleRepository

- (void)fetchArticlesWithParent:(UITableViewController *)controller fromURL:(NSString *)urlString
{
    viewController = (KPTableViewController *)controller;
    KPAppDelegate *delegate = (KPAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *fullURLString = [NSString stringWithFormat:@"%@%@%@",
                           kLoadCommandAPI, urlString, kArticlesToLoad];
    NSURL *url = [NSURL URLWithString:fullURLString];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    // Returned data is handled in completionHandler:
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (data && [data length] > 0) {
                                   // TODO: Temporarily change the No Articles text to Loading (w/ indicator next to it)
                                   id JSONArticles = [NSJSONSerialization JSONObjectWithData:data
                                                                                     options:0
                                                                                       error:nil];
                                   
                                   // Data is nested such that: responseData > feed > title, content, etc.
                                   // Loop through the array of entries (articles)
                                   int i = 0;
                                   for (id entry in [JSONArticles valueForKeyPath:@"responseData.feed.entries"]) {
                                       // Create KPArticle object with the data from 'entry'
                                       KPArticle *article = [[KPArticle alloc] initWithDictionary:entry];
                                       
                                       // Check if article already exists in array
                                       // If it does not already exist in array, add.
                                       // Else do not add (do nothing).
                                       BOOL doesExist = NO;
                                       if (article != nil) {
                                           for (KPArticle *temp in delegate.articles) {
                                               if ([temp.title compare:article.title] == NSOrderedSame) {
                                                   doesExist = YES;
                                                   break;
                                               }
                                           }
                                           if (doesExist == NO) {
                                               // Does not exist in array already.
                                               // Insert into the beginning of the array.
                                               // The i variable is used to make sure the newly retrieved
                                               // but older dated articles are added after the newer
                                               // dated articles.
                                               [delegate.articles insertObject:article atIndex:i];
                                               ++i;
                                           }
                                       }
                                   }
                                   // Asynchronously refresh the tableView (async so the app doesnt freeze)
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [viewController.tableView reloadData];
                                   });
                                   
                                   // TODO: If on WiFI, start preloading all of the article text.
                                   // If not on WiFi, only load article text on demand (i.e. when use clicks on article).
                               }
                               else {
                                   // Do nothing?
                                   // If there are no articles, let the user know by changing the
                                   // text on the bgLabel and showing it (hide the tableView)
                               }
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                               [viewController.refreshControl endRefreshing];
                           }];
}

- (void)fetchArticleContentWithParent:(KPArticleController *)controller forArticle:(KPArticle *)article atIndex:(int)index
{
    // Check if article is already loaded
    if (!article.isArticleLoaded) {
        
        // Start loading the article here (this is "on demand")
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        // Display the loading indicator
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]
                                                 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.center = controller.view.center;
        [activityView startAnimating];
        [controller.view addSubview:activityView];
        
        // Use readability API to parse and return content from article for us
        NSString *urlString = [NSString stringWithFormat:@"%@%@%@",
                               kParserAPI,
                               article.link,
                               kParserAPIKey];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
        
        // Returned data is handled in completionHandler:
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if (data && [data length] > 0) {
                                       id JSONArticle = [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:0
                                                                                          error:nil];
                                       // Add content to correct 'article' based on indexPath.row
                                       KPAppDelegate *delegate = (KPAppDelegate *)[[UIApplication sharedApplication] delegate];
                                       [[delegate.articles objectAtIndex:index]
                                        setCompleteText:[JSONArticle objectForKey:@"content"]];
                                       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                       [activityView stopAnimating];
                                       
                                       // Set isArticleLoaded in article to TRUE so we don't redownload the article
                                       // everytime we go to view it
                                       article.isArticleLoaded = YES;
                                       
                                       // Tell the KPArticleController it needs to be refreshed (reassign the text)
                                       [controller refresh];
                                   }
                                   else {
                                       // ELSE; let the user know the article could not be loaded, or continuously retry...
                                   }
                               }];
    }
}

@end
