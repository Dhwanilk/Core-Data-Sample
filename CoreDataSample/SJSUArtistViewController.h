//
//  SJSUArtistViewController.h
//  CoreDataSample
//
//  Created by Dhwanil Karwa on 11/30/13.
//  Copyright (c) 2013 Dhwanil Karwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJSUAppDelegate.h"
#import "Artist.h"

@interface SJSUArtistViewController : UITableViewController

// An array to house all of our fetched Artist objects
@property (strong, nonatomic) NSArray *artistArray;

//The id of the parent object
@property (strong, nonatomic) NSManagedObjectID *labelID;


@end
