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




@interface LookViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource,  UINavigationControllerDelegate> {
    
    IarmadioDao *dao;
    IBOutlet UIBarButtonItem *undoBtn;
    IBOutlet UIBarButtonItem *saveBtn;
    IBOutlet UIBarButtonItem *deleteBtn;
    IBOutlet UIButton *addPreferitiBtn;
    
    
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
    IBOutlet UIView *choice1;
    IBOutlet UIView *choice2;
    IBOutlet UIView *choice3;
    IBOutlet UIView *choice4;
    IBOutlet UIView *choice5;
    IBOutlet UIView *choice6;
    IBOutlet UIView *choice7;
    IBOutlet UIView *choice8;
    IBOutlet UIView *choice9;
    IBOutlet UIView *choice10;
}

@property (nonatomic, retain )IBOutlet UIButton *stile_1;
@property (nonatomic, retain )IBOutlet UIButton *stile_2;
@property (nonatomic, retain )IBOutlet UIButton *stile_3;
@property (nonatomic, retain )IBOutlet UIButton *stagione_1;
@property (nonatomic, retain )IBOutlet UIButton *stagione_2;
@property (nonatomic, retain )IBOutlet UIButton *stagione_3;
@property (nonatomic, retain )IBOutlet UIButton *gradimento_1;
@property (nonatomic, retain )IBOutlet UIButton *gradimento_2;
@property (nonatomic, retain )IBOutlet UIButton *gradimento_3;
@property (nonatomic, retain )IBOutlet UIBarButtonItem *undoBtn;
@property (nonatomic, retain )IBOutlet UIBarButtonItem *saveBtn;
@property (nonatomic, retain )IBOutlet UIBarButtonItem *deleteBtn;
@property (nonatomic, retain )IBOutlet UIButton *addPreferitiBtn;

@property (nonatomic, retain )IBOutlet UIView *choice1;
@property (nonatomic, retain )IBOutlet UIView *choice2;
@property (nonatomic, retain )IBOutlet UIView *choice3;
@property (nonatomic, retain )IBOutlet UIView *choice4;
@property (nonatomic, retain )IBOutlet UIView *choice5;
@property (nonatomic, retain )IBOutlet UIView *choice6;
@property (nonatomic, retain )IBOutlet UIView *choice7;
@property (nonatomic, retain )IBOutlet UIView *choice8;
@property (nonatomic, retain )IBOutlet UIView *choice9;
@property (nonatomic, retain )IBOutlet UIView *choice10;




- (void)initInputType;
- (IBAction) undoLook:(id)sender;
- (IBAction) saveLook:(id)sender;
- (IBAction) deleteLook:(id)sender;
- (IBAction) addPreferiti:(id)sender;  

@end


