//
//  ItineraryMasterCell.m
//  CityHop
//
//  Created by Adam Oxner on 3/16/14.
//  Copyright (c) 2014 University of Michigan. All rights reserved.
//

#import "ItineraryMasterCell.h"

@implementation ItineraryMasterCell

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

@end
