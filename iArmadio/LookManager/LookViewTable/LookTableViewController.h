//
//  LookTableViewController.h
//  iArmadio
//
//  Created by Casa Fortunato on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iArmadioAppDelegate.h"
#import "LookViewController.h"
#import "CoverViewController.h"
#import "SelectTypeViewController.h"


@class CoverViewController;
@class SelectTypeViewController;

@interface LookTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>{
    IarmadioDao *dao;
    SelectTypeViewController *delegateController;
    CoverViewController *coverviewcontroller;
    
    NSMutableDictionary *combinazioniForStile;
    
    
    IBOutlet UISegmentedControl *segmentControl;
    IBOutlet UIButton *addLookBtn;
}

@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (retain, nonatomic) IBOutlet UIButton *addLookBtn;



-(IBAction) addLook:(id)sender;
-(IBAction) changeSegmentControl:(id)sender;
- (void)reloadLook:(NSNotification *)pNotification;  
@end
