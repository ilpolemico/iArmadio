//
//  CreateViewController.m
//  iArmadio
//
//  Created by Luca Fortunato
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
    captureClothController = [[CaptureClothController alloc] initWithNibName:@"CaptureClothController" bundle:nil parentController:self  iterator:NO];
    [self.view addSubview:captureClothController.view];
}


/*
- (void)addIterator:(NSNotification *)notification
{
   
    
    if(
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
 */




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    navcontroler.delegate = self; 
    dao = [IarmadioDao shared];
    [self.view addSubview:navcontroler.view];
    
}




- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"flushCache");
    [dao flushCacheImage];
    // Release any cached data, images, etc. that aren't in use.
}





- (void)viewDidUnload
{

    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





- (void)dealloc {
    if(captureClothController != nil){
        [captureClothController release];
        captureClothController = nil;
    }

    [tipologia release];
    [addItemBtn release];
    [modifyBtn release];
    [navcontroler release];
    [imageview release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
@end
