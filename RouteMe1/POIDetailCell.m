//
//  POIDetailCell.m
//  CityHop
//
//  Created by Sumedha Pramod on 3/17/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "POIDetailCell.h"

@implementation POIDetailCell {
    TripManager *tripManager;
}

@synthesize poi = _poi;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addVenue:(id)sender {
    if (_poi.selected) {
        _poi.selected = [NSNumber numberWithInt:1];
        [tripManager addVenueToDestinationByID:_poi :_destIndexPath];
    }else{
        _poi.selected = 0;
    }
}
@end
