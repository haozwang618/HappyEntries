//
//  EntryCell.m
//  HappyEntries
//
//  Created by Haozhu Wang on 9/3/12.
//
//

#import "EntryCell.h"

@implementation EntryCell
@synthesize scoreLabel, titleLabel, dateLabel, reasonTextView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
