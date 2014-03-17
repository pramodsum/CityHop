//
//  POISuggestionViewController.m
//  RouteMe1
//
//  Created by Sumedha Pramod on 3/12/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "POISuggestionViewController.h"
#import "POISuggestion.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "POIDetailCell.h"

@interface POISuggestionViewController ()

@end

@implementation POISuggestionViewController {
    NSArray *activitySuggestions; // array for populating table
    NSMutableArray* filteredTableData;
    TripManager *tripManager;
    DestinationObject *destination;
    BOOL isFiltered;
    NSMutableDictionary *expandedSections;
}

@synthesize index = _index;
@synthesize destinations = _destinations;
@synthesize appDelegate = _appDelegate;
@synthesize searchBar = _searchBar;

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
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    tripManager = _appDelegate.tripManager;
    isFiltered = FALSE;

    // init destination
    destination = (DestinationObject *)[_destinations objectAtIndex:_index.intValue];
    expandedSections = [[NSMutableDictionary alloc] init];

    // initialize data
    if (activitySuggestions == nil) {
        activitySuggestions = [[NSMutableArray alloc] init];
    }
    activitySuggestions = [destination getActivities];

    [self.navigationItem setTitle:destination.name];

    self.tableView.scrollEnabled = YES;

    if (_index.intValue < [_destinations count]-1) {
        // button for next city

        UIBarButtonItem *nextCityBtn =
        [[UIBarButtonItem alloc]
         initWithTitle:@"Next"
         style:UIBarButtonItemStylePlain
         target:self
         action:@selector(nextCity:)];


        [self.navigationItem setRightBarButtonItem:nextCityBtn];

    }else{
        // button for itinerary
        
        UIBarButtonItem *itineraryBtn = [[UIBarButtonItem alloc]
                                         initWithTitle:@"Done"
                                         style:UIBarButtonItemStyleDone
                                         target:self
                                         action:@selector(segueToItinerary)];
        [self.navigationItem setRightBarButtonItem:itineraryBtn];
        
        UIBarButtonItem *citiesBack = [[UIBarButtonItem alloc] initWithTitle:@"Activities" style:UIBarButtonItemStylePlain target:self action:nil];
        [self.navigationItem setBackBarButtonItem:citiesBack];
        
        
    }

    //Searchbar
    _searchBar.delegate = (id)self;

    //Change search button in keyboard
    for(UIView *subView in [_searchBar subviews]) {
        if([subView conformsToProtocol:@protocol(UITextInputTraits)]) {
            [(UITextField *)subView setReturnKeyType: UIReturnKeyDone];
        } else {
            for(UIView *subSubView in [subView subviews]) {
                if([subSubView conformsToProtocol:@protocol(UITextInputTraits)]) {
                    [(UITextField *)subSubView setReturnKeyType: UIReturnKeyDone];
                }
            }
        }
    }
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
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

- (void)segueToItinerary {
    [self performSegueWithIdentifier:@"itinerary_segue" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [destination activitiesCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    NSString *key = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)section]];
    NSNumber *isExpanded = [expandedSections valueForKey:key];

    // check if expanded
    if (isExpanded == nil || isExpanded.intValue == 0) {
        if(isFiltered) {
            return [filteredTableData count];
        }
        return [destination activitiesCount];
    }else{
        // expanded
        return [((DestinationObject *)[[_appDelegate.tripManager getDestinations] objectAtIndex:section]) selected_activities].count +1;
    }

    return -1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"POICell";
    UITableViewCell *cell = nil;

    if (indexPath.row == 0) {
        POISuggestionCell *poicell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (poicell == nil) {
            poicell = [[POISuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        POIObject *poi;
        if(isFiltered) {
            poi = [filteredTableData objectAtIndex:indexPath.row];
        }
        else {
            poi = (POIObject *)[destination venueAtIndex:indexPath.row];
        }

        [poicell.activityName setText:[poi name]];
        [poicell.activityAddress setText:[poi address]];
        //    [cell.activityRating setText:[[poi rating] stringValue]];
        [poicell.activityRating setText:[poi price]];
        [poicell setAccessoryType:UITableViewCellAccessoryNone];
        [poicell.activityImage setImageWithURL:[NSURL URLWithString:[poi imageURL]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
        cell = poicell;
    }
    else {
        POIDetailCell *poidetailcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (poidetailcell == nil) {
            poidetailcell = [[POIDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        POIObject *poi = (POIObject *)[destination venueAtIndex:indexPath.row];

        [poidetailcell.rating setText:[[poi rating] stringValue]];
        [poidetailcell.twitter setText:[NSString stringWithFormat:@"@%@", [poi twitter]]];
        [poidetailcell.url setText:[poi url]];
        [poidetailcell.description setText:[poi description]];
        [poidetailcell.phone setText:[poi phone_number]];
        poidetailcell.poi = poi;
        poidetailcell.destIndexPath = destination.destID;

        cell = poidetailcell;
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
        for (int i=0; i<[((DestinationObject *)[[_appDelegate.tripManager getDestinations] objectAtIndex:indexPath.section]) selected_activities].count; ++i) {
            [tmpArray addObject:[NSIndexPath indexPathForRow:i+1 inSection:indexPath.section]];
        }

        // check if expanded
        if (isExpanded == nil || isExpanded.intValue == 0) {
            // not expanded; expand
            POIDetailCell *cell = (POIDetailCell *)[self.tableView cellForRowAtIndexPath:indexPath];

            [expandedSections setValue:[NSNumber numberWithInt:1] forKey:key];
            [self.tableView insertRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            // expanded; collapse
            POIDetailCell *cell = (POIDetailCell *)[self.tableView cellForRowAtIndexPath:indexPath];

            [expandedSections setValue:[NSNumber numberWithInt:0] forKey:key];
            [self.tableView deleteRowsAtIndexPaths:tmpArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }

        [self.tableView endUpdates];
    }

    [self.tableView reloadData];
}

#pragma mark - Navigation


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"next_city_segue"]) {
        POISuggestionViewController *vc = (POISuggestionViewController *)[segue destinationViewController];
        [vc setDestinations:_destinations];
        [vc setIndex:[NSNumber numberWithInt:_index.intValue+1]];
    }
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    NSLog(@"Searching for activities matching %@", text);
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = TRUE;
        if (filteredTableData) {
            [filteredTableData removeAllObjects];
        }
        else {
            filteredTableData = [[NSMutableArray alloc] init];
        }

        for (POIObject* poi in activitySuggestions)
        {
            NSRange nameRange = [poi.name rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || [poi.name rangeOfString:text].location != NSNotFound)
            {
                [filteredTableData addObject:poi];
            }
            else {
                NSRange tagRange;
                for(NSString *tag in poi.tags) {
                    tagRange = [tag rangeOfString:text options:NSCaseInsensitiveSearch];
                    if(tagRange.location != NSNotFound|| [tag rangeOfString:text].location != NSNotFound) {
                        [filteredTableData addObject:poi];
                        break;
                    }
                }
            }
        }
        NSLog(@"%lu activities found for %@", (unsigned long)[filteredTableData count], text);
    }

    [self.tableView reloadData];
}

@end
