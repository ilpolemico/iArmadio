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
    NSMutableArray *keys = [[[NSMutableArray alloc] init] autorelease];
    NSMutableDictionary *key = [[[NSMutableDictionary alloc] init] autorelease];
    [key setObject:@"gradimento" forKey:@"field"];
    [key setObject:@"NO" forKey:@"ascending"];
    [keys addObject:key];
    
    
    [self.view setUserInteractionEnabled:FALSE];
    segmentControl.selectedSegmentIndex = [[CurrState shared].currStagioneIndex intValue];
    [self.view setUserInteractionEnabled:TRUE];
    
    if(combinazioniForStile != nil){
        [combinazioniForStile release];
        combinazioniForStile = nil;
    }
    combinazioniForStile = [[NSMutableDictionary alloc] init];
    
    
    for(NSString *stile in dao.listStiliKeys){
        
        
        
        NSArray *combinazioni = [dao getCombinazioniEntities:-1 filterStagioneKey:[CurrState shared].currStagioneKey filterStiliKeys:[NSArray arrayWithObject:stile] sortOnKeys:keys preferiti:NO ];
        [combinazioniForStile setValue:combinazioni forKey:stile];
    }
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLook:) name:ADD_CLOTH_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLook:) name:MOD_CLOTH_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLook:) name:DEL_CLOTH_EVENT object:nil];
    
    [self.view setUserInteractionEnabled:FALSE];
    segmentControl.selectedSegmentIndex = [[CurrState shared].currStagioneIndex intValue];
    [self.view setUserInteractionEnabled:TRUE];
    
    [self reloadLook:nil];
    [[Tutorial shared] actionInfo:ACTION_LOOKTABLE];
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
    NSString *stile = [dao.listStiliKeys objectAtIndex:section];
    return [[combinazioniForStile objectForKey:stile] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        [cell.textLabel setTextColor:[UIColor darkTextColor]];
        [cell.textLabel setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:18 ]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:12 ]];
    }
    
    NSString *stile = [dao.listStiliKeys objectAtIndex:indexPath.section];
    Combinazione *combinazione =  ((Combinazione *)[[combinazioniForStile objectForKey:stile] objectAtIndex:indexPath.row]);
    NSMutableArray *images = [[[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",nil] autorelease];
    
    NSSet *vestitiInCombinazione = combinazione.fattaDi; 
    for(Vestito *vestito in vestitiInCombinazione){
        Tipologia *tipo = ([[vestito.tipi objectEnumerator] nextObject]);
        [images replaceObjectAtIndex:[tipo.choice intValue] withObject:[dao getSmallImageFromVestito:vestito]];
        //[images replaceObjectAtIndex:[tipo.choice intValue] withObject:[dao getImageBundleFromFile:@"left_arrow.png"]];
    }
    
    int offset_x = 8;
    int offset_y = 8;
    int count = 0;
    
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    
    for(UIImage *image in images){
        if ([image class] == [UIImage class]){
            //UIImageView *imageview = [[[UIImageView alloc] initWithImage:image] autorelease];
            UIView *imageview = [[[UIImageView alloc] init]  autorelease];
            [imageview shadow:image];
            
            imageview.frame = CGRectMake(offset_x,offset_y,40,40);
            imageview.contentMode = UIViewContentModeScaleAspectFit;
            
            [cell addSubview:imageview];
            
            offset_x += imageview.frame.size.width+14;
            
            if(count == 3){
                offset_x = 8;
                offset_y += imageview.frame.size.height+14;
            }
            count++;
            
        }
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *stile = [dao.listStiliKeys objectAtIndex:indexPath.section];
    Combinazione *combinazione = [[combinazioniForStile objectForKey:stile] objectAtIndex:indexPath.row];
    
    
    LookViewController *lookviewcontroller = [[LookViewController alloc] initWithNibName:@"LookViewController" bundle:nil];
    lookviewcontroller.combinazione = combinazione;       
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    
    iArmadioAppDelegate *appDelegate = (iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    [appDelegate.tabBarController presentModalViewController:lookviewcontroller animated:YES];
    
    
    [lookviewcontroller release];
    
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return NSLocalizedString([dao.listStiliKeys objectAtIndex:section],nil);
    
}   


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
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
    
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction) addLook:(id)sender{
    LookViewController *lookview = [[LookViewController alloc] initWithNibName:@"LookViewController" bundle:nil];
    
    iArmadioAppDelegate *appDelegate = (iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.tabBarController presentModalViewController:lookview animated:YES];
    [lookview release];
}

-(IBAction) changeSegmentControl:(id)sender{
    if(self.view.isUserInteractionEnabled){    
        UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
        NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
        
        
        [CurrState shared].currStagioneIndex = [NSNumber numberWithInteger:selectedSegment];
        [self reloadLook:nil];  
    }    
}

-(void) dealloc{
    [addLookBtn release];
    [segmentControl release];
    [combinazioniForStile release];
    [super dealloc];
}


@end
