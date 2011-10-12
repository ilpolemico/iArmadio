//
//  ImageItemViewController.m
//  iArmadio
//
//  Created by Casa Fortunato on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoverViewController.h"


 

@implementation CoverViewController

@synthesize addButton,
            openflow,
            segmentcontrol,
            segmentfiltroStile,
            segmentOrderBy,
            coverBtn,
            coverView;

static CGRect frameCover;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil getTipologia:(NSString *)_tipologia{
    
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    tipologia = _tipologia;
    [tipologia retain];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVestiti:) name:ADD_CLOTH_EVENT object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVestiti:) name:DEL_CLOTH_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVestiti:) name:MOD_CLOTH_EVENT object:nil];
    
    
    return self;
}

- (void)setLocalCurrStile :(NSString *) orderKey{
    if(localCurrStile != nil){
        [localCurrStile release];
    }
    localCurrStile = orderKey;  
    
}

- (NSString *)localCurrStile{
    return localCurrStile; 
}


- (void)addLocalCurrOrderBy:(NSString *) orderKey{
    if(localCurrOrderBy == nil){
        localCurrOrderBy = [[NSMutableArray alloc] init];
    }
    
    NSMutableDictionary *key = [[[NSMutableDictionary alloc] init] autorelease];
    if(orderKey != nil){
        [key setObject:orderKey forKey:@"field"];
        [key setObject:@"YES" forKey:@"ascending"];
        [localCurrOrderBy addObject:key];
    }
}

- (NSMutableArray *)localCurrOrderBy{
    if(localCurrOrderBy == nil){
        localCurrOrderBy = [[NSMutableArray alloc] init];
    }
    
    return localCurrOrderBy; 
    
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)reloadVestiti:(NSNotification *)pNotification{
   if([currstate.currSection isEqualToString:@"COVERFLOW"]){
        [self reloadVestiti];
        if([pNotification.name isEqualToString:ADD_CLOTH_EVENT]){
            [self addIterator];
        }
    }
    
    
    
}

- (void)reloadVestiti{
    
    
    [self addLocalCurrOrderBy:@"id"];
    
    if(vestiti != nil){
        [vestiti release];
    }
    
    vestiti = [dao getVestitiEntities:[NSArray arrayWithObjects:tipologia,nil] filterStagioneKey:currstate.currStagioneKey filterStiliKeys:[[[NSArray alloc] initWithObjects:localCurrStile, nil] autorelease] filterGradimento:-1 sortOnKeys:localCurrOrderBy];
    
    [vestiti retain];
    
    [self.openflow emptyCache];
    [self.openflow draw];
        
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dao = [IarmadioDao shared];
    currstate = [CurrState shared];
    [self initInputType];
    
    
    if(currstate.currStagioneIndex == nil){currstate.currStagioneIndex = [NSNumber numberWithInt:0];}
    
    
    self.navigationItem.titleView = segmentcontrol;
    frameCover = self.openflow.frame;
    
    
    self.navigationItem.rightBarButtonItem = self.addButton;
    
    localCurrStile = nil;
    localCurrOrderBy = nil;
    
    [self.view setUserInteractionEnabled:FALSE];
    segmentOrderBy.selectedSegmentIndex = 0;
    segmentfiltroStile.selectedSegmentIndex = 0;
    segmentcontrol.selectedSegmentIndex = [currstate.currStagioneIndex intValue];
    segmentOrderBy.enabled = YES;
    segmentfiltroStile.enabled = YES;
    currstate.currSection = @"COVERFLOW";
    [self.view setUserInteractionEnabled:TRUE];
    [self reloadVestiti:nil];
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[dao getImageFromSection:@"CoverView" type:@"background"]];

    
}


- (void)initInputType{
    [segmentOrderBy setImage:[dao getImageFromSection:@"CoverView" type:@"icona_ordina_data"] forSegmentAtIndex:0];
    [segmentOrderBy setImage:[dao getImageFromSection:@"CoverView" type:@"icona_ordina_gradimento"] forSegmentAtIndex:1];
    
    
    for(NSString *stileKey in [dao listStiliKeys]){
        Stile *stile = [dao getStileEntity:stileKey];
        [segmentfiltroStile setImage:[dao getImageFromStile:stile] forSegmentAtIndex:[stile.id intValue]-1];
    }
    
    [segmentfiltroStile setImage:
     [dao getImageFromSection:@"CoverView" type:@"icona_stile_all"] forSegmentAtIndex:[[dao listStiliKeys] count]];
    
    
    for(NSString *currStagioneKey in [dao listStagioniKeys]){
        Stagione *stagione = [dao getStagioneEntity:currStagioneKey];
        [segmentcontrol setImage:[dao getImageFromStagione:stagione] forSegmentAtIndex:[stagione.id intValue]];
    }
    
    [segmentcontrol setImage:
     [dao getImageFromSection:@"CoverView" type:@"icona_stagione_all"] forSegmentAtIndex:[[dao listStagioniKeys] count]];


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return NO;
}

-(IBAction)addItem:(id)sender{
    
    if(captureClothController != nil){
        [captureClothController.view removeFromSuperview];
        [captureClothController release];
        captureClothController = nil;
        
    }
    currstate.currSection = @"COVERFLOW";
    
    captureClothController = [[CaptureClothController alloc] initWithNibName:@"CaptureClothController" bundle:nil parentController:self  iterator:NO];
    [self.view addSubview:captureClothController.view];
}
    


-(IBAction)changeStagione:(id)sender{
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    
    currstate.currStagioneIndex = [NSNumber numberWithInteger:selectedSegment];
    [self reloadVestiti:nil];
}


-(IBAction)changeStile:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;

    if(selectedSegment < [dao.listStiliKeys count]){
        localCurrStile = [dao.listStiliKeys objectAtIndex:selectedSegment] ;
    }
    else{
        localCurrStile = nil;
    }
    
    currstate.currStile =  localCurrStile;    
    [self reloadVestiti:nil];
}

-(IBAction)changeOrderBy:(id)sender{
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    NSString *sortKey;
    
    [localCurrOrderBy release];
    localCurrOrderBy = nil;
    if(selectedSegment == 1){
        sortKey = @"gradimento";
        [self addLocalCurrOrderBy:sortKey];
    }
    
    [self reloadVestiti:nil];
}




- (void)addIterator
{
    
    if([currstate.currSection isEqualToString:@"COVERFLOW"]){
        if(captureClothController != nil){
            [captureClothController.view removeFromSuperview];
            [captureClothController release];
            captureClothController = nil;
        }
        captureClothController = [[CaptureClothController alloc] initWithNibName:@"CaptureClothController" bundle:nil parentController:self  iterator:YES];
        [self.view addSubview:captureClothController.view];
    }
 
}


- (int)flowCoverNumberImages:(FlowCoverView *)view
{
	return [vestiti count];
}

- (UIImage *)flowCover:(FlowCoverView *)view cover:(int)image
{
    
    if([vestiti count] <= image){
        return [[[UIImage alloc] init] autorelease];
    }
    return [dao getThumbnailFromVestito:[vestiti objectAtIndex:image]];
}

- (void)flowCover:(FlowCoverView *)view didSelect:(int)image
{
	if([vestiti count] > image){
        ClothViewController *getviewcontroller = [[ClothViewController alloc] initWithNibName:@"ClothView" bundle:nil getVestito: [vestiti objectAtIndex:image]];
        
        iArmadioAppDelegate *appDelegate = (iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        getviewcontroller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [appDelegate.tabBarController presentModalViewController:getviewcontroller animated:YES];
        [getviewcontroller release];
    }
}



-(void)removeNotification{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void) viewWillDisappear:(BOOL)animated{

    
}

-(void) viewWillAppear:(BOOL)animated{
}



-(void) dealloc{
    [captureClothController release];
    [localCurrStile release];
    [localCurrOrderBy release];
    [openflow release];
    [vestiti release];
    [addButton release];
    [segmentcontrol release];
    [segmentfiltroStile release];
    [segmentOrderBy release];
    [coverBtn release];
    [coverView release];
    [currstate release];
    [dao release];
    [tipologia release];
    [stagioneKey release];
    [stili release];
    [super dealloc]; 

}

@end
