//
//  CreateViewController.m
//  iArmadio
//
//  Created by William Pompei on 03/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClothManagerViewController.h"

@implementation ClothManagerViewController
@synthesize navcontroler,addItemBtn, modifyBtn, tipologia;





- (IBAction) modify:(id) sender{
   

}

-(IBAction)addItem:(id)sender{
    
    UIActionSheet *popupAddItem = [[UIActionSheet alloc] initWithTitle:@"Aggiungi vestito" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Fotocamera", @"Album", nil];
  
    popupAddItem.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupAddItem showInView:self.tabBarController.view];
    [popupAddItem release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
       
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;

    
    if (buttonIndex == 0) {
            #if !(TARGET_IPHONE_SIMULATOR)
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            #else
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            #endif
          [self presentModalViewController:picker animated:YES];
          [picker release];
    }
    else if (buttonIndex == 1) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //picker.allowsEditing = YES;
        [self presentModalViewController:picker animated:YES];
        [picker release];
        
    } 
  }

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo 
    {
	[picker dismissModalViewControllerAnimated:NO];
    
    ClothViewController *addviewcontroller = [[ClothViewController alloc] initWithNibName:@"ClothView" bundle:nil setImage: image];
    
    //addviewcontroller.currTipologia = tipologia;
    [self presentModalViewController:addviewcontroller animated:YES];
    [addviewcontroller release];
       
        
	//imageView.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    dao = [IarmadioDao shared];
    [self.view addSubview:navcontroler.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addIterator:) name:ADD_CLOTH_EVENT object:nil];
    
}


- (void)viewWillAppear:(BOOL)animated{
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)addIterator:(NSNotification *)notification
{
    
    
    UIActionSheet *popupAddItem = [[UIActionSheet alloc] initWithTitle:@"Aggiungi altro vestito" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Fotocamera", @"Album", nil];
    
    popupAddItem.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupAddItem showInView:self.view];
    [popupAddItem release];
    
}

- (void)viewDidUnload
{

    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
   
    [super dealloc];
}
@end
