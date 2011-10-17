//
//  FavoritesViewController.m
//  iArmadio
//
//  Created by Casa Fortunato on 06/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FavoritesViewController.h"

@implementation FavoritesViewController
@synthesize tableview, navbar, vestiti;

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
    [self reloadVestitiPreferiti:nil];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[dao getImageFromSection:[CurrState shared].currSection type:@"background"]];
    
    self.tableview.delegate = self;
    self.tableview.backgroundColor = [UIColor clearColor];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVestitiPreferiti:) name:ADD_CLOTH_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVestitiPreferiti:) name:MOD_CLOTH_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVestitiPreferiti:) name:DEL_CLOTH_EVENT object:nil];
    
    self.navbar.topItem.title=  NSLocalizedString(@"Preferiti", nil);
    // Do any additional setup after loading the view from its nib.
}


- (void)reloadVestitiPreferiti:(NSNotification *)notification{
    
    NSMutableArray *orderBy = [[[NSMutableArray alloc] init] autorelease];
    NSMutableDictionary *key = [[[NSMutableDictionary alloc] init] autorelease];
    if(orderBy != nil){
        [key setObject:@"preferito" forKey:@"field"];
        [key setObject:@"NO" forKey:@"ascending"];
        [orderBy addObject:key];
    }
   //if(vestiti != nil){[vestiti release];}
   self.vestiti = [dao getVestitiEntities:nil filterStagioneKey:nil filterStiliKeys:nil filterGradimento:-1 sortOnKeys:orderBy preferiti:YES];
   
   [self.tableview reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return [dao.category count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dao getVestitiEntities:nil filterStagioneKey:nil filterStiliKeys:nil filterGradimento:-1 sortOnKeys:nil preferiti:YES] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.textLabel setTextColor:[UIColor darkTextColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:18 ]];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:12 ]];
    
    Vestito *vestito = (Vestito *)[self.vestiti objectAtIndex:indexPath.row];
    
    
    cell.imageView.image = [dao getImageFromVestito:vestito];
    cell.textLabel.text = NSLocalizedString(((Tipologia *)[[vestito.tipi objectEnumerator] nextObject]).nome,nil) ;
    //cell.detailTextLabel.text = vestito.];
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    ClothViewController *getviewcontroller = [[ClothViewController alloc] initWithNibName:@"ClothView" bundle:nil getVestito: [self.vestiti objectAtIndex:indexPath.row]];
    
    iArmadioAppDelegate *appDelegate = (iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    getviewcontroller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [appDelegate.tabBarController presentModalViewController:getviewcontroller animated:YES];
    [getviewcontroller release];
    
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    
    return NSLocalizedString([dao.listCategoryKeys objectAtIndex:section],nil);
    
}    

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 1;
}


/*
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *tempArray = [[[NSMutableArray alloc] init] autorelease];
    for(NSString *category in dao.listCategoryKeys){
        [tempArray addObject:NSLocalizedString(category, nil)];
    }
    return tempArray;
}
 */

-(void) dealloc{
    if(vestiti != nil){[vestiti release];}
    [dao release];
    [super dealloc];
}

@end
