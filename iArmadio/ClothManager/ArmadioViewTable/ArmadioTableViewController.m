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

- (void)correctFrame:(UIView *)viewWithWrongFrame {
    CGRect correctedFrame = [[viewWithWrongFrame superview] frame];
    correctedFrame.size.height = correctedFrame.size.height - self.navigationController.navigationBar.frame.size.height; /* Height without Navigation Bar */
    correctedFrame.origin.y = correctedFrame.origin.y + self.navigationController.navigationBar.frame.size.height; /* Origin below Navigation Bar */
    [viewWithWrongFrame setFrame:correctedFrame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dao = [IarmadioDao shared]; 
    //[self correctFrame:[self.navigationController.view.subviews objectAtIndex:0]];
    //[self.tableView setContentInset:UIEdgeInsetsMake(-self.navigationController.navigationBar.frame.size.height, 0, 0, 0)];
    
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

- (void)viewWillDisappear:(BOOL)animated {
}
- (void)viewWillAppear:(BOOL)animated {
    //[self performSelectorOnMainThread:@selector(cleanDisplay) withObject:nil waitUntilDone:NO];
    
}



- (void)viewDidAppear:(BOOL)animated
{
   [super viewDidAppear:animated];
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
    
    return [dao.category count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Category: %@ numelement: %d",[dao.listCategoryKeys objectAtIndex:section],[[dao.category objectForKey:[dao.listCategoryKeys objectAtIndex:section]] count]);
    return [[dao.category objectForKey:[dao.listCategoryKeys objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *category = [dao.listCategoryKeys objectAtIndex:indexPath.section];
    
    
    tipologie = [dao.category objectForKey:category];
    
    NSArray *tmp = [[[NSArray alloc] initWithObjects:[tipologie objectAtIndex:indexPath.row],nil] autorelease];
    
    NSInteger count = [[dao getVestitiEntities:tmp filterStagioneKey:nil filterStiliKeys:nil filterGradimento:-1] count];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
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
    
    
    NSString *category = [dao.listCategoryKeys objectAtIndex:indexPath.section];
    tipologie = [dao.category objectForKey:category];

    
    if(delegateController != nil){
        [(SelectTypeViewController *)delegateController selectedIndexPath:indexPath];
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


- (void)cleanDisplay {
    //[self.tableView setContentInset:UIEdgeInsetsZero]; /* Fix difference between horizontal and vertical orientation. */
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    [self correctFrame:[self.navigationController.view.subviews objectAtIndex:0]]; /* Correct the frame so it is after the Navigation Bar */
    
    /* Clean the display after turning... */
    [self performSelectorOnMainThread:@selector(cleanDisplay) withObject:nil waitUntilDone:NO];
}




- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    
    return [dao.listCategoryKeys objectAtIndex:section];

}    

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return dao.listCategoryKeys;
}


/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    
    return view;

}
 */


@end
