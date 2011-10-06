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
    NSString *stagioneKey;
    NSMutableArray *stili;
    IBOutlet UIBarButtonItem *addButton;
    IBOutlet UISegmentedControl *segmentcontrol;
    IBOutlet UISegmentedControl *segmentOrderBy;
    IBOutlet UISegmentedControl *segmentfiltroStile;
    int imageSelected;
    NSArray *vestiti;
    IBOutlet AFOpenFlowView *openflow;  
    IBOutlet UIView *coverView;
    IBOutlet UIButton *coverBtn;
    NSString *localCurrStile;  
    NSMutableArray *localCurrOrderBy; 
    BOOL addIterator;    
        
    CurrState *currstate;
}

@property (retain, nonatomic) IBOutlet UIButton *coverBtn;
@property (retain, nonatomic) IBOutlet AFOpenFlowView *openflow;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentcontrol;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentOrderBy;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentfiltroStile;
@property (nonatomic, retain) IBOutlet UIView *coverView;

@property (nonatomic, retain) IBOutlet NSString *localCurrStile;
@property (nonatomic, retain, readonly) IBOutlet NSMutableArray *localCurrOrderBy;





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil getTipologia:(NSString *)_tipologia;

- (void)reloadVestiti; 
- (void)addIterator; 

- (IBAction) addItem:(id) sender;
- (IBAction) changeStagione:(id) sender;
- (IBAction) changeStile:(id) sender;
- (IBAction) changeOrderBy:(id) sender;

@end
