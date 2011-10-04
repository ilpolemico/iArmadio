//
//  LookTableViewController.h
//  iArmadio
//
//  Created by Casa Fortunato on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iArmadioAppDelegate.h"
#import "ClothViewController.h"
#import "CoverViewController.h"
#import "SelectTypeViewController.h"


@class ClothViewController;
@class SelectTypeViewController;

@interface ArmadioTableViewController : UITableViewController{
    IarmadioDao *dao;
    SelectTypeViewController *delegateController;
    NSMutableArray *tipologie;
}

- initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundle delegateController:(id)delegateController;
- (void)reloadCassetti; 
- (void)reloadCassetti:(NSNotification *)pNotification;  
@end
