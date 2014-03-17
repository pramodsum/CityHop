//
//  ItineraryMasterCell.h
//  CityHop
//
//  Created by Adam Oxner on 3/16/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItineraryMasterCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *activitiesLabel;
@property (strong, nonatomic) IBOutlet UILabel *expandCollapseLabel;

@end
