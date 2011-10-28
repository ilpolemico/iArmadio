//
//  FavoritesViewController.m
//  iArmadio
//
//  Created by Casa Fortunato on 06/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FavoritesViewController.h"

@implementation FavoritesViewController
@synthesize tableview, navbar, vestiti,combinazioni, imageview;

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
    [CurrState shared].currSection = SECTION_FAVORITES;
    
    self.tableview.delegate = self;
    self.tableview.backgroundColor = [UIColor clearColor];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVestitiPreferiti:) name:ADD_CLOTH_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVestitiPreferiti:) name:MOD_CLOTH_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVestitiPreferiti:) name:DEL_CLOTH_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVestitiPreferiti:) name:ADD_LOOK_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVestitiPreferiti:) name:MOD_LOOK_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVestitiPreferiti:) name:DEL_LOOK_EVENT object:nil];
    
    self.navbar.topItem.title=  NSLocalizedString(@"Preferiti", nil);
    
    self.imageview.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.imageview.bounds].CGPath;
    self.imageview.layer.shadowColor = [UIColor grayColor].CGColor;
    self.imageview.layer.shadowOffset = CGSizeMake(7, 1);
    self.imageview.layer.shadowOpacity = 1;
    self.imageview.layer.shadowRadius = 3.0;
    
    
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
   
   self.combinazioni = [dao getCombinazioniEntities:-1 filterStagioneKey:nil filterStiliKeys:nil sortOnKeys:orderBy preferiti:YES];
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
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if(section == 0){
        return [self.vestiti count];
    }
    return [self.combinazioni count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell.textLabel setTextColor:[UIColor darkTextColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:18 ]];
    [cell.detailTextLabel setFont:[UIFont fontWithName:@"MarkerFelt-Wide" size:12 ]];
    

    if(indexPath.section == 0){
        Vestito *vestito = (Vestito *)[self.vestiti objectAtIndex:indexPath.row];
        cell.imageView.image = [[dao getImageFromVestito:vestito] scaleToFitSize:CGSizeMake(80,80)];
        cell.textLabel.text = NSLocalizedString(((Tipologia *)[[vestito.tipi objectEnumerator] nextObject]).nome,nil) ;
    }
    else{
        Combinazione *combinazione = (Combinazione *)[self.combinazioni objectAtIndex:indexPath.row];
        
        NSMutableArray *images = [[[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",nil] autorelease];
        
        
        NSSet *vestitiInCombinazione = combinazione.fattaDi; 
        for(Vestito *vestito in vestitiInCombinazione){
            Tipologia *tipo = ([[vestito.tipi objectEnumerator] nextObject]);
            [images replaceObjectAtIndex:[tipo.choice intValue] withObject:[dao getImageFromVestito:vestito]];
        }
        
        
        int offset_x = 0;
        int offset_y = 0;
        int count = 0;
        
        for (UIView *view in cell.subviews) {
            [view removeFromSuperview];
        }
        
        for(UIImage *image in images){
            if ([image class] == [UIImage class]){
                UIImageView *_imageview = [[[UIImageView alloc] initWithImage:image] autorelease];
                _imageview.frame = CGRectMake(offset_x,offset_y,40,40);
                _imageview.contentMode = UIViewContentModeScaleAspectFit; 
                [cell addSubview:_imageview];
                
                offset_x += _imageview.frame.size.width;
                if(count == 6){
                    offset_x = 0;
                    offset_y += _imageview.frame.size.height;
                }
                count++;
            }
        }
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){return 80;}
    return 80;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        ClothViewController *getviewcontroller = [[ClothViewController alloc] initWithNibName:@"ClothView" bundle:nil getVestito: [self.vestiti objectAtIndex:indexPath.row]];
        
        iArmadioAppDelegate *appDelegate = (iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        getviewcontroller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [appDelegate.tabBarController presentModalViewController:getviewcontroller animated:YES];
        [getviewcontroller release];
    }
    else{
        LookViewController *lookviewcontroller = [[LookViewController alloc] initWithNibName:@"LookViewController" bundle:nil];
        lookviewcontroller.combinazione = [self.combinazioni objectAtIndex:indexPath.row];       
        [tableView  deselectRowAtIndexPath:indexPath animated:YES];
        
        iArmadioAppDelegate *appDelegate = (iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [appDelegate.tabBarController presentModalViewController:lookviewcontroller animated:YES];
        
        
        [lookviewcontroller release];
    }
    
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if(section == 0){
        return NSLocalizedString(@"Abiti","");
    }
    return  NSLocalizedString(@"Look","");
    
}    

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 1;
}




- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return [NSArray arrayWithObjects: NSLocalizedString(@"Abiti",""), NSLocalizedString(@"Look",""), nil] ;
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
