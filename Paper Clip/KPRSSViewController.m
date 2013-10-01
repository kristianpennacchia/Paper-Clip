//
//  KPRSSViewController.m
//  Paper Clip
//
//  Created by Kristian Pennacchia on 16/09/13.
//  Copyright (c) 2013 Kristian Pennacchia. All rights reserved.
//

#import "KPRSSViewController.h"
#import "KPAppDelegate.h"
#import "KPTableViewController.h"
#import "KPAddRSSController.h"

@interface KPRSSViewController ()

@end

@implementation KPRSSViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Paper Clip";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(addFeed:)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // Dispose of the NSDictionary (rssFeeds)
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    KPAppDelegate *delegate = (KPAppDelegate *)[[UIApplication sharedApplication] delegate];
    return [delegate.rssFeeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    // Put all keys into an array so we can access the correct value (rss feed)
    // for the current row (cell)
    KPAppDelegate *delegate = (KPAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *keys = [delegate.rssFeeds allKeys];
    
    // Get the site name (key)
    NSString *site = [keys objectAtIndex:indexPath.row];
    
    // Use the site name as the text for the cell
    cell.textLabel.text = site;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Remove it from the NSDictionary
        KPAppDelegate *delegate = (KPAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.rssFeeds removeObjectForKey:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // Write the NSDictionary to feeds.plist (overwrite the file)
        [delegate writeFeedsToPlist];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
        // Write the NSDictionary to feeds.plist (overwrite the file)
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     KPTableViewController *detailViewController = [[KPTableViewController alloc] initWithNibName:@"KPTableViewController" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    
    
    
    KPAppDelegate *delegate = (KPAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Get the NSDictionary key to be passed to the KPTableViewController
    NSArray *keys = [delegate.rssFeeds allKeys];
    NSString *key = [keys objectAtIndex:indexPath.row];
    
    KPTableViewController *tableViewController = [[KPTableViewController alloc] initWithKey:key];
    [delegate.navController pushViewController:tableViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)addFeed:(id)sender
{
    KPAddRSSController *addRSS = [[KPAddRSSController alloc] init];
    
    KPAppDelegate *delegate = (KPAppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addRSS];
    [delegate.navController presentViewController:nav animated:YES completion:nil];
}

@end
