//
//  SJSULabelViewController.m
//  CoreDataSample
//
//  Created by Dhwanil Karwa on 11/30/13.
//  Copyright (c) 2013 Dhwanil Karwa. All rights reserved.
//

#import "SJSULabelViewController.h"
#import "SJSUArtistViewController.h"
#import "SJSULabelEntryViewController.h"

@interface SJSULabelViewController ()

@end

@implementation SJSULabelViewController

@synthesize labelArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadTableData];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    
    self.navigationItem.rightBarButtonItem = addItem;
}

#pragma mark - Private methods

- (SJSUAppDelegate *)appDelegate {
    return (SJSUAppDelegate *)[[UIApplication sharedApplication] delegate];
}


// This method executes a fetch request and reloads the table view.
- (void) loadTableData {
    
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    
    // Construct a fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Label"
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    // Add an NSSortDescriptor to sort the labels alphabetically
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    self.labelArray = [context executeFetchRequest:fetchRequest error:&error];
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [labelArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Grab the label
    Label *label = [self.labelArray objectAtIndex:indexPath.row];
    // Set the text of the cell to the label name
    cell.textLabel.text = label.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SJSUArtistViewController *artistViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ArtistViewController"];
    
    // Grab the label
    Label *label = [self.labelArray objectAtIndex:indexPath.row];
    
    artistViewController.labelID = [label objectID];
    
    [self.navigationController pushViewController:artistViewController animated:YES];
}

- (void) addItem {
    
    SJSULabelEntryViewController *labelEntryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LabelEntryViewController"];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:labelEntryViewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

// Add this method for slide to delete
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
        
        // Grab the label
        Label *label = [self.labelArray objectAtIndex:indexPath.row];
        
        [context deleteObject:[context objectWithID:[label objectID]]];
        
        // Save everything
        NSError *error = nil;
        if ([context save:&error]) {
            NSLog(@"The save was successful!");
        } else {
            NSLog(@"The save wasn't successful: %@", [error userInfo]);
        }
        
        NSMutableArray *array = [self.labelArray mutableCopy];
        [array removeObjectAtIndex:indexPath.row];
        self.labelArray = array;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
