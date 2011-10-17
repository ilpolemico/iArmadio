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
            orderBy_data,
            orderBy_gradimento,
            stile_1,
            stile_2,
            stile_3,
            stile_4,
            coverBtn,
            coverView,
            tipoView,
            tipoLabel,
            tipologia,
            ordinaLabel;

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
    self.tipologia = _tipologia;
    
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
        [key setObject:@"NO" forKey:@"ascending"];
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
   if(
      ([currstate.currSection isEqualToString:SECTION_COVERFLOW])
       ||
      ([currstate.oldCurrSection isEqualToString:SECTION_COVERFLOW]) 
     ) 
    {
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
    self.ordinaLabel.text = NSLocalizedString(self.ordinaLabel.text, nil);
    currstate.currSection = SECTION_COVERFLOW;
    [self initInputType];
    
    
    if(currstate.currStagioneIndex == nil){currstate.currStagioneIndex = [NSNumber numberWithInt:0];}
    
    
    self.navigationItem.titleView = segmentcontrol;
    frameCover = self.openflow.frame;
    
    
    self.navigationItem.rightBarButtonItem = self.addButton;
    
    localCurrStile = nil;
    localCurrOrderBy = nil;
    
    [self.view setUserInteractionEnabled:FALSE];
    segmentcontrol.selectedSegmentIndex = [currstate.currStagioneIndex intValue];
    currstate.currSection = SECTION_COVERFLOW;
    [self.view setUserInteractionEnabled:TRUE];
    [self reloadVestiti:nil];
    
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[dao getImageFromSection:@"CoverView" type:@"background"]];
    
    Tipologia *tipologiaEntity = [dao getTipoEntity:tipologia];
    self.tipoLabel.text = NSLocalizedString(tipologiaEntity.plural,nil);
    self.tipoView.contentMode = UIViewContentModeScaleAspectFit;
    self.tipoView.image = [dao getImageFromTipo:tipologiaEntity];

    self.view.backgroundColor = nil;
}


- (NSArray *)buttons:(ButtonSegmentControl *)buttonSegmentControl{
    if([buttonSegmentControl.tag isEqualToString:@"orderBy"]){
        return segmentOrderBy;
    }
    else if([buttonSegmentControl.tag isEqualToString:@"stili"]){
        return segmentStili;
    }
    return nil;
}


- (void)buttonSegmentControl:(ButtonSegmentControl *)buttonControl  selectedButton:(UIButton *)button selectedIndex:(NSInteger)selectedIndex{
    
    if([buttonControl.tag isEqualToString:@"orderBy"]){
        [self changeOrderBy:selectedIndex];
    }
    else if([buttonControl.tag isEqualToString:@"stili"]){
        [self changeStile:selectedIndex];
    }
}

- (void)initInputType{
    
    //Seleziona ordinamento
    [self.orderBy_gradimento setImage:[dao getImageFromSection:[CurrState shared].currSection type:@"icona_ordina_data"] forState: UIControlStateNormal];
    [self.orderBy_data setImage:[dao getImageFromSection:[CurrState shared].currSection type:@"icona_ordina_gradimento"] forState: UIControlStateNormal];
    
    segmentOrderBy = [[NSArray alloc] initWithObjects:self.orderBy_data,self.orderBy_gradimento, nil];
    orderBy = [[ButtonSegmentControl alloc] init:@"orderBy"];
    orderBy.delegate = self;
    orderBy.selectedIndex = 0;
    
    
    
    //Seleziona Stili
    NSArray *stiliKeys = [dao listStiliKeys];
    Stile *stile;
    stile = [dao getStileEntity:[stiliKeys objectAtIndex:0]];
    [self.stile_1 setImage:[dao getImageFromStile:stile] forState: UIControlStateNormal];
    stile = [dao getStileEntity:[stiliKeys objectAtIndex:1]];
    [self.stile_2 setImage:[dao getImageFromStile:stile] forState: UIControlStateNormal];
    stile = [dao getStileEntity:[stiliKeys objectAtIndex:2]];
    [self.stile_3 setImage:[dao getImageFromStile:stile] forState: UIControlStateNormal]; 

    [self.stile_4 setImage:[dao getImageFromSection:[CurrState shared].currSection type:@"icona_stile_all"] forState: UIControlStateNormal];
    
    segmentStili = [[NSArray alloc] initWithObjects:self.stile_1,self.stile_2,self.stile_3, self.stile_4, nil];
    filterStili = [[ButtonSegmentControl alloc] init:@"stili"];
    filterStili.delegate = self;
    filterStili.selectedIndex = 0;
    
    
    
    
    
    
    
    for(NSString *currStagioneKey in [dao listStagioniKeys]){
        Stagione *stagione = [dao getStagioneEntity:currStagioneKey];
        [segmentcontrol setImage:[dao getImageFromStagione:stagione] forSegmentAtIndex:[stagione.id intValue]];
    }
    
    [segmentcontrol setImage:
     [dao getImageFromSection:[CurrState shared].currSection type:@"icona_stagione_all"] forSegmentAtIndex:[[dao listStagioniKeys] count]];


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
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{

}



-(IBAction)addItem:(id)sender{
    
    if(captureClothController != nil){
        [captureClothController.view removeFromSuperview];
        [captureClothController release];
        captureClothController = nil;
        
    }
    currstate.currSection = SECTION_COVERFLOW;
    
    captureClothController = [[CaptureClothController alloc] initWithNibName:@"CaptureClothController" bundle:nil parentController:self  iterator:NO];
    [self.view addSubview:captureClothController.view];
}
    


-(IBAction)changeStagione:(id)sender{
    
    if(self.view.isUserInteractionEnabled){    
        UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
        NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
        
        
        currstate.currStagioneIndex = [NSNumber numberWithInteger:selectedSegment];
        [self reloadVestiti:nil];
    }    
}


-(void)changeStile:(NSInteger)selectedIndex{
   if(self.view.isUserInteractionEnabled){
    if(selectedIndex < [dao.listStiliKeys count]){
        localCurrStile = [dao.listStiliKeys objectAtIndex:selectedIndex] ;
    }
    else{
        localCurrStile = nil;
    }
    
    currstate.currStile =  localCurrStile;    
    [self reloadVestiti:nil];
   }     
}

-(void)changeOrderBy:(NSInteger)selectedIndex{
    if(self.view.isUserInteractionEnabled){
        NSString *sortKey;
        
        [localCurrOrderBy release];
        localCurrOrderBy = nil;
        if(selectedIndex == 1){
            sortKey = @"gradimento";
            [self addLocalCurrOrderBy:sortKey];
        }
        
        [self reloadVestiti:nil];
    }
}




- (void)addIterator
{
    
    if([currstate.currSection isEqualToString:SECTION_COVERFLOW]){
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
    [CurrState shared].currSection = SECTION_COVERFLOW;
}



-(void) dealloc{
    if(captureClothController != nil){
        [captureClothController release];
    }    
    [localCurrStile release];
    [localCurrOrderBy release];
    [openflow release];
    [vestiti release];
    [addButton release];
    [segmentcontrol release];
    [segmentOrderBy release];
    [segmentStili release];
    [orderBy_data release];
    [orderBy_gradimento release];
    [filterStili release];
    [coverBtn release];
    [coverView release];
    [currstate release];
    [dao release];
    [tipologia release];
    [stagioneKey release];
    [stili release];
    [tipoView release];
    [tipoLabel release];
    [tipologia release];
    [stile_1 release];
    [stile_2 release];
    [stile_3 release];
    [stile_4 release];
    [super dealloc]; 

}

@end
