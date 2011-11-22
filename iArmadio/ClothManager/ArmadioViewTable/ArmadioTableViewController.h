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
#import "IarmadioDao.h"


@class CoverViewController;
@class SelectTypeViewController;

@interface ArmadioTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>{
    IarmadioDao *dao;
    SelectTypeViewController *delegateController;
    CoverViewController *coverviewcontroller;
    NSMutableDictionary *countVestiti;
    NSMutableDictionary *cacheImage;
}

- initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundle delegateController:(id)delegateController;
- (void)reloadCassetti:(NSNotification *)pNotification;  
@end
