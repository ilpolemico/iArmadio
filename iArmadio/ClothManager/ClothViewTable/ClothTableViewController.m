//
//  LookTableViewController.m
//  iArmadio
//
//  Created by Casa Fortunato on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClothTableViewController.h"


@implementation ClothTableViewController



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

- (void)reloadVestiti{
    if(vestitiForType != nil){
        [vestitiForType release];
    }
    
    vestitiForType = [[NSMutableArray alloc] initWithCapacity:[dao.listTipiKeys count]];
    
    for( NSString *tipo in dao.listTipiKeys){ 
        
        NSArray *vestiti = [dao getVestitiEntities:[NSArray arrayWithObjects:tipo,nil] filterStagioneKey:nil filterStiliKeys:nil filterGradimento:-1];
        
        [vestitiForType addObject:vestiti];
    }
    
}

- (void)reloadVestiti:(NSNotification *)pNotification{
    [self reloadVestiti];
    [(UITableView *)self.view reloadData];
}

- (void)viewDidLoad
{
    dao = [IarmadioDao shared]; 
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVestiti:) name:ADD_CLOTH_EVENT object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVestiti:) name:MOD_CLOTH_EVENT object:nil];
    
    [self reloadVestiti];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [super viewDidLoad];

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
    return [dao.listTipiKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *tmp = [vestitiForType objectAtIndex:section];
    //NSLog(@"%d",[tmp count]);
    return [tmp count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    NSArray *tmp = [vestitiForType objectAtIndex:indexPath.section];
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[dao getImageFromVestito:((Vestito *)[tmp objectAtIndex:indexPath.row])]];
    cell.imageView.image = [dao getImageFromVestito:((Vestito *)[tmp objectAtIndex:indexPath.row])];
    //cell.imageView.frame = CGRectMake(100,10, 100, 10);
    
    //cell.textLabel.text = ((Vestito *)[tmp objectAtIndex:indexPath.row]).immagine;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  50;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSArray *tmp = [vestitiForType objectAtIndex:indexPath.section];
        
        
        [dao delVestitoEntity:[tmp objectAtIndex:indexPath.row]];
        [self reloadVestiti];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *tmp = [vestitiForType objectAtIndex:indexPath.section];
    Vestito *vestito = [tmp objectAtIndex:indexPath.row];
    
    ClothViewController *getviewcontroller = [[ClothViewController alloc] initWithNibName:@"ClothView" bundle:nil getVestito: vestito];
    
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];  
    [self.navigationController pushViewController:getviewcontroller animated:YES];
    [getviewcontroller release];
     
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if([[vestitiForType objectAtIndex:section] count] > 0){
        return [dao.listTipiKeys objectAtIndex:section];
    }
    return nil;

}     

@end
