//
//  CreateViewController.m
//  iArmadio
//
//  Created by William Pompei on 03/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClothManagerViewController.h"

@implementation ClothManagerViewController
@synthesize navcontroler,tableviewcontroller, addItemBtn, modifyBtn;



/*
- (UIView *) clothHigh1{
    if(clothHigh1 == nil){
        CGSize size = CGSizeMake(100.0f,100.0f); 
        ScrollImagesController *scrollcontroller = (ScrollImagesController *)[[ScrollImagesController alloc ]initWithNibName:@"ScrollImagesController" bundle:nil listCoth:[appDelegate.dao getCamicie] size:size];
            clothHigh1 = scrollcontroller.view;
  
    }
    [clothHigh1 retain];
    return clothHigh1;
}

- (UIView *) clothHigh2{
    if(clothHigh2 == nil){
        CGSize size = CGSizeMake(100.0f,100.0f); 
        ScrollImagesController *scrollcontroller = (ScrollImagesController *)[[ScrollImagesController alloc ]initWithNibName:@"ScrollImagesController" bundle:nil listCoth:[appDelegate.dao getCamicie] size:size];
        clothHigh2 = scrollcontroller.view; 
        
    }
    [clothHigh2 retain];
    return clothHigh2;
}


- (UIView *) clothHigh3{
    if(clothHigh3 == nil){
        CGSize size = CGSizeMake(100.0f,100.0f); 
        ScrollImagesController *scrollcontroller = (ScrollImagesController *)[[ScrollImagesController alloc ]initWithNibName:@"ScrollImagesController" bundle:nil listCoth:[appDelegate.dao getCamicie] size:size];
        clothHigh3 = scrollcontroller.view; 
        
    }
    [clothHigh3 retain];
    return clothHigh3;
}


- (UIView *) clothMiddle{
    if(clothMiddle == nil){
        CGSize size = CGSizeMake(100.0f,100.0f); 
        ScrollImagesController *scrollcontroller = (ScrollImagesController *)[[ScrollImagesController alloc ]initWithNibName:@"ScrollImagesController" bundle:nil listCoth:[appDelegate.dao getPantaloni] size:size];
        clothMiddle = scrollcontroller.view; 
        
    }
    [clothMiddle retain];
    return clothMiddle;
}


- (UIView *) clothBottom{
    if(clothBottom == nil){
        CGSize size = CGSizeMake(100.0f,100.0f); 
        ScrollImagesController *scrollcontroller = (ScrollImagesController *)[[ScrollImagesController alloc ]initWithNibName:@"ScrollImagesController" bundle:nil listCoth:[appDelegate.dao getPantaloni] size:size];
        clothBottom = scrollcontroller.view; 
    }
    [clothBottom retain];
    return clothBottom;
}

*/

- (IBAction) modify:(id) sender{
    NSLog(@"modifica!");

}

-(IBAction)addItem:(id)sender{
    
    UIActionSheet *popupAddItem = [[UIActionSheet alloc] initWithTitle:@"Aggiungi vestito" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Fotocamera", @"Album", nil];
  
    popupAddItem.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupAddItem showInView:self.tabBarController.view];
    [popupAddItem release];

    
    /*
    AddDressViewController *addItemController = [[AddDressViewController alloc ]initWithNibName:@"AddDressView" bundle:nil ];
    
    
    
    CGFloat start_y_view = self.view.frame.size.height+addItemController.view.frame.size.height;
    CGFloat start_x_view = 0;
    
    CGFloat end_y_view = 0;    
    CGFloat end_x_view = 0;
    
    
    addItemController.view.frame = CGRectMake(start_x_view,start_y_view, addItemController.view.frame.size.width , addItemController.view.frame.size.height);
    
    
    [self.view addSubview:addItemController.view];
    
    [UIView animateWithDuration:1.0 animations:^{
		addItemController.view.frame = CGRectMake(end_x_view,end_y_view, addItemController.view.frame.size.width , addItemController.view.frame.size.height);
		addItemController.view.alpha = 1;
	}];
    */ 
     
    //[addItemController autorelease]; 
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
       
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;

    if (buttonIndex == 0) {
          picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
          //picker.sourceType = UIImagePickerControllerSourceTypeCamera;
          picker.allowsEditing = YES;
          [self presentModalViewController:picker animated:YES];
          [picker release];
    }
    else if (buttonIndex == 1) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    } 
    

  
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:NO];
    
    ClothViewController *addviewcontroller = [[ClothViewController alloc] initWithNibName:@"ClothView" bundle:nil setImage: [info objectForKey:@"UIImagePickerControllerEditedImage"]];
    
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
