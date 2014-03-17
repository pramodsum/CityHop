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
    NSMutableDictionary *expandedSections;
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
    expandedSections = [[NSMutableDictionary alloc] init];
    
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
    // Return the number of rows in the section.
    NSString *key = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)section]];
    NSNumber *isExpanded = [expandedSections valueForKey:key];
    
    // check if expanded
    if (isExpanded == nil || isExpanded.intValue == 0) {
        // not expanded
        return 1;
    }else{
        // expanded
        return [((DestinationObject *)[[appDelegate.tripManager getDestinations] objectAtIndex:section]) selected_activities].count +1;
    }
    
    
    return -1;
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
        
        POISuggestionCell *cell2 = [self.tableView dequeueReusableCellWithIdentifier:@"POICell1"];
        if (cell2 == nil) {
            NSLog(@"building child cell");
            cell2 = [[POISuggestionCell alloc] init];
        }
        
        POIObject *poi = (POIObject *)[[((DestinationObject *)[[appDelegate.tripManager getDestinations] objectAtIndex:indexPath.section]) selected_activities] objectAtIndex:indexPath.row-1];
        [cell2.activityName setText:[poi name]];
        [cell2.activityAddress setText:[poi address]];
        [cell2.activityRating setText:[[poi rating] stringValue]];
        [cell2 setAccessoryType:UITableViewCellAccessoryNone];
        [cell2.activityImage setImageWithURL:[NSURL URLWithString:[poi imageURL]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
        
        cell = cell2;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        // expand/collapse
        [self.tableView beginUpdates];
        
        NSString *key = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)indexPath.section]];
        NSNumber *isExpanded = [expandedSections valueForKey:key];
        
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        for (int i=0; i<[((DestinationObject *)[[appDelegate.tripManager getDestinations] objectAtIndex:indexPath.section]) selected_activities].count; ++i) {
            [tmpArray addObject:[NSIndexPath indexPathForRow:i+1 inSection:indexPath.section]];
        }
        
        // check if expanded
        if (isExpanded == nil || isExpanded.intValue == 0) {
            // not expanded; expand
            ItineraryMasterCell *cell = (ItineraryMasterCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell.expandCollapseLabel setText:@"^"];
            
            [expandedSections setValue:[NSNumber numberWithInt:1] forKey:key];
            [self.tableView insertRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            // expanded; collapse
            ItineraryMasterCell *cell = (ItineraryMasterCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell.expandCollapseLabel setText:@"v"];
            
            [expandedSections setValue:[NSNumber numberWithInt:0] forKey:key];
            [self.tableView deleteRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        [self.tableView endUpdates];
    }
    
    [self.tableView reloadData];
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
