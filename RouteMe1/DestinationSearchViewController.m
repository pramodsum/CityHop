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
#import "AppDelegate.h"

@interface DestinationSearchViewController ()

@end

@implementation DestinationSearchViewController {
    NSString *city_name;
    NSMutableArray *cities;
    TripManager *tripManager;
    NSTimer *refreshTimer;
}

@synthesize searchbar;
@synthesize appDelegate = _appDelegate;

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
    [searchbar setDelegate:self];
    [self.searchDisplayController setDelegate:self];
    tripManager = _appDelegate.tripManager;
    
    [searchbar becomeFirstResponder];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)startRefreshTimer {
    if (refreshTimer == nil) {
        refreshTimer = [NSTimer
                        scheduledTimerWithTimeInterval:0.5f
                        target:self
                        selector:@selector(refreshResults)
                        userInfo:nil
                        repeats:YES];
    }
}

- (void)stopRefreshTimer {
    [refreshTimer invalidate];
    refreshTimer = nil;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startRefreshTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopRefreshTimer];
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
    UITableViewCell *cell; //  = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (cities != nil && [cities count] > indexPath.row) {
        NSDictionary *place= [cities objectAtIndex:indexPath.row];
        [cell.textLabel setText:[place objectForKey:@"description"]];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self stopRefreshTimer];
    
    //Create DestinationObject and add to destination
    NSDictionary *place= [cities objectAtIndex:indexPath.row];
    city_name = [place objectForKey:@"description"];
    [tripManager addDestinationWithString:city_name];
    if ([self.tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone) {
        [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
    }
    
}

#pragma mark - Search

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText == nil || [searchText isEqualToString:@""]) {
        if (cities != nil) {
            [cities removeAllObjects];
        }
        
        [self.tableView reloadData];
        return;
    }
    
    [self startRefreshTimer];
    
    NSString *kGOOGLEAPIKEY = @"AIzaSyDIsJnliy1sZ04e_vR3rEkvKC-eR07ULX4";
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=(cities)&sensor=false&key=%@", searchText, kGOOGLEAPIKEY];

    NSLog(@"And the url string is: %@", url); //caveman debuging

    NSURL *googleRequestURL = [NSURL URLWithString:url];

    [NSURLConnection sendAsynchronousRequest: [[NSURLRequest alloc] initWithURL:googleRequestURL]
                                       queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

        if (!error) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSArray *places = [json objectForKey:@"predictions"];
            
            
            if (cities == nil){
                cities = [[NSMutableArray alloc] init];
            }else{
                [cities removeAllObjects];
            }
            

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

- (void) refreshResults {
    [self.tableView reloadData];
}

@end
