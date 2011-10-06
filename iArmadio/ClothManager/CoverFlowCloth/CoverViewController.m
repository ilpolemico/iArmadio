//
//  ImageItemViewController.m
//  iArmadio
//
//  Created by Casa Fortunato on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoverViewController.h"
#import "NYXImagesUtilities.h"

 

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
    
    [self.openflow removeFromSuperview];
    [openflow release];
    openflow = [[AFOpenFlowView alloc] initWithFrame:CGRectMake(0,-100,frameCover.size.width,frameCover.size.height)];
    
    
    [self reloadVestiti];
    
     
    
    [self.openflow centerOnSelectedCover:YES];
    [self.coverView addSubview:self.openflow];
    
    if([pNotification.name isEqualToString:ADD_CLOTH_EVENT]){
        [self addIterator];
    }
    
}

- (void)reloadVestiti{
    
    
    
    if(currstate.currStagioneIndex == nil){
        currstate.currStagioneIndex = [NSNumber numberWithInteger:0];
        //self.segmentcontrol.selectedSegmentIndex = 0;
    }
    else{
        //self.segmentcontrol.selectedSegmentIndex = [currstate.currStagioneIndex integerValue];
    }
    
   
    [self addLocalCurrOrderBy:@"id"];
        
    currstate.currStagioneIndex = [NSNumber numberWithInt:self.segmentcontrol.selectedSegmentIndex];
    
    
    if(vestiti != nil){
        [vestiti release];
    }
    
    vestiti = [dao getVestitiEntities:[NSArray arrayWithObjects:tipologia,nil] filterStagioneKey:currstate.currStagioneKey filterStiliKeys:[[[NSArray alloc] initWithObjects:localCurrStile, nil] autorelease] filterGradimento:-1 sortOnKeys:localCurrOrderBy];

    [vestiti retain];
    [self.openflow setNumberOfImages:0];
    for (int i=0; i < [vestiti count]; i++) {
        UIImage *image = [dao getImageFromVestito:[vestiti objectAtIndex:i]];
        [self.openflow setImage:image  forIndex:i];
	}
    
    [self.openflow setNumberOfImages:[vestiti count]];
    
    if([vestiti count] == 0){
         UIImage *image = [UIImage imageWithContentsOfFile:
                            [
                             [[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"02.png"
                             ]
                           ];

        [self.openflow setImage:image  forIndex:0];
        imageSelected = -1;
        [self.openflow setNumberOfImages:1];
    }
    else{
        [self.openflow setSelectedCover:[vestiti count]-1];
        imageSelected = [vestiti count]-1;
    }
    
	    
    self.openflow.viewDelegate = self;
    
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dao = [IarmadioDao shared];
    currstate = [CurrState shared];
    self.navigationItem.titleView = segmentcontrol;
    frameCover = self.openflow.frame;
    
    self.navigationItem.rightBarButtonItem = self.addButton;
    loadImagesOperationQueue = [[NSOperationQueue alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVestiti:) name:ADD_CLOTH_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVestiti:) name:DEL_CLOTH_EVENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVestiti:) name:MOD_CLOTH_EVENT object:nil];
    
    localCurrStile = nil;
    localCurrOrderBy = nil;
    
    [self.view setUserInteractionEnabled:FALSE];
    segmentOrderBy.selectedSegmentIndex = 0;
    segmentfiltroStile.selectedSegmentIndex = 3;
    segmentOrderBy.enabled = YES;
    segmentfiltroStile.enabled = YES;
    [self.view setUserInteractionEnabled:TRUE];
    [self reloadVestiti:[[NSNotification alloc] autorelease]];
    [self.openflow centerOnSelectedCover:YES];
    currstate.currSection = @"COVERCLOTH";
}

- (void)imageTap{
    if([vestiti count] > 0){
        ClothViewController *getviewcontroller = [[ClothViewController alloc] initWithNibName:@"ClothView" bundle:nil getVestito: [vestiti objectAtIndex:imageSelected]];
        
        iArmadioAppDelegate *appDelegate = (iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        getviewcontroller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [appDelegate.tabBarController presentModalViewController:getviewcontroller animated:YES];
        [getviewcontroller release];

        
    }
    
}

// delegate protocol to tell which image is selected
- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index{
    
	imageSelected = index;
    
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView touchImageCoverSelected:(int)index{
   [coverBtn setHidden:NO];
   coverBtn.enabled = YES; 
   coverBtn.selected = YES; 
   [self imageTap];
   coverBtn.enabled = NO; 
   coverBtn.selected = NO;
   [coverBtn setHidden:YES];
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView requestImageForIndex:(int)index {
    
}


// setting the image 1 as the default pic
- (UIImage *)defaultImage{
    
	return [UIImage imageNamed:@"2011-09-09-04-01-11.png"];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)addItem:(id)sender{
    
    UIActionSheet *popupAddItem = [[UIActionSheet alloc] initWithTitle:@"Aggiungi vestito" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Fotocamera", @"Album", nil];
    
    popupAddItem.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    iArmadioAppDelegate *appDelegate = (iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [popupAddItem showInView:appDelegate.window.rootViewController.view];
    [popupAddItem release];
    
}


-(IBAction)changeStagione:(id)sender{
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    
    ([CurrState shared]).currStagioneIndex = [NSNumber numberWithInteger:selectedSegment];
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


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    iArmadioAppDelegate *appDelegate = (iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    if (buttonIndex == 0) {
        #if !(TARGET_IPHONE_SIMULATOR)
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        #else
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        #endif
       
        [appDelegate.window.rootViewController presentModalViewController:picker animated:YES];
        [picker release];
    }
    else if (buttonIndex == 1) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //picker.allowsEditing = YES;
        [appDelegate.window.rootViewController presentModalViewController:picker animated:YES];
        [picker release];
    } 
   
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
	[picker dismissModalViewControllerAnimated:NO];
    ClothViewController *addviewcontroller = [[ClothViewController alloc] initWithNibName:@"ClothView" bundle:nil setImage: image];
    
    addviewcontroller.currTipologia = tipologia;
    
    addviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    iArmadioAppDelegate *appDelegate = (iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate];

    
    [appDelegate.tabBarController presentModalViewController:addviewcontroller animated:YES];
    [addviewcontroller release];
	//imageView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
}



- (void)addIterator
{
        
         iArmadioAppDelegate *appDelegate = (iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
        UIActionSheet *popupAddItem = [[UIActionSheet alloc] initWithTitle:@"Aggiungi altro vestito" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Fotocamera", @"Album", nil];
        
        popupAddItem.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [popupAddItem showInView:appDelegate.window.rootViewController.view];
        [popupAddItem release];
    
}





-(void) dealloc{
    [openflow release];
    [vestiti release];
    [super dealloc]; 

}

@end
