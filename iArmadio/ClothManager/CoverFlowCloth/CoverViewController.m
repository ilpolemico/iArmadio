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
            casual,
            sportivo,
            elegante,
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




- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)reloadVestiti:(NSNotification *)pNotification{
    
    //[self.openflow removeFromSuperview];
    //self.openflow = [[AFOpenFlowView alloc] initWithFrame:CGRectMake(0,-100,frameCover.size.width,frameCover.size.height)];
    [self reloadVestiti];
    [self.openflow setSelectedCover:[vestiti count]-1];
     
    imageSelected = [vestiti count]-1;
    [self.openflow centerOnSelectedCover:YES];
    //[self.coverView addSubview:self.openflow];
}

- (void)reloadVestiti{
    if(vestiti != nil){
        [vestiti release];
    }
    
    
    if(currstate.currStagioneIndex == nil){
        currstate.currStagioneIndex = [NSNumber numberWithInteger:0];
        //self.segmentcontrol.selectedSegmentIndex = 0;
    }
    else{
        //self.segmentcontrol.selectedSegmentIndex = [currstate.currStagioneIndex integerValue];
    }
    
    
    NSMutableArray *sort = [[[NSMutableArray alloc] init] autorelease];
    NSMutableDictionary *key = [[[NSMutableDictionary alloc] init] autorelease];
    [key setObject:@"gradimento" forKey:@"field"];
    [key setObject:@"YES" forKey:@"ascending"];
    [sort addObject:key];
    
    
    currstate.currStagioneIndex = [NSNumber numberWithInt:self.segmentcontrol.selectedSegmentIndex];
    vestiti = [dao getVestitiEntities:[NSArray arrayWithObjects:tipologia,nil] filterStagioneKey:currstate.currStagioneKey filterStiliKeys:stili filterGradimento:-1 sortOnKeys:sort];
	[vestiti retain];
    
    
    //NSLog(@"%@ - %d",vestiti,[vestiti count]);
    
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
    
    [self reloadVestiti];
    
    imageSelected = 0;
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
   [self imageTap];
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

-(IBAction)changeStili:(id)sender{
    
    if(stili != nil){
        [stili release];
    }
    
    stili = [[NSMutableArray alloc] init];
    if(casual.on){
        [stili addObject:@"casual"];
    }
    if(sportivo.on){
        [stili addObject:@"sportivo"]; 
    }
    if(elegante.on){
        [stili addObject:@"elegante"]; 
    } 

    [self reloadVestiti:nil];

}

-(IBAction)changeStagione:(id)sender{
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    
    ([CurrState shared]).currStagioneIndex = [NSNumber numberWithInteger:selectedSegment];
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

-(void) dealloc{
    [super dealloc]; 

}

@end
