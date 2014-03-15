//
//  RouteOptimizer.m
//  CityHop
//
//  Created by Adam Oxner on 3/15/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "RouteOptimizer.h"
#import "DestinationObject.h"

@implementation RouteOptimizer{
    NSArray *currentBestRoute;
    NSMutableArray *tempRoute;
    int currentBestRouteTime;
}

@synthesize inputRoute = _inputRoute;

- (NSArray *)optimizedRoute {
    currentBestRoute = nil;
    currentBestRouteTime = 0;
    
    if (_inputRoute == nil) {
        NSLog(@"Hey input a route, dummy");
        return nil;
    }else if (_inputRoute.count < 3){
        // no optimization required
        return _inputRoute;
    }
    
    NSMutableArray *opRoute = [[NSMutableArray alloc] init];
    tempRoute = [[NSMutableArray alloc] initWithArray:_inputRoute]; // deep copy
    
    // going through each possible configuration (N-1)
    for (int j=0; j<_inputRoute.count-1; ++j) {
        NSLog(@"--Rotation #%d--", j);
        
        // rotating
        NSObject* obj = [tempRoute lastObject];
        [tempRoute insertObject:obj atIndex:0];
        [tempRoute removeLastObject];
        
        
        
        // querying
        NSString *origin, *destination, *waypoints=@"optimize:true|";
        
        origin = [[((DestinationObject *)[tempRoute objectAtIndex:0]) name] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        destination = [[((DestinationObject *)[tempRoute objectAtIndex:(tempRoute.count-1)]) name] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        for (int i=1; i<tempRoute.count-1; ++i) {
            waypoints = [[waypoints stringByAppendingString:[((DestinationObject *)[tempRoute objectAtIndex:i]) name]] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
            if (i < tempRoute.count-2) {
                waypoints = [waypoints stringByAppendingString:@"|"];
            }
        }
        
        // debug
        NSLog(@"Waypoints: %@", waypoints);
        
        NSString *kGOOGLEAPIKEY   = @"AIzaSyDIsJnliy1sZ04e_vR3rEkvKC-eR07ULX4"; // = @"AIzaSyDjZZMnFn4gg-Lxweh_QS8C4ZMnpnAAqR4"; //
        NSString *url =
        [NSString
         stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&waypoints=%@&sensor=false&key=%@",
         origin, destination, waypoints, kGOOGLEAPIKEY];
        
        NSLog(@"And the url string is: %@", url);
        
        NSURL *googleRequestURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:googleRequestURL] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if (!error) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                NSLog(@"%@", json);
                NSDictionary *routes = [json objectForKey:@"routes"];
                if (routes == nil || routes.count == 0) {
                    NSLog(@"ERROR: No routes returned.");
                    return;
                }
                NSArray *legs = [routes objectForKey:@"legs"];
                
                int trip_time = 0;
                
                for (NSDictionary *leg in legs) {
                    NSLog(@"Adding duration: %@", (NSString *)[[leg objectForKey:@"duration"] objectForKey:@"value"]);
                    trip_time += [(NSString *)[[leg objectForKey:@"duration"] objectForKey:@"value"] intValue];
                }
                
                // if this trip is the shortest, take note
                if (trip_time < currentBestRouteTime) {
                    currentBestRoute = [[NSArray alloc] initWithArray:tempRoute];
                    currentBestRouteTime = trip_time;
                }
                
            } else {
                NSLog(@"ERROR in optimization: %@", error);
            }
            
            
        }];

    }
    
    
    
    return opRoute;
}

@end
