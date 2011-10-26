//
//  CreateViewController.m
//  iArmadio
//
//  Created by William Pompei on 03/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClothManagerViewController.h"

@implementation ClothManagerViewController
@synthesize navcontroler,addItemBtn, modifyBtn, tipologia, imageview;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    return self;
}


- (IBAction) modify:(id) sender{
   

}

-(IBAction)addItem:(id)sender{
    if(captureClothController != nil){
        [captureClothController.view removeFromSuperview];
        [captureClothController release];
        captureClothController = nil;
        
    }
    [CurrState shared].currSection = SECTION_ARMADIO;
    captureClothController = [[CaptureClothController alloc] initWithNibName:@"CaptureClothController" bundle:nil parentController:self  iterator:NO];
    [self.view addSubview:captureClothController.view];
}


- (void)addIterator:(NSNotification *)notification
{
   
    if(
       ([currstate.oldCurrSection isEqualToString:SECTION_ARMADIO])||
       ([currstate.currSection isEqualToString:SECTION_ARMADIO]) 
        )
        
    {
        
        if(captureClothController != nil){
            [captureClothController.view removeFromSuperview];
            [captureClothController release];
            captureClothController = nil;
        }
        captureClothController = [[CaptureClothController alloc] initWithNibName:@"CaptureClothController" bundle:nil parentController:self  iterator:YES];
        [self.view addSubview:captureClothController.view];
    }
    
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [CurrState shared].currSection = SECTION_CLOTHMANAGERVIEW;
    navcontroler.delegate = self; 
    dao = [IarmadioDao shared];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[dao getImageFromSection:[CurrState shared].currSection type:@"background"]];
    currstate = [CurrState shared];
    [self.view addSubview:navcontroler.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addIterator:) name:ADD_CLOTH_EVENT object:nil];
    
    self.imageview.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.imageview.bounds].CGPath;
    self.imageview.layer.shadowColor = [UIColor grayColor].CGColor;
    self.imageview.layer.shadowOffset = CGSizeMake(7, 1);
    self.imageview.layer.shadowOpacity = 1;
    self.imageview.layer.shadowRadius = 3.0;
    
}




- (void)viewWillAppear:(BOOL)animated{
    
    [CurrState shared].currSection = SECTION_CLOTHMANAGERVIEW;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return NO;
}




- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}





- (void)viewDidUnload
{

    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [tipologia release];
    [addItemBtn release];
    [modifyBtn release];
    [navcontroler release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
@end
