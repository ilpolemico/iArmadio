//
//  SecondViewController.h
//  iArmadio
//
//  Created by William Pompei on 03/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYXImagesUtilities.h"
#import "iArmadioAppDelegate.h"
#import "IarmadioDao.h"
#import "ClothTableViewController.h"
#import "ImageItemViewController.h"

@interface ClothViewController : UIViewController <UIScrollViewDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    UIImageView * imageView;
    IarmadioDao *dao;
    UIImage *newimage;
    Vestito *vestito;
    IBOutlet UIScrollView *scrollview;
    IBOutlet UINavigationBar *addNavigationBar;
    IBOutlet UIBarButtonItem *saveButton;
    IBOutlet UIBarButtonItem *undoButton;
    IBOutlet UISegmentedControl *tipologia;
    IBOutlet UISegmentedControl *stagione;
    IBOutlet UISegmentedControl *gradimento;
    IBOutlet UISwitch *casual;
    IBOutlet UISwitch *sportivo;
    IBOutlet UISwitch *elegante;
    
    
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIBarButtonItem *trash;
    
    NSString *currTipologia;
    NSString *currStile;
    NSArray *tipologie;
    BOOL addCloth;
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
@property (nonatomic, retain) IBOutlet UISegmentedControl *tipologia;
@property (nonatomic, retain) IBOutlet UISegmentedControl *stagione;
@property (nonatomic, retain) IBOutlet UISegmentedControl *gradimento;

@property (nonatomic, retain) IBOutlet UISwitch *casual;
@property (nonatomic, retain) IBOutlet UISwitch *sportivo;
@property (nonatomic, retain) IBOutlet UISwitch *elegante;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil setImage:(UIImage *)image;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil getVestito:(Vestito *)vestito;


-(IBAction) selectImage:(id) sender;
-(IBAction) saveCloth:(id) sender;
-(IBAction) deleteCloth:(id) sender;
-(IBAction) undoCloth:(id) sender;
-(IBAction) segmentSwitch:(id)sender;
-(void)initStagioniEntities:(NSNumber *)stagioneKey;




@end


