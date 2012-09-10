//
//  EntryTableViewController.h
//  HappyEntries
//
//  Created by Haozhu Wang on 9/3/12.
//
//

#import <UIKit/UIKit.h>

typedef enum DateMode {
    ALL = 0,
    DAY = 10,
    WEEK = 20,
    MONTH = 30,
    YEAR = 40,
} DateMode;

@interface EntryTableViewController : UITableViewController<UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) UIPickerView * dateModePicker;
@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) NSMutableArray * entryArray;
@property (strong, nonatomic) NSMutableArray * keyArray;

@property (strong, nonatomic) NSMutableDictionary * categorizedEntryArrays;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction)organizeButtonPress:(id)sender;
@end
