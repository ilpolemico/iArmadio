//
//  ImageItemViewController.h
//  iArmadio
//
//  Created by Casa Fortunato on 27/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FlowCoverView.h"

#import "IarmadioDao.h"
#import "ClothViewController.h"
#import "iArmadioAppDelegate.h"
#import "FileSystem.h"
#import "CaptureClothController.h"
#import "NYXImagesUtilities.h"
#import "ButtonSegmentControl.h"

@class CaptureClothController;

@interface CoverViewController : UIViewController<FlowCoverViewDelegate, ButtonSegmentDelegate>{
    IarmadioDao *dao;
    NSString *tipologia;
    NSString *stagioneKey;
    NSMutableArray *stili;
    IBOutlet UIBarButtonItem *addButton;

    IBOutlet UISegmentedControl *segmentControl;
    int imageSelected;
    NSArray *vestiti;
    IBOutlet FlowCoverView *openflow;    
    IBOutlet UIView *coverView;
    IBOutlet UIButton *coverBtn;
    NSString *localCurrStile;  
    NSMutableArray *localCurrOrderBy; 
    CurrState *currstate;
    CaptureClothController *captureClothController;
    
    
    //Label
    IBOutlet UIImageView *tipoView;
    IBOutlet UILabel *tipoLabel;
    
    
    //Ordinamento
    ButtonSegmentControl *orderBy;
    NSArray *segmentOrderBy;
    IBOutlet UIButton *orderBy_data;
    IBOutlet UIButton *orderBy_gradimento;
    
    
    //Stili
    ButtonSegmentControl *filterStili;
    NSArray *segmentStili;
    IBOutlet UIButton *stile_1;
    IBOutlet UIButton *stile_2;
    IBOutlet UIButton *stile_3;
    IBOutlet UIButton *stile_4;
    
    IBOutlet UILabel *ordinaLabel;
    
    IBOutlet UIImageView *imageview;
    
    
}

@property (retain, nonatomic) IBOutlet UIImageView *tipoView;
@property (retain, nonatomic) IBOutlet UILabel *tipoLabel;
@property (retain, nonatomic) IBOutlet UILabel *ordinaLabel;
@property (retain, nonatomic) NSString *tipologia;

@property (retain, nonatomic) IBOutlet UIButton *orderBy_data;
@property (retain, nonatomic) IBOutlet UIButton *orderBy_gradimento;

@property (retain, nonatomic) IBOutlet UIButton *stile_1;
@property (retain, nonatomic) IBOutlet UIButton *stile_2;
@property (retain, nonatomic) IBOutlet UIButton *stile_3;
@property (retain, nonatomic) IBOutlet UIButton *stile_4;

@property (retain, nonatomic) IBOutlet UIButton *coverBtn;
@property (retain, nonatomic) IBOutlet FlowCoverView *openflow;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentcontrol;

@property (nonatomic, retain) IBOutlet UIView *coverView;
@property (nonatomic, retain) IBOutlet UIImageView *imageview;

@property (nonatomic, retain) IBOutlet NSString *localCurrStile;
@property (nonatomic, retain, readonly) IBOutlet NSMutableArray *localCurrOrderBy;




- (void)initInputType;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil getTipologia:(NSString *)_tipologia;

- (void)reloadVestiti; 
- (void)addIterator; 

- (IBAction) addItem:(id) sender;
- (IBAction) changeStagione:(id)sender;
- (void) changeStile:(NSInteger) selectedIndex;
- (void) changeOrderBy:(NSInteger) selectedIndex;
-(void)removeNotification;


@end
