//
//  SecondViewController.h
//  iArmadio
//
//  Created by William Pompei on 03/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iArmadioAppDelegate.h"
#import "IarmadioDao.h"
#import "ClothTableViewController.h"

@interface ClothViewController : UIViewController <UIScrollViewDelegate> {
    
    UIImageView * imageView;
    IarmadioDao *dao;
    UIImage *newimage;
    Vestito *vestito;
    IBOutlet UIScrollView *scrollview;
    IBOutlet UINavigationBar *addNavigationBar;
    IBOutlet UIBarButtonItem *saveButton;
    IBOutlet UIBarButtonItem *undoButton;
    IBOutlet UISegmentedControl *tipologia;
    NSArray *tipologie;
    BOOL addCloth;
      
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollview;
@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * saveButton;
@property (nonatomic, retain) IBOutlet UINavigationBar* addNavigationBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * undoButton;
@property (nonatomic, retain) IBOutlet UISegmentedControl *tipologia;
@property (nonatomic, retain) IBOutlet UISegmentedControl *stagione;
@property (nonatomic, retain) IBOutlet UISegmentedControl *gradimento;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil setImage:(UIImage *)image;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil getVestito:(Vestito *)vestito;



-(IBAction) addCloth:(id) sender;
-(IBAction) undoCloth:(id) sender;
-(IBAction) segmentSwitch:(id)sender;




@end


