//
//  EntryCell.h
//  HappyEntries
//
//  Created by Haozhu Wang on 9/3/12.
//
//

#import <UIKit/UIKit.h>

@interface EntryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UITextView *reasonTextView;

@end
