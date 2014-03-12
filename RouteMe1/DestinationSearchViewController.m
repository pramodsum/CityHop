//
//  DestinationSearchViewController.m
//  RouteMe1
//
//  Created by Sumedha Pramod on 2/27/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "DestinationSearchViewController.h"
#import "POISuggestionViewController.h"
#import "DestinationObject.h"
#import "TripManager.h"

@interface DestinationSearchViewController ()

@end

@implementation DestinationSearchViewController {
    NSString *city_name;
    NSMutableArray *cities;
    TripManager *tripManager;
}

@synthesize searchbar;

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
    [searchbar.delegate self];
    [self.searchDisplayController.delegate self];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSDictionary *place= [cities objectAtIndex:indexPath.row];
    [cell.textLabel setText:[place objectForKey:@"description"]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Create DestinationObject and add to destination
    NSDictionary *place= [cities objectAtIndex:indexPath.row];
    city_name = [place objectForKey:@"description"];
    [tripManager addDestinationWithString:city_name];

    //Prepare for Segue
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    POISuggestionViewController *poi_controller;
    poi_controller.city = city_name;
    [[self navigationController] pushViewController:poi_controller animated:YES];
}

#pragma mark - Search

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *kGOOGLEAPIKEY = @"AIzaSyDIsJnliy1sZ04e_vR3rEkvKC-eR07ULX4";
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=(cities)&sensor=false&key=%@", searchText, kGOOGLEAPIKEY];

    NSLog(@"And the url string is: %@", url);//caveman debuging

    NSURL *googleRequestURL = [NSURL URLWithString:url];

    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:googleRequestURL] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

        if (!error) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSArray *places = [json objectForKey:@"predictions"];
            cities = [[NSMutableArray alloc] init];

            for (NSDictionary *place in places) {
                [cities addObject:place];
            }
//            NSLog(@"Cities: %@", cities);

        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
    [self.tableView reloadData];
}

@end
