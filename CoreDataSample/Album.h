//
//  Album.h
//  CoreDataSample
//
//  Created by Dhwanil Karwa on 11/29/13.
//  Copyright (c) 2013 Dhwanil Karwa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Artist;

@interface Album : NSManagedObject

@property (nonatomic, retain) NSDate * releaseDate;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Artist *artist;

@end
