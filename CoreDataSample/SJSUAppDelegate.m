//
//  SJSUAppDelegate.m
//  CoreDataSample
//
//  Created by Dhwanil Karwa on 11/29/13.
//  Copyright (c) 2013 Dhwanil Karwa. All rights reserved.
//

#import "SJSUAppDelegate.h"

//Add to Project Scheme to see Raw SQL statements used by Core Data
//-com.apple.CoreData.SQLDebug 1

@implementation SJSUAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Insert some Data
    [self insertData];
    
    //Update the data inserted using above method
    [self updateData];
    
    //Insert data from JSON file Labels.json
    [self parseJson];
    
    //Read contents
    [self readData];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Private methods

-(void) parseJson{
    
    if ([self isPresent:@"Amy Grant"]) {
        return;
    }
    
    NSError *error;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"Labels" ofType:@"json"];
    NSArray* records = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                     options:kNilOptions
                                                       error:&error];
//    NSLog(@"Imported Banks: %@", records);
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    [records enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        Label *label = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Label"
                              inManagedObjectContext:context];
        label.name = [obj objectForKey:@"name"];
        label.genre = [obj objectForKey:@"genre"];
        
        // Create a Date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY"];
        NSDate *dateFounded = [dateFormatter dateFromString:[obj objectForKey:@"founded"]];
        label.founded = dateFounded;
        
        NSArray *artists = [obj objectForKey:@"artists"];
//        NSLog(@"Artists Choices:%@",artists);
        
        [artists enumerateObjectsUsingBlock:^(id obj1, NSUInteger idx, BOOL *stop) {
            Artist *artist = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Artist"
                            inManagedObjectContext:context];
            NSDictionary *tempArtistDict = [obj1 objectForKey:@"artist"];
            artist.name = [tempArtistDict objectForKey:@"name"];
            artist.hometown = [tempArtistDict objectForKey:@"hometown"];
            
            NSArray *albums = [tempArtistDict objectForKey:@"albumns"];
//            NSLog(@"Album Choices:%@",albums);
            
            [albums enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx, BOOL *stop) {
                Album *album = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"Album"
                                  inManagedObjectContext:context];
                NSDictionary *tempAlbumDict = [obj2 objectForKey:@"album"];
                album.releaseDate = [dateFormatter dateFromString:[tempAlbumDict objectForKey:@"releaseDate"]];
                album.title = [tempAlbumDict objectForKey:@"title"];
                [album setArtist:artist];
                [artist addAlbumsObject:album];
            }];
            
            [artist setLabel:label];
            [label addArtistsObject:artist];
        }];
    }];
    
    // Save everything
    NSError *errorSaving = nil;
    if ([context save:&errorSaving]) {
        NSLog(@"The save was successful!");
    } else {
        NSLog(@"The save wasn't successful: %@", [errorSaving userInfo]);
    }
}

- (void) insertData {
    //Check if artist is present dont add again.
    if ([self isPresent:@"Bryan Adams"]) {
        return;
    }
    
    // Grab the context
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Grab the Label entity and set attribute values
    Label *label = [NSEntityDescription insertNewObjectForEntityForName:@"Label" inManagedObjectContext:context];
    label.name = @"Mercury Records";
    label.genre = @"Various";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY"];
    NSDate *dateFounded = [dateFormatter dateFromString:@"1945"];
    label.founded = dateFounded;
    
    // Insert the Artist entity & set attribute values
    Artist *artist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:context];
    artist.name = @"Bryan Adams";
    artist.hometown = @"Ontario, Canada";
    
    // Insert Album entity & set attributes values
    Album *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
    album.title = @"Reckless";
    NSDate *releaseDate = [dateFormatter dateFromString:@"1984"];
    album.releaseDate = releaseDate;
    
    // Set relationships
    [label addArtistsObject:artist];
    [artist setLabel:label];
    [artist addAlbumsObject:album];
    [album setArtist:artist];
    
    // Save everything
    NSError *error = nil;
    if ([context save:&error]) {
        NSLog(@"The save was successful!");
    } else {
        NSLog(@"The save wasn't successful: %@", [error userInfo]);
    }
}

- (void) readData {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Construct a fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Label"
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (Label *label in fetchedObjects) {
        // Log the label details
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY"];
        NSLog(@"Label Id:%@",[label objectID]);
        NSLog(@"%@, %@, %@", label.name, [dateFormatter stringFromDate:label.founded], label.genre);
        
        NSLog(@"        Artists:");
        NSSet *artists = label.artists;
        for (Artist *artist in artists) {
            // Log the artist details
            NSLog(@"        Artist Id:%@",[artist objectID]);
            NSLog(@"        %@ , %@", artist.name, artist.hometown);
            
            NSLog(@"            Albums:");
            NSSet *albums = artist.albums;
            for (Album *album in albums) {
                // Log the album details
                NSLog(@"               Album Id:%@",[album objectID]);
                NSLog(@"                %@ , %@", album.title,  [dateFormatter stringFromDate:album.releaseDate]);
            }
        }
    }
}

- (void) updateData {
    
    if ([self isPresent:@"Richard Fagan"]) {
        return;
    }
    
    // Grab the context
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Perform fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Label"
                                              inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"Mercury Records"];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    // Date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY"];
    
    // Grab the label
    Label *label = [fetchedObjects objectAtIndex:0];
    
    // Bon Jovi
    Artist *jovi = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:context];
    jovi.name = @"Bon Jovi";
    jovi.hometown = @"Sayreville, NJ";
    
    // Juelz Santana albums
    Album *joviAlbum = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
    joviAlbum.title = @"What About Now";
    joviAlbum.releaseDate = [dateFormatter dateFromString:@"2013"];
    [joviAlbum setArtist:jovi];
    
    Album *joviAlbum2 = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
    joviAlbum2.title = @"The Circle";
    joviAlbum2.releaseDate = [dateFormatter dateFromString:@"2009"];
    [joviAlbum2 setArtist:jovi];
    
    // Set relationships
    [jovi addAlbums:[NSSet setWithObjects:joviAlbum, joviAlbum2, nil]];
    
    
    // Richard Fagan
    Artist *richard = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:context];
    richard.name = @"Richard Fagan";
    richard.hometown = @"Philly, Philadelphia";
    
    // Jim Jones albums
    Album *richardAlbum = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
    richardAlbum.title = @"The Good Lord Loves You";
    richardAlbum.releaseDate = [dateFormatter dateFromString:@"1980"];
    [richardAlbum setArtist:richard];
    
    Album *richardAlbum2 = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
    richardAlbum2.title = @"I Miss You a Little";
    richardAlbum2.releaseDate = [dateFormatter dateFromString:@"1997"];
    [richardAlbum2 setArtist:richard];
    
    Album *richardAlbum3 = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
    richardAlbum3.title = @"Why Can't We All Just Get a Longneck?";
    richardAlbum3.releaseDate = [dateFormatter dateFromString:@"2004"];
    [richardAlbum3 setArtist:richard];
    
    // Set relationships
    [richard addAlbums:[NSSet setWithObjects:richardAlbum, richardAlbum2, richardAlbum3, nil]];
    
    
    // Roger Miller
    Artist *miller = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:context];
    miller.name = @"Roger Miller";
    miller.hometown = @"Fort Worth, TX";
    
    Album *millerAlbum = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
    millerAlbum.title = @"A Trip in the Country";
    millerAlbum.releaseDate = [dateFormatter dateFromString:@"1970"];
    [millerAlbum setArtist:miller];
    
    Album *millerAlbum2 = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
    millerAlbum2.title = @"Green Green Grass of Home";
    millerAlbum2.releaseDate = [dateFormatter dateFromString:@"1994"];
    [millerAlbum2 setArtist:miller];
    
    [miller addAlbums:[NSSet setWithObjects:millerAlbum,millerAlbum2, nil]];
  
    // Set relationships
    [label addArtists:[NSSet setWithObjects:jovi, richard, miller, nil]];
    
    // Save everything
    if ([context save:&error]) {
        NSLog(@"The save was successful!");
    } else {
        NSLog(@"The save wasn't successful: %@", [error localizedDescription]);
    }
}

- (void) deleteData {
    // Grab the context
    NSManagedObjectContext *context = [self managedObjectContext];
    
    //  We're looking to grab an artist
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Artist"
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    // We specify that we only want Freekey Zekey
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"Roger Miller"];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    // Grab the artist and delete
    Artist *miller = [fetchedObjects objectAtIndex:0];
    [miller.label removeArtistsObject:miller];
    
    // Save everything
    if ([context save:&error]) {
        NSLog(@"The save was successful!");
    } else {
        NSLog(@"The save wasn't successful: %@", [error localizedDescription]);
    }
}



#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle]
                       URLForResource:@"CoreDataSample"
                       withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc]
                           initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory]
                       URLByAppendingPathComponent:@"CoreDataSample.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:nil
                                                           error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Check if already exists

-(BOOL)isPresent:(NSString *)name{
    // Grab the context
    NSManagedObjectContext *context = [self managedObjectContext];
    
    //  We're looking to grab an artist
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Artist"
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    // We specify that we only want Freekey Zekey
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if ([fetchedObjects count]>0) {
        return YES;
    }
    
    return NO;
}

@end
