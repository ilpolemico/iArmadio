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
    self = [super initWithNibName:nibNameOrNil bundle:bundle];
    delegateController = _delegateController;
    return self;
}


- (void)viewDidAppear:(BOOL)animated
{
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


- (void)reloadCassetti:(NSNotification *)pNotification{
    if(countVestiti != nil){
        [countVestiti release];
        countVestiti = nil;
    }
    
    countVestiti  = [[NSMutableDictionary alloc] init];
    
    for(NSString *category in dao.listCategoryKeys){
        NSArray *tipologie = [dao.category objectForKey:category];
        for(NSString *tmp in tipologie){
            NSInteger count = [[dao getVestitiEntities:[[[NSArray alloc] initWithObjects:tmp, nil] autorelease] filterStagioneKey:nil filterStiliKeys:nil filterGradimento:-1] count];
            [countVestiti setValue:[NSNumber numberWithInt:count] forKey:tmp];
        }    
        
    }
    [(UITableView *)self.view reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    dao = [IarmadioDao shared]; 
    self.view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    label.text = NSLocalizedString(@"Armadio", nil);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"STHeitiSC-Medium" size: 22.0];
    [self.navigationController.navigationBar.topItem setTitleView:label];
    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Armadio", nil);
    [label release];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCassetti:) name:ADD_CLOTH_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCassetti:) name:MOD_CLOTH_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCassetti:) name:DEL_CLOTH_EVENT object:nil];
    
    [self reloadCassetti:nil];
   
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}






#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [dao.category count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dao.category objectForKey:[dao.listCategoryKeys objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *CellIdentifier = [NSString stringWithFormat:@"%d_%d",indexPath.section,indexPath.row,nil];
    NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
         cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
   
    NSString *category = [dao.listCategoryKeys objectAtIndex:indexPath.section];
    NSMutableArray *tipologie = [dao.category objectForKey:category];
    
    NSString *tipologiaKey = [tipologie objectAtIndex:indexPath.row];
    NSInteger count = [[countVestiti objectForKey:tipologiaKey] intValue];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.imageView.image = [dao getImageFromTipo:([dao getTipoEntity:[tipologie objectAtIndex:indexPath.row]])]; 
    cell.textLabel.text = NSLocalizedString([dao getTipoEntity:[tipologie objectAtIndex:indexPath.row]].plural,nil);
    [cell.textLabel setTextColor:[UIColor darkTextColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:18 ]];
    [cell.detailTextLabel setFont:[UIFont  fontWithName:@"STHeitiSC-Medium" size:14 ]];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", count];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *category = [dao.listCategoryKeys objectAtIndex:indexPath.section];
    
    NSMutableArray *tipologie = [dao.category objectForKey:category];
    [tipologie retain];
    
    if(delegateController != nil){
        [(SelectTypeViewController *)delegateController selectedIndexPath:indexPath];
    }
    else{
        if(coverviewcontroller != nil){
            [coverviewcontroller release];
            coverviewcontroller = nil;
        }
        
        
        coverviewcontroller = [[CoverViewController alloc] initWithNibName:@"CoverViewController" bundle:nil getTipologia:[tipologie objectAtIndex:indexPath.row]];
            
        [tableView  deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController pushViewController:coverviewcontroller animated:YES];
        [CurrState shared].currTipologia = [tipologie objectAtIndex:indexPath.row];
    }
    
    [tipologie release];
    
         
}


/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    
    return NSLocalizedString([dao.listCategoryKeys objectAtIndex:section],nil);

}   
*/ 

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 1;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    NSMutableArray *tempArray = [[[NSMutableArray alloc] init] autorelease];
    for(NSString *category in dao.listCategoryKeys){
        [tempArray addObject:NSLocalizedString(category, nil)];
    }
    
    
    
    
    return tempArray;
}


/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [dao.listCategoryKeys objectAtIndex:section];
    label.backgroundColor = [UIColor clearColor];
    return label;

}
 */



- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{

    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) dealloc{
    NSLog(@"Dealloc ArmadioTable!");
    
    if(coverviewcontroller != nil){
        [coverviewcontroller release];
    }

    
    if(countVestiti != nil){
        [countVestiti release];
        countVestiti = nil;
    }
    [super dealloc];
}


@end
