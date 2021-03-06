//
//  LookManagerController.m
//  iArmadio
//
//  Created by Casa Fortunato on 01/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LookManagerViewController.h"

@implementation LookManagerViewController
@synthesize lookTableViewController, navcontroler, imageview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    dao = [IarmadioDao shared]; 
    self.navigationItem.title =  NSLocalizedString(@"look", nil);
    [self.view addSubview:navcontroler.view];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc{
    [lookTableViewController release];
    [super dealloc];
}

@end
