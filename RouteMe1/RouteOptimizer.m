//
//  RouteOptimizer.m
//  CityHop
//
//  Created by Adam Oxner on 3/15/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "RouteOptimizer.h"
#import "DestinationObject.h"

@implementation RouteOptimizer

@synthesize inputRoute = _inputRoute;

- (NSArray *)optimizedRoute {
    
    if (_inputRoute == nil) {
        NSLog(@"Hey input a route, dummy");
        return nil;
    }else if (_inputRoute.count < 3){
        // no optimization required
        return _inputRoute;
    }
    
    NSMutableArray *opRoute = [[NSMutableArray alloc] init];
    
    NSString *origin, *destination, *waypoints=@"optimize:true|";
    
    origin = [[((DestinationObject *)[_inputRoute objectAtIndex:0]) name] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    destination = [[((DestinationObject *)[_inputRoute objectAtIndex:(_inputRoute.count-1)]) name] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    for (int i=1; i<_inputRoute.count-1; ++i) {
        waypoints = [[waypoints stringByAppendingString:[((DestinationObject *)[_inputRoute objectAtIndex:i]) name]] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        if (i < _inputRoute.count-2) {
            waypoints = [waypoints stringByAppendingString:@"|"];
        }
    }
    
    // debug
    NSLog(@"Waypoints: %@", waypoints);
    
    NSString *kGOOGLEAPIKEY = @"AIzaSyDjZZMnFn4gg-Lxweh_QS8C4ZMnpnAAqR4"; //  = @"AIzaSyDIsJnliy1sZ04e_vR3rEkvKC-eR07ULX4";
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
            NSArray *places = [json objectForKey:@"predictions"];
            
            for (NSDictionary *place in places) {
                //[cities addObject:place];
            }
            
            
        } else {
            NSLog(@"ERROR in optimization: %@", error);
        }
        
        
    }];
    
    
    return opRoute;
}

@end
