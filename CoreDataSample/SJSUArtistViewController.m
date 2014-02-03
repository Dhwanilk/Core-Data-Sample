//
//  SJSUArtistViewController.m
//  CoreDataSample
//
//  Created by Dhwanil Karwa on 11/30/13.
//  Copyright (c) 2013 Dhwanil Karwa. All rights reserved.
//

#import "SJSUArtistViewController.h"
#import "SJSUAlbumViewController.h"
#import "SJSULabelEntryViewController.h"

@interface SJSUArtistViewController ()

@end

@implementation SJSUArtistViewController

@synthesize artistArray;
@synthesize labelID;

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
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addArtist)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self loadTableData];
}

-(void)addArtist{
    SJSULabelEntryViewController *labelEntryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LabelEntryViewController"];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:labelEntryViewController];

    [self presentViewController:navigationController animated:YES completion:nil];

}


#pragma mark - Private methods

- (SJSUAppDelegate *)appDelegate {
    return (SJSUAppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (void) loadTableData {
    
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    
    // Construct a fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Artist"
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"label == %@",
                              [context objectWithID:self.labelID]];
    [fetchRequest setPredicate:predicate];
    
    // Add an NSSortDescriptor to sort the labels alphabetically
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    NSError *error = nil;
    self.artistArray = [context executeFetchRequest:fetchRequest error:&error];
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
    // Return the number of rows in the section.
    return [artistArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArtistCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Artist *artist = [self.artistArray objectAtIndex:indexPath.row];
    cell.textLabel.text = artist.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SJSUAlbumViewController *albumViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumViewController"];
    
    // Grab the label
    Artist *artist = [self.artistArray objectAtIndex:indexPath.row];
    
    albumViewController.artistID = [artist objectID];
    
    [self.navigationController pushViewController:albumViewController animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
