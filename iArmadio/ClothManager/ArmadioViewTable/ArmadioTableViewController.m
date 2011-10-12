//
//  LookTableViewController.m
//  iArmadio
//
//  Created by Casa Fortunato on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ArmadioTableViewController.h"


@implementation ArmadioTableViewController




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundle delegateController:(id)_delegateController{
    [self initWithNibName:nibNameOrNil bundle:bundle];
    delegateController = _delegateController;
    return self;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)reloadCassetti{
    if(tipologie != nil){
        [tipologie release];
    }
    
    tipologie = [NSMutableArray arrayWithArray:dao.listTipiKeys];
    [tipologie retain];             
}

- (void)reloadCassetti:(NSNotification *)pNotification{
    [self reloadCassetti];
    [(UITableView *)self.view reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dao = [IarmadioDao shared]; 
    
    self.view.backgroundColor = [UIColor clearColor];;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCassetti:) name:ADD_CLOTH_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCassetti:) name:MOD_CLOTH_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCassetti:) name:DEL_CLOTH_EVENT object:nil];
    
    [self reloadCassetti];
    
    //self.navigationItem.rightBarButtonItem = self.add;
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
   [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tipologie count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSArray *tmp = [[[NSArray alloc] initWithObjects:[tipologie objectAtIndex:indexPath.row],nil] autorelease];
    
    NSInteger count = [[dao getVestitiEntities:tmp filterStagioneKey:nil filterStiliKeys:nil filterGradimento:-1] count];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [dao getImageFromTipo:([dao getTipoEntity:[tipologie objectAtIndex:indexPath.row]])]; 
    cell.textLabel.text = [dao getTipoEntity:[tipologie objectAtIndex:indexPath.row]].plural;
    [cell.textLabel setTextColor:[UIColor darkTextColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:18 ]];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:12 ]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", count];
    
    
    
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(delegateController != nil){
        [(SelectTypeViewController *)delegateController selectedIndex:indexPath.row];
    }
    else{
        
        if(coverviewcontroller != nil){
            [coverviewcontroller removeNotification];
            [coverviewcontroller release];
            coverviewcontroller = nil;
        }
            coverviewcontroller = [[CoverViewController alloc] initWithNibName:@"CoverViewController" bundle:nil getTipologia:[tipologie objectAtIndex:indexPath.row]];
           
            
            [tableView  deselectRowAtIndexPath:indexPath animated:YES];
            [self.navigationController pushViewController:coverviewcontroller animated:YES];
        
            [CurrState shared].currTipologia = [tipologie objectAtIndex:indexPath.row];
    }
         
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    
    return nil;

}     

@end
