//
//  SJSULabelEntryViewController.m
//  CoreDataSample
//
//  Created by Dhwanil Karwa on 11/30/13.
//  Copyright (c) 2013 Dhwanil Karwa. All rights reserved.
//

#import "SJSULabelEntryViewController.h"
#import "SJSUAppDelegate.h"
#import "Label.h"

@interface SJSULabelEntryViewController ()

@end

@implementation SJSULabelEntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"ParentView Controller:%@",[((UINavigationController*)[[self parentViewController] presentingViewController]) viewControllers]);
    
	// Do any additional setup after loading the view.
    // This will call our
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addLabel)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.navigationItem.title = @"Label Name";
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = item2;
}

#pragma mark - private methods

- (SJSUAppDelegate *)appDelegate {
    return (SJSUAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void) addLabel {
    
    // Grab the context
    NSManagedObjectContext *context = [[self appDelegate] managedObjectContext];
    
    // Grab the Label entity
    Label *label = [NSEntityDescription insertNewObjectForEntityForName:@"Label"
                                                 inManagedObjectContext:context];
    
    // Set label name
    label.name = self.txtLabelName.text;
    label.genre = @"Multiple";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY"];
    NSDate *dateFounded = [dateFormatter dateFromString:@"2012"];
    label.founded = dateFounded;
    
    // Save everything
    NSError *error = nil;
    if ([context save:&error]) {
        NSLog(@"The save was successful!");
    } else {
        NSLog(@"The save wasn't successful: %@", [error userInfo]);
    }
    
    [self dismiss];
}

- (void) dismiss {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
