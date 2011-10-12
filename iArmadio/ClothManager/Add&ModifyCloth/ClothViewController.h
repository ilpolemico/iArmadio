//
//  SecondViewController.h
//  iArmadio
//
//  Created by William Pompei on 03/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYXImagesHelper.h"
#import "NYXImagesUtilities.h"
#import "SelectTypeViewController.h"
#import "IarmadioDao.h"
#import "ClothTableViewController.h"


@class SelectTypeViewController;

@interface ClothViewController : UIViewController <UIScrollViewDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate> {
    
    SelectTypeViewController *selectController;
    UIImageView * imageView;
    IarmadioDao *dao;
    UIImage *newimage;
    Vestito *vestito;
    IBOutlet UIScrollView *scrollview;
    IBOutlet UINavigationBar *addNavigationBar;
    IBOutlet UIBarButtonItem *saveButton;
    IBOutlet UIBarButtonItem *undoButton;
    IBOutlet UIButton *tipologiaBtn;
    IBOutlet UILabel *tipologiaLabel;
    
    IBOutlet UISegmentedControl *stagione;
    IBOutlet UISegmentedControl *gradimento;
    IBOutlet UISegmentedControl *stile;
    
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIBarButtonItem *trash;
    
    NSString *currTipologia;
    NSString *currStile;
    NSString *currGradimento;
    NSString *currStagione;
    
    
    BOOL addCloth;
    BOOL modifyImageCloth;
    int lastScaleFactor, netRotation;
      
}

@property (nonatomic, retain ) IBOutlet NSString *currStile;
@property (nonatomic, retain ) IBOutlet NSString *currTipologia;
@property (nonatomic, retain ) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain ) IBOutlet UIBarButtonItem *trash;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollview;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * saveButton;
@property (nonatomic, retain) IBOutlet UINavigationBar* addNavigationBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * undoButton;


@property (nonatomic, retain) IBOutlet IBOutlet UIButton *tipologiaBtn;
@property (nonatomic, retain) IBOutlet IBOutlet UILabel  *tipologiaLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *stagione;
@property (nonatomic, retain) IBOutlet UISegmentedControl *gradimento;
@property (nonatomic, retain) IBOutlet UISegmentedControl *stile;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil setImage:(UIImage *)image;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil getVestito:(Vestito *)vestito;

-(IBAction) selectTipo:(id) sender;
-(IBAction) selectImage:(id) sender;
-(IBAction) saveCloth:(id) sender;
-(IBAction) deleteCloth:(id) sender;
-(IBAction) undoCloth:(id) sender;
-(IBAction) segmentSwitch:(id)sender;
-(void)initStagioniEntities:(NSNumber *)stagioneKey;
-(void) initInputType;




@end


