//
//  SJSUAppDelegate.h
//  CoreDataSample
//
//  Created by Dhwanil Karwa on 11/29/13.
//  Copyright (c) 2013 Dhwanil Karwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"
#import "Artist.h"
#import "Label.h"

@interface SJSUAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
