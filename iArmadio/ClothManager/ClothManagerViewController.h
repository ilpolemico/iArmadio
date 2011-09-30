//
//  CreateViewController.h
//  iArmadio
//
//  Created by William Pompei on 03/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iArmadioAppDelegate.h"
#import "ClothViewController.h"
#import "ClothTableViewController.h"



@interface ClothManagerViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{

    
    IarmadioDao *dao;
    IBOutlet UINavigationController *navcontroler;
    IBOutlet ClothTableViewController *tableviewcontroller;
    IBOutlet UIBarButtonItem *addItemBtn;
    IBOutlet UIBarButtonItem *modifyBtn;
    Tipologia *tipologia;

  
}

@property (nonatomic, retain) Tipologia *tipologia;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *addItemBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *modifyBtn;
@property(nonatomic,retain, readonly) IBOutlet UINavigationController *navcontroler;
@property(nonatomic,retain, readonly) IBOutlet ClothTableViewController *tableviewcontroller;



- (IBAction) addItem:(id) sender;
- (IBAction) modify:(id) sender;

@end
