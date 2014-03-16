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
    NSData *currentBestRouteJSON;
    NSMutableArray *tempRoute;
    NSNumber* currentBestRouteTime;
    NSOperationQueue *queue;
    NSNumber *returnedQueries;
}

@synthesize inputRoute = _inputRoute;

- (NSArray *)optimizedRoute {
    currentBestRouteJSON = nil;
    currentBestRouteTime = nil;
    
    if (queue == nil) {
        queue = [[NSOperationQueue alloc] init];
    }
    
    if (_inputRoute == nil) {
        NSLog(@"Hey input a route, dummy");
        return nil;
    }else if (_inputRoute.count < 3){
        // no optimization required
        return _inputRoute;
    }
    
    NSMutableArray *rotatedRoutes = [[NSMutableArray alloc] init];
    tempRoute = [[NSMutableArray alloc] initWithArray:_inputRoute]; // deep copy
    
    // going through each possible configuration (N-1)
    for (int j=0; j<_inputRoute.count; ++j) {
        NSLog(@"--Rotation #%d--", j);
        
        // rotating
        NSObject* obj = [tempRoute lastObject];
        [tempRoute insertObject:obj atIndex:0];
        [tempRoute removeLastObject];
        [rotatedRoutes insertObject:[tempRoute copy] atIndex:j];
        
        
        
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
        
        
        NSString *kGOOGLEAPIKEY = @""; // = @"AIzaSyDIsJnliy1sZ04e_vR3rEkvKC-eR07ULX4"; // = @"AIzaSyDjZZMnFn4gg-Lxweh_QS8C4ZMnpnAAqR4"; //
        NSString *url =
        [NSString
         stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&waypoints=%@&sensor=false&key=%@",
         origin, destination, waypoints, kGOOGLEAPIKEY];
        
        NSLog(@"And the url string is: %@", url);
        
        NSURL *googleRequestURL = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [NSURLConnection
            sendAsynchronousRequest:[[NSURLRequest alloc]initWithURL:googleRequestURL]
                                        queue:queue
                                        completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            // random pause
            NSDate *n = [NSDate date];
            while ([n timeIntervalSinceNow] > -1*arc4random()%2) {
                   // do nothing
                NSLog(@"waiting...");
            }
                                            
            
            if (!error) {
                // parse
                
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                // NSLog(@"%@", json);
                NSArray *routes = [json objectForKey:@"routes"];
                if (routes == nil || routes.count == 0) {
                    NSDictionary *error1 = [json objectForKey:@"error_message"];
                    NSLog(@"ERROR: No routes returned.");
                    if (error1 != nil)
                        NSLog(@"Google says: %@", error1);
                    return;
                }
                NSArray *legs = [[routes objectAtIndex:0] objectForKey:@"legs"];
                
                NSNumber *trip_time = [NSNumber numberWithInt:0];
                
                for (NSDictionary *leg in legs) {
                    trip_time = [NSNumber numberWithInt:[(NSString *)[[leg objectForKey:@"duration"] objectForKey:@"value"] intValue]+trip_time.intValue];
                }
                
                // if this trip is the shortest, take note
                NSLog(@"Total duration: %@", trip_time);
                if (currentBestRouteTime == nil || trip_time.intValue < currentBestRouteTime.intValue) {
                    NSLog(@"...found new best route");
                    currentBestRouteJSON = [data copy];
                    currentBestRouteTime = [trip_time copy];
                    NSLog(@"START ADDRESS: %@", (NSString *)[[[[routes objectAtIndex:0] objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"start_address"]);
                }
                
                
            } else {
                NSLog(@"ERROR in optimization: %@", error);
            }
            
            returnedQueries = [NSNumber numberWithInt:returnedQueries.intValue+1];
        }];

    }
    
    while (returnedQueries.intValue < _inputRoute.count) {
        // do nothing :(
        // NSLog(@"waiting...");
    }
    

    for (NSArray *rotated in rotatedRoutes) {
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:currentBestRouteJSON options:kNilOptions error:&error];
        NSArray *routes = [json objectForKey:@"routes"];
        NSArray *legs = [[routes objectAtIndex:0] objectForKey:@"legs"];
        NSString *start_address = (NSString *)[[legs objectAtIndex:0] objectForKey:@"start_address"];
        
        if ( [[[start_address componentsSeparatedByString:@","] objectAtIndex:0]
              isEqualToString: [[((DestinationObject *)[rotated objectAtIndex:0]).name componentsSeparatedByString:@","] objectAtIndex:0] ] ) {
            NSLog(@"match!");
            return [rotated copy];
        }
    }
    
    NSLog(@"Optimization failed");
    return _inputRoute;
}

@end
