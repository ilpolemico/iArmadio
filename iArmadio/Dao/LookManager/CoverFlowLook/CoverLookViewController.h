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

@interface CoverLookViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    AFOpenFlowViewDataSource, AFOpenFlowViewDelegate>{

        
    NSOperationQueue *loadImagesOperationQueue;
    IarmadioDao *dao;
    NSString *tipologia;
    NSString *stagioneKey;
    NSMutableArray *stili;
    IBOutlet UIBarButtonItem *addButton;
    IBOutlet UISegmentedControl *segmentcontrol;
    int imageSelected;
    NSArray *vestiti;
    IBOutlet AFOpenFlowView *openflow;  
    IBOutlet UIView *coverView;
    IBOutlet UISwitch *casual;
    IBOutlet UISwitch *sportivo;
    IBOutlet UISwitch *elegante;
        
    CurrState *currstate;
}

@property (retain, nonatomic) IBOutlet AFOpenFlowView *openflow;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentcontrol;
@property (nonatomic, retain) IBOutlet UISwitch *casual;
@property (nonatomic, retain) IBOutlet UISwitch *sportivo;
@property (nonatomic, retain) IBOutlet UISwitch *elegante;
@property (nonatomic, retain) IBOutlet UIView *coverView;





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil getTipologia:(NSString *)_tipologia;

- (void)reloadVestiti; 

- (IBAction) addItem:(id) sender;
- (IBAction) changeStagione:(id) sender;
- (IBAction) changeStili:(id) sender;

@end
