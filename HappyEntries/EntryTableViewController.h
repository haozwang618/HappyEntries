//
//  EntryTableViewController.h
//  HappyEntries
//
//  Created by Haozhu Wang on 9/3/12.
//
//

#import <UIKit/UIKit.h>

@interface EntryTableViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray * entryArray;
@property (strong, nonatomic) NSMutableDictionary * categorizedEntryArrays;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
