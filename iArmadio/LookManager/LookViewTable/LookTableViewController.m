//
//  LookTableViewController.m
//  iArmadio
//
//  Created by Casa Fortunato on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LookTableViewController.h"


@implementation LookTableViewController

@synthesize addLookBtn, segmentControl;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundle{
    self = [super initWithNibName:nibNameOrNil bundle:bundle];
    return self;
}


- (void)viewDidAppear:(BOOL)animated
{
    [CurrState shared].currSection = SECTION_LOOKTABLEVIEW;
    [super viewDidAppear:animated];
     
}



- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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


- (void)reloadLook:(NSNotification *)pNotification{
    NSMutableDictionary *looks4Stile = [[NSMutableDictionary alloc] init];
    looks4Stile = nil;
    
    
    [(UITableView *)self.view reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    dao = [IarmadioDao shared]; 
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.title =  NSLocalizedString(@"look", nil); 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLook:) name:ADD_LOOK_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLook:) name:MOD_LOOK_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLook:) name:DEL_LOOK_EVENT object:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}






#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [dao.listStiliKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dao.category objectForKey:[dao.listCategoryKeys objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    //NSString *stile = [dao.listStiliKeys objectAtIndex:indexPath.section];
    
    /*
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [dao getImageFromTipo:([dao getTipoEntity:[tipologie objectAtIndex:indexPath.row]])]; 
    cell.textLabel.text = NSLocalizedString([dao getTipoEntity:[tipologie objectAtIndex:indexPath.row]].plural,nil);
    [cell.textLabel setTextColor:[UIColor darkTextColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:18 ]];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:12 ]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", count];
    
    
    */
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //NSString *stile = [dao.listStiliKeys objectAtIndex:indexPath.section];
    //Combinazione *combinazione = [dao.category objectForKey:category];

    
    LookViewController *lookviewcontroller = [[LookViewController alloc] initWithNibName:@"LookViewController" bundle:nil];
           
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:coverviewcontroller animated:YES];
    
    [lookviewcontroller release];
         
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return NSLocalizedString([dao.listStiliKeys objectAtIndex:section],nil);

}    

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    NSMutableArray *tempArray = [[[NSMutableArray alloc] init] autorelease];
    for(NSString *stile in dao.listStiliKeys){
        [tempArray addObject:NSLocalizedString(stile, nil)];
    }
    return tempArray;
}



- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{

    return NO;
}


-(IBAction) addLook:(id)sender{
    LookViewController *lookview = [[LookViewController alloc] initWithNibName:@"LookViewController" bundle:nil];
    [self presentModalViewController:lookview animated:YES];
    [lookview release];
}

-(IBAction) changeSegmentContol:(id)sender{
    [self reloadLook:nil];
}


-(void) dealloc{
    [super dealloc];
}


@end
