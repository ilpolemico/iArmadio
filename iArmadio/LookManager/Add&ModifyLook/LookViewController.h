//
//  SecondViewController.h
//  iArmadio
//
//  Created by William Pompei on 03/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IarmadioDao.h"
#import "ButtonSegmentControl.h"
#import "ClothViewController.h"




@interface LookViewController : UIViewController <UINavigationControllerDelegate, UIScrollViewDelegate, ButtonSegmentDelegate> {
    
    IarmadioDao *dao;
    IBOutlet UIBarButtonItem *undoBtn;
    IBOutlet UIBarButtonItem *saveBtn;
    IBOutlet UIBarButtonItem *deleteBtn;
    IBOutlet UIButton *addPreferitiBtn;
    IBOutlet UIScrollView *mainView;
    
    NSArray *vestiti;
    NSMutableDictionary *vestitiInScrollView;
    
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
    ButtonSegmentControl *choiceGradimento;
    NSArray *segmentGradimento;
    IBOutlet UIButton *gradimento_1;
    IBOutlet UIButton *gradimento_2;
    IBOutlet UIButton *gradimento_3;
    
    
    //Combinazione
    IBOutlet UIButton *choice1;
    IBOutlet UIButton *choice2;
    IBOutlet UIButton *choice3;
    IBOutlet UIButton *choice4;
    IBOutlet UIButton *choice5;
    IBOutlet UIButton *choice6;
    IBOutlet UIButton *choice7;
    IBOutlet UIButton *choice8;
    IBOutlet UIButton *choice9;
    IBOutlet UIButton *choice10;
    IBOutlet UIScrollView *listCloth;
    
    IBOutlet UIButton *upscroll;
    IBOutlet UIButton *downscroll;
    
    
    IBOutlet UIScrollView *captureView;
    IBOutlet UIToolbar *toolbar;
    
    
    NSString *preferito;
    Combinazione *combinazione;
    NSMutableDictionary *choiceToTipi;
    NSArray *vestitiForTipi;
    int currChoice;
    NSMutableArray *selectedVestiti;
    
    UIButton *currButton;
    IBOutlet UIImageView *lookSfondo;
    
    
    //Gradimento
    int gradimento;
    IBOutlet UIView *viewGradimento;

    
    int currIndex;
}

@property (nonatomic, retain )Combinazione *combinazione;
@property (nonatomic, retain )IBOutlet UIButton *stile_1;
@property (nonatomic, retain )IBOutlet UIButton *stile_2;
@property (nonatomic, retain )IBOutlet UIButton *stile_3;
@property (nonatomic, retain )IBOutlet UIButton *stagione_1;
@property (nonatomic, retain )IBOutlet UIButton *stagione_2;
@property (nonatomic, retain )IBOutlet UIButton *stagione_3;

@property (nonatomic, retain )IBOutlet UIView *viewGradimento;

@property (nonatomic, retain )IBOutlet UIBarButtonItem *undoBtn;
@property (nonatomic, retain )IBOutlet UIBarButtonItem *saveBtn;
@property (nonatomic, retain )IBOutlet UIBarButtonItem *deleteBtn;
@property (nonatomic, retain )IBOutlet UIButton *addPreferitiBtn;

@property (nonatomic, retain )IBOutlet UIButton *choice1;
@property (nonatomic, retain )IBOutlet UIButton *choice2;
@property (nonatomic, retain )IBOutlet UIButton *choice3;
@property (nonatomic, retain )IBOutlet UIButton *choice4;
@property (nonatomic, retain )IBOutlet UIButton *choice5;
@property (nonatomic, retain )IBOutlet UIButton *choice6;
@property (nonatomic, retain )IBOutlet UIButton *choice7;
@property (nonatomic, retain )IBOutlet UIButton *choice8;
@property (nonatomic, retain )IBOutlet UIButton *choice9;
@property (nonatomic, retain )IBOutlet UIButton *choice10;
@property (nonatomic, retain )IBOutlet UIButton *upscroll;
@property (nonatomic, retain )IBOutlet UIButton *downscroll;
@property (nonatomic, retain )IBOutlet UIScrollView *captureView;
@property (nonatomic, retain )IBOutlet UIScrollView *listCloth;
@property (nonatomic, retain )IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain )NSString *preferito;
@property (nonatomic, retain )IBOutlet UIScrollView *mainView;
@property (nonatomic, retain )IBOutlet IBOutlet UIImageView *lookSfondo;



- (void)initInputType;
- (IBAction) upscrollAction:(id)sender;
- (IBAction) downscrollAction:(id)sender;
- (IBAction) undoLook:(id)sender;
- (IBAction) saveLook:(id)sender;
- (IBAction) deleteLook:(id)sender;
- (IBAction) addPreferiti:(id)sender; 
- (IBAction)selectCloth:(id)sender;
- (IBAction)buttonPressed:(id)sender;
- (IBAction)selectGradimento:(id)sender;
@end


