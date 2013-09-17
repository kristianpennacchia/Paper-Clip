//
//  KPTableViewController.m
//  Paper Clip
//
//  Created by Kristian Pennacchia on 12/08/13.
//  Copyright (c) 2013 Kristian Pennacchia. All rights reserved.
//

#import "KPTableViewController.h"
#import "KPAppDelegate.h"
#import "KPArticle.h"
#import "KPArticleController.h"
#import "KPArticleRepository.h"

@interface KPTableViewController ()

@end

@implementation KPTableViewController

NSString *keyLastLoaded;

- (id)initWithKey:(NSString *)keyString
{
    if ((self = [super init])) {
        key = keyString;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    KPAppDelegate *delegate = (KPAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.bgView.backgroundColor = [UIColor whiteColor];
    [delegate.navController.view addSubview:self.bgView];  // Used for the empty state
    [delegate.navController.view sendSubviewToBack:self.bgView];
    
    // Setup the UIRefreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
        
    KPArticleRepository *repository = [[KPArticleRepository alloc] init];
    
    // Check for reachability
    if (delegate.isReachable) {
        // If it's a different RSS feed compared to what was last loaded,
        // erase the array
        if (![key isEqualToString:keyLastLoaded]) {
            [delegate.articles removeAllObjects];
        }
        
        NSString *rss = [delegate.rssFeeds valueForKey:key];
        [repository fetchArticlesWithParent:self fromURL:rss];
        keyLastLoaded = key;
    }
    else {
        // Not reachable
        if ([delegate.articles count] == 0 || ![key isEqualToString:keyLastLoaded]) {
            /* When viewing the articles list */
            // If the articles array is empty or we are trying to view a
            // different rss feed: Hide the UITableView and show
            // an empty state
            self.bgLabel.text = @"No Internet Connection";
            self.tableView.hidden = YES;
        }
    }
    // Set the navigation bar title to be the website's name
    self.title = key;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    // If not reachable, immediately stop the refreshing animation and let the
    // user know that there is no internet connection.
    KPAppDelegate *delegate = (KPAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.isReachable) {
        KPArticleRepository *repository = [[KPArticleRepository alloc] init];
        NSString *rss = [delegate.rssFeeds valueForKey:key];
        [repository fetchArticlesWithParent:self fromURL:rss];
    }
    else {
        [self.refreshControl endRefreshing];
        
        // Only display the refreshControl's label if there are articles loaded.
        // If there are NO articles loaded, then there will be a label in the
        // middle of the screen saying "No Internet Connection". No need to have
        // two labels doing the same thing.
        if ([delegate.articles count] > 0) {
            // Let the user know that there is no internet connection
            UIColor *color = [[UIColor alloc] initWithCGColor:[UIColor redColor].CGColor];
            NSDictionary *attributes = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
            NSAttributedString *as = [[NSAttributedString alloc] initWithString:@"No Internet Connection" attributes:attributes];
            [self.refreshControl setAttributedTitle:as];
        }
    }
}

#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    KPAppDelegate *delegate = (KPAppDelegate *)[[UIApplication sharedApplication] delegate];
    KPArticle *article = [delegate.articles objectAtIndex:indexPath.row];
    
    // Add the title
    cell.textLabel.text = article.title;
    cell.textLabel.font = [UIFont fontWithName:@"Palatino" size:16];
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    cell.textLabel.numberOfLines = 1;
    
    // Add the date and preview text
    NSMutableString *detailText = [[NSMutableString alloc] initWithFormat:@"%@\n%@",
                                   article.date,
                                   article.previewText];
    cell.detailTextLabel.text = detailText;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Palatino" size:12];
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 3;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    KPAppDelegate *delegate = (KPAppDelegate *)[[UIApplication sharedApplication] delegate];
    return [delegate.articles count];
}

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KPAppDelegate *delegate = (KPAppDelegate *)[[UIApplication sharedApplication] delegate];
    KPArticleController *articleController = [[KPArticleController alloc] initWithIndexPath:indexPath];
    KPArticle *article = [delegate.articles objectAtIndex:indexPath.row];
    
    // Grab the article contents here so 1) it starts downloading ASAP
    // and 2) so we don't have to grab the delegate again.
    if (delegate.isReachable) {
        KPArticleRepository *repository = [[KPArticleRepository alloc] init];
        [repository fetchArticleContentWithParent:articleController forArticle:article atIndex:indexPath.row];
    }
    
    [delegate.navController pushViewController:articleController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
