//
//  ActivitiesViewController.m
//  RouteMe1
//
//  Created by Adam Oxner on 3/2/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "ActivitiesViewController.h"
#import "ActivityObject.h"

@interface ActivitiesViewController ()

@end

@implementation ActivitiesViewController{
    NSMutableArray *activitySuggestions; // array for populating table
}

@synthesize index = _index;
@synthesize destinations = _destinations;

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
    
    [self hideSearchBar];
    
    // initialize data
    if (activitySuggestions == nil) {
        activitySuggestions = [[NSMutableArray alloc] init];
    }
    
    
    [self.navigationItem setTitle:((DestinationObject *)[_destinations objectAtIndex:_index.intValue]).name];
    
    if (_index.intValue < [_destinations count]-1) {
        // button for next city
        
        UIBarButtonItem *nextCityBtn =
        [[UIBarButtonItem alloc]
            initWithTitle:((DestinationObject *)[_destinations objectAtIndex:_index.intValue+1]).name
            style:UIBarButtonItemStylePlain
            target:self
            action:@selector(nextCity:)];
        
        
        [self.navigationItem setRightBarButtonItem:nextCityBtn];
        
    }else{
        // button for trip options
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideSearchBar{
    CGPoint offset = CGPointMake(0, self.searchBar.frame.size.height);
    self.tableView.contentOffset = offset;
}

- (void) nextCity:(id)sender
{
    [self performSegueWithIdentifier:@"next_city_segue" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (activitySuggestions == nil) {
        return 0;
    }
    
    return [activitySuggestions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [cell.textLabel setText:[(ActivityObject *)[activitySuggestions objectAtIndex:indexPath.row] name]];
    
    return cell;
}

#pragma mark - Navigation


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"next_city_segue"]) {
        ActivitiesViewController *vc = (ActivitiesViewController *)[segue destinationViewController];
        [vc setDestinations:_destinations];
        [vc setIndex:[NSNumber numberWithInt:_index.intValue+1]];
    }
}



@end
