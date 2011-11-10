//
//  SecondViewController.h
//  iArmadio
//
//  Created by Luca Fortunato
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IarmadioDao.h"
#import "ButtonSegmentControl.h"
#import "UIImage+Effect.h"
#import "Shake2Style.h"


@interface LookViewController : UIViewController < UINavigationControllerDelegate, UIScrollViewDelegate, ButtonSegmentDelegate, UITextFieldDelegate> {
    
    IarmadioDao *dao;
    IBOutlet UIBarButtonItem *undoBtn;
    IBOutlet UIBarButtonItem *saveBtn;
    IBOutlet UIBarButtonItem *deleteBtn;
    IBOutlet UIButton *addPreferitiBtn;
    IBOutlet UIScrollView *mainView;
    
    
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
    IBOutlet UIView *zoomClothView;
    
    
    
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
    
    
    
    //SaveIcone
    NSMutableArray *iconeTipi;

    
    int currIndex;
    
    
    IBOutlet UITextField *note;
    IBOutlet UILabel *labelnote;
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
@property (nonatomic, retain )IBOutlet UIView *zoomClothView;
@property (nonatomic, retain )IBOutlet UIScrollView *captureView;
@property (nonatomic, retain )IBOutlet UIScrollView *listCloth;
@property (nonatomic, retain )IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain )NSString *preferito;
@property (nonatomic, retain )IBOutlet UIScrollView *mainView;
@property (nonatomic, retain )IBOutlet UIImageView *lookSfondo;
@property (nonatomic, retain )IBOutlet UITextField *note;
@property (nonatomic, retain )IBOutlet UILabel *labelnote;



- (void)initInputType;
- (void) fadeIn:(UIView *)view;
- (void) fadeOut:(UIView *)view;
- (IBAction) undoLook:(id)sender;
- (IBAction) saveLook:(id)sender;
- (IBAction) deleteLook:(id)sender;
- (IBAction) addPreferiti:(id)sender; 
- (IBAction)selectCloth:(id)sender;
- (IBAction)buttonPressed:(id)sender;
- (IBAction)selectGradimento:(id)sender;
- (IBAction)hiddenZoomClothView:(UIView *)sender;
-(IBAction) doneEditing: (id) sender;
- (IBAction) scrollViewAction:(id)sender;
- (void)changeVestito:(int) tag;
- (void)switchVestito:(UIButton *)button image:(UIImage *)image;

@end


