//
//  MasterViewController.h
//  HappyEntries
//
//  Created by Haozhu Wang on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UIViewController <NSFetchedResultsControllerDelegate, UITextViewDelegate, UIAlertViewDelegate>
{
    NSString * entryText;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet UISlider *moodySlider;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (strong, nonatomic) IBOutlet UITextView *reasonTextView;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) IBOutlet UIButton *postEntryButton;
@property (strong, nonatomic) IBOutlet UIButton *viewEntriesButton;

-(IBAction)sliderChange:(id)sender;
-(IBAction)clearedButton:(id)sender;
-(IBAction)postButtonPressed:(id)sender;
@end
