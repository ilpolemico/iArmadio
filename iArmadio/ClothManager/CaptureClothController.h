//
//  CaptureClothController.h
//  iArmadio
//
//  Created by Casa Fortunato on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iArmadioAppDelegate.h"
#import "ClothViewController.h"

@interface CaptureClothController : UIViewController <UIScrollViewDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    
    BOOL iterator;
    UIViewController *viewController;

}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parentController:(UIViewController *)viewController iterator:(BOOL)_iterator;

@end
