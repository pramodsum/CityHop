//
//  ItineraryTableViewController.m
//  CityHop
//
//  Created by Adam Oxner on 3/16/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "ItineraryTableViewController.h"
#import "AppDelegate.h"
#import "ItineraryMasterCell.h"
#import "POISuggestionCell.h"
#import "SDWebImage/UIImageView+WebCache.h"


@interface ItineraryTableViewController ()

@end

@implementation ItineraryTableViewController{
    AppDelegate *appDelegate;
}

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
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-66, 0, 0, 0)];
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [appDelegate.tripManager getDestinations].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        // master cell
        
        ItineraryMasterCell *cell1 = [self.tableView dequeueReusableCellWithIdentifier:@"itinMasterCell"];
        if (cell1 == nil) {
            cell1 = [[ItineraryMasterCell alloc] init];
        }
        
        [cell1.cityLabel setText:((DestinationObject *)[[appDelegate.tripManager getDestinations] objectAtIndex:indexPath.section]).name];
        [cell1.activitiesLabel setText:[NSString stringWithFormat:@"%lu activities planned.", (unsigned long)((DestinationObject *)[[appDelegate.tripManager getDestinations] objectAtIndex:indexPath.section]).selected_activities.count]];
        
        cell = cell1;
    }else{
        // child cell
        
        POISuggestionCell *cell2 = [self.tableView dequeueReusableCellWithIdentifier:@"POICell"];
        if (cell2 == nil) {
            cell2 = [[POISuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"POICell"];
        }
        
        POIObject *poi = (POIObject *)[((DestinationObject *)[[appDelegate.tripManager getDestinations] objectAtIndex:indexPath.section]) venueAtIndex:indexPath.row-1];
        [cell2.activityName setText:[poi name]];
        [cell2.activityAddress setText:[poi address]];
        [cell2.activityRating setText:[[poi rating] stringValue]];
        [cell2 setAccessoryType:UITableViewCellAccessoryNone];
        [cell2.activityImage setImageWithURL:[NSURL URLWithString:[poi imageURL]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
        
        cell = cell2;
    }
    
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
