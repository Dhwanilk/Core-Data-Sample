//
//  Label.h
//  CoreDataSample
//
//  Created by Dhwanil Karwa on 11/29/13.
//  Copyright (c) 2013 Dhwanil Karwa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Artist;

@interface Label : NSManagedObject

@property (nonatomic, retain) NSDate * founded;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *artists;
@end

@interface Label (CoreDataGeneratedAccessors)

- (void)addArtistsObject:(Artist *)value;
- (void)removeArtistsObject:(Artist *)value;
- (void)addArtists:(NSSet *)values;
- (void)removeArtists:(NSSet *)values;

@end
