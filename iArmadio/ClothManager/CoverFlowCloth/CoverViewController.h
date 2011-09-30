//
//  ImageItemViewController.h
//  iArmadio
//
//  Created by Casa Fortunato on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "AFOpenFlowView.h"
#import <QuartzCore/QuartzCore.h> 
#import "IarmadioDao.h"
#import "ClothViewController.h"
#import "iArmadioAppDelegate.h"
#import "FileSystem.h"

@interface CoverViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    AFOpenFlowViewDataSource, AFOpenFlowViewDelegate>{

        
    NSOperationQueue *loadImagesOperationQueue;
    IarmadioDao *dao;
    NSString *tipologia;
    IBOutlet UIBarButtonItem *addButton;
    int imageSelected;
    NSArray *vestiti;
    IBOutlet AFOpenFlowView *openflow;    
    
}

@property (retain, nonatomic) IBOutlet AFOpenFlowView *openflow;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *addButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil getTipologia:(NSString *)_tipologia;

- (void)reloadVestiti; 

- (IBAction) addItem:(id) sender;

@end
