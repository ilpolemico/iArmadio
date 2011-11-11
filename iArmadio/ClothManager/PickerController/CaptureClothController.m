//
//  CaptureClothController.m
//  iArmadio
//
//  Created by Casa Fortunato on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CaptureClothController.h"

@implementation CaptureClothController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parentController:(UIViewController*)_viewController  iterator:(BOOL)_iterator
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        iterator = _iterator;
        viewController = _viewController;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [CurrState shared].currSection = DISABLE_SHAKE;
    NSString *title = NSLocalizedString(@"Aggiungi vestito",nil);
    if(iterator){title = NSLocalizedString(@"Aggiungi un altro vestito",nil);}
    
    UIActionSheet *popupAddItem = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Fotocamera",nil), NSLocalizedString(@"Album",nil), nil];
    
    popupAddItem.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [popupAddItem showInView:((iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate]).window];
    [popupAddItem release];
    
    
    // Do any additional setup after loading the view from its nib.
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


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *picker = nil;
    
    if(buttonIndex != 2){
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
    }    
    
    
    if (buttonIndex == 0) {
#if !(TARGET_IPHONE_SIMULATOR)
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
#else
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#endif

        [((iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate]).tabBarController presentModalViewController:picker animated:YES];
        [picker release];
    }
    else if (buttonIndex == 1) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [((iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate]). tabBarController presentModalViewController:picker animated:YES];
        [picker release];
    } 
    else{
        [self dismissModalViewControllerAnimated:YES];
        [CurrState shared].currSection = ENABLE_SHAKE;
    }    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo 
{
   [picker dismissModalViewControllerAnimated:NO];
    
    ClothViewController *addviewcontroller = [[ClothViewController alloc] initWithNibName:@"ClothView" bundle:nil setImage: image];
  

    [((iArmadioAppDelegate *)[[UIApplication sharedApplication] delegate]).tabBarController presentModalViewController:addviewcontroller animated:YES];
    [addviewcontroller release];
     
    
}


-(void)dealloc{
    [super dealloc];
}


@end
