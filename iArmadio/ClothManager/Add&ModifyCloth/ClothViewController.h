//
//  SecondViewController.h
//  iArmadio
//
//  Created by Luca Fortunato
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYXImagesHelper.h"
#import "NYXImagesUtilities.h"
#import "SelectTypeViewController.h"
#import "IarmadioDao.h"
#import "ClothTableViewController.h"
#import "ButtonSegmentControl.h"
#import "Tutorial.h"


@class SelectTypeViewController;

@interface ClothViewController : UIViewController <UIScrollViewDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, ButtonSegmentDelegate, UITextFieldDelegate> {
    
    SelectTypeViewController *selectController;
    UIImageView * imageViewSfondo;
    UIImageView * imageView;
    IarmadioDao *dao;
    UIImage *newimage;
    Vestito *vestito;
    IBOutlet UINavigationBar *addNavigationBar;
    IBOutlet UIBarButtonItem *saveButton;
    IBOutlet UIBarButtonItem *undoButton;
    IBOutlet UIButton *tipologiaBtn;
    NSString *tipologiaSelected;
    IBOutlet UILabel *tipologiaLabel;
    IBOutlet UILabel *stileLabel;
    IBOutlet UILabel *gradimentoLabel;
    IBOutlet UILabel *stagioneLabel;
    
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIBarButtonItem *trash;
    
    NSString *currTipologia;
    NSString *currStile;
    NSString *currGradimento;
    NSString *currStagione;
    NSString *preferito;
    
    
    BOOL addCloth;
    BOOL modifyImageCloth;
    float lastScaleFactor, netRotation, lastFactor;
    CGPoint netTranslation;
    float scaleFactor;
    float lastSliderValue;
    float offsetScaleFactor;
    
    CGAffineTransform rotate;
    CGAffineTransform pinch;
    CGAffineTransform pan;
    CGAffineTransform currTransform;
    CGAffineTransform currTransformScale;
    CGAffineTransform currTransformRotatePan;
    
    
    
    //Stili
    ButtonSegmentControl *choiceStile;
    NSArray *segmentStile;
    IBOutlet UIButton *stile_1;
    IBOutlet UIButton *stile_2;
    IBOutlet UIButton *stile_3;
    
    //Stagioni
    ButtonSegmentControl *choiceStagione;
    NSArray *segmentStagione;
    IBOutlet UIButton *stagione_1;
    IBOutlet UIButton *stagione_2;
    IBOutlet UIButton *stagione_3;
    
    //Gradimento
    int gradimento;
    IBOutlet UIView *viewGradimento;
    IBOutlet UIButton *addPreferiti;
    
    IBOutlet UIView *captureView;
    IBOutlet UISlider *sliderZoom;
    
    IBOutlet UITextField *note;
    
    BOOL isChangeImage;
      
}

@property (nonatomic, retain ) IBOutlet UISlider *sliderZoom;
@property (nonatomic, retain ) IBOutlet UIView *captureView;
@property (nonatomic, retain ) IBOutlet UIView *viewGradimento;
@property (nonatomic, retain ) NSString *preferito;
@property (nonatomic, retain ) IBOutlet UIButton *addPreferiti;

@property (nonatomic, retain ) IBOutlet UILabel *stileLabel;
@property (nonatomic, retain ) IBOutlet UILabel *gradimentoLabel;
@property (nonatomic, retain ) IBOutlet UILabel *stagioneLabel;

@property (nonatomic, retain )IBOutlet UIButton *stile_1;
@property (nonatomic, retain )IBOutlet UIButton *stile_2;
@property (nonatomic, retain )IBOutlet UIButton *stile_3;
@property (nonatomic, retain )IBOutlet UIButton *stagione_1;
@property (nonatomic, retain )IBOutlet UIButton *stagione_2;
@property (nonatomic, retain )IBOutlet UIButton *stagione_3;



@property (nonatomic, retain ) IBOutlet NSString *currStile;
@property (nonatomic, retain ) IBOutlet NSString *currTipologia;
@property (nonatomic, retain ) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain ) IBOutlet UIBarButtonItem *trash;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIImageView *imageSfondo;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewGradimento;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * saveButton;
@property (nonatomic, retain) IBOutlet UINavigationBar* addNavigationBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * undoButton;


@property (nonatomic, retain) IBOutlet UIButton *tipologiaBtn;
@property (nonatomic, retain) IBOutlet UILabel  *tipologiaLabel;
@property (nonatomic, retain) NSString *tipologiaSelected;
@property (nonatomic, retain ) IBOutlet UITextField *note;





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil setImage:(UIImage *)image;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil getVestito:(Vestito *)vestito;

-(IBAction) selectGradimento:(id)sender;
-(IBAction) addPreferiti:(id) sender;
-(IBAction) selectTipo:(id) sender;
-(IBAction) selectImage:(id) sender;
-(IBAction) saveCloth:(id) sender;
-(IBAction) deleteCloth:(id) sender;
-(IBAction) undoCloth:(id) sender;
-(IBAction) doneEditing: (id) sender;
-(void)initStagioniEntities:(NSNumber *)stagioneKey;
-(void) initInputType;
-(CGAffineTransform) scale:(CGAffineTransform)_transform factor:(float) factor;




@end


