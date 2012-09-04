//
//  SingleEntry.h
//  HappyEntries
//
//  Created by Haozhu Wang on 8/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SingleEntry : NSManagedObject

@property (nonatomic, retain) NSDate * entryDate;
@property (nonatomic, retain) NSString * entryTitle;
@property (nonatomic, retain) NSString * entryBody;
@property (nonatomic, retain) NSNumber * entryRating;

@end
