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
            imageview,
            buttonAddCoverFlow;

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




- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)reloadVestiti:(NSNotification *)pNotification{
   //NSLog(@"currSection: %@",currstate.currSection); 
    [self.view setUserInteractionEnabled:FALSE];
    segmentcontrol.selectedSegmentIndex = [currstate.currStagioneIndex intValue];
    
    [self.view setUserInteractionEnabled:TRUE];
    
    [self reloadVestiti];
    
    /*
    if(
       ([currstate.currSection isEqualToString:SECTION_COVERFLOW])
       ||
       ([currstate.oldCurrSection isEqualToString:SECTION_COVERFLOW]) 
       ) 
    {
        if([pNotification.name isEqualToString:ADD_CLOTH_EVENT]){
            [self addIterator];
        }
    }  */  
}

- (void)reloadVestiti{
    
    
    [self addLocalCurrOrderBy:@"id"];
    
    [self.openflow emptyCache];
    

    
    if(vestiti != nil){
        [vestiti release];
        vestiti = nil;
    }
    
    
    vestiti = [dao getVestitiEntities:[NSArray arrayWithObjects:tipologia,nil] filterStagioneKey:currstate.currStagioneKey filterStiliKeys:[[[NSArray alloc] initWithObjects:localCurrStile, nil] autorelease] filterGradimento:-1 sortOnKeys:localCurrOrderBy preferiti:NO];
    
    [vestiti retain];
    [self.openflow draw];
        
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[Tutorial shared] actionInfo:ACTION_COVERFLOW];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dao = [IarmadioDao shared];
    currstate = [CurrState shared];
    [self initInputType];
    
    
    if(currstate.currStagioneIndex == nil){currstate.currStagioneIndex = [NSNumber numberWithInt:0];}
    
    
    self.navigationItem.titleView = segmentcontrol;
    
    
    
    self.navigationItem.rightBarButtonItem = self.addButton;
    
    localCurrStile = nil;
    localCurrOrderBy = nil;
    
    [self.view setUserInteractionEnabled:FALSE];
    segmentcontrol.selectedSegmentIndex = [currstate.currStagioneIndex intValue];
    [self.view setUserInteractionEnabled:TRUE];
    [self reloadVestiti:nil];
    
    
    
    Tipologia *tipologiaEntity = [dao getTipoEntity:tipologia];
    self.tipoLabel.text = NSLocalizedString(tipologiaEntity.plural,nil);
    self.tipoView.contentMode = UIViewContentModeScaleAspectFit;
    self.tipoView.image = [dao getImageFromTipo:tipologiaEntity];

    self.view.backgroundColor = nil;
    
    self.imageview.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.imageview.bounds].CGPath;
    self.imageview.layer.shadowColor = [UIColor grayColor].CGColor;
    self.imageview.layer.shadowOffset = CGSizeMake(0, -7);
    self.imageview.layer.shadowOpacity = 1;
    self.imageview.layer.shadowRadius = 3.0;
    }


- (NSArray *)buttons:(ButtonSegmentControl *)buttonSegmentControl{
    if([buttonSegmentControl.tag isEqualToString:@"orderBy"]){
        return segmentOrderBy;
    }

    return nil;
}


- (void)buttonSegmentControl:(ButtonSegmentControl *)buttonControl  selectedButton:(UIButton *)button selectedIndex:(NSInteger)selectedIndex{
    
    if([buttonControl.tag isEqualToString:@"orderBy"]){
        [self changeOrderBy:selectedIndex];
    }
}

- (void)initInputType{
    
    
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
    
    

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    /*
        if(captureClothController != nil){
            [captureClothController.view removeFromSuperview];
            [captureClothController release];
            captureClothController = nil;
        }
        captureClothController = [[CaptureClothController alloc] initWithNibName:@"CaptureClothController" bundle:nil parentController:self  iterator:YES];
        [self.view addSubview:captureClothController.view];
    */ 
}


- (int)flowCoverNumberImages:(FlowCoverView *)view
{
    [self.buttonAddCoverFlow setHidden:YES];
    if([vestiti count] == 0){
        [self.buttonAddCoverFlow setHidden:NO];
    }
	return [vestiti count];
}

- (UIImage *)flowCover:(FlowCoverView *)view cover:(int)image
{
    
    if([vestiti count] <= image){
        return [[[UIImage alloc] init] autorelease];
    }
    return [dao getThumbnailWithInfoFromVestito:[vestiti objectAtIndex:image]];
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




-(void) dealloc{
    //NSLog(@"Dealloc coverview!!!");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(captureClothController != nil){
        [captureClothController release];
    }    
    [localCurrStile release];
    
    [localCurrOrderBy release];
    if(vestiti != nil){
        [vestiti release];
    }
    [imageview release];
    [buttonAddCoverFlow release];
    [addButton release];
    [segmentcontrol release];
    [segmentOrderBy release];
    [segmentStili release];
    [orderBy release];
    [orderBy_data release];
    [orderBy_gradimento release];
    [filterStili release];
    [coverBtn release];
    [coverView release];
    [stagioneKey release];
    [stili release];
    [tipoView release];
    [tipologia release];
    [tipoLabel release];
    [stile_1 release];
    [stile_2 release];
    [stile_3 release];
    [stile_4 release];
    [openflow release];
    [super dealloc]; 
    
}

@end
