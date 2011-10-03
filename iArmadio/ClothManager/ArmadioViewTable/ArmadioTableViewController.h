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


@class ClothViewController;

@interface ArmadioTableViewController : UITableViewController{
    IarmadioDao *dao;
    NSMutableArray *tipologie;
}


- (void)reloadCassetti; 
- (void)reloadCassetti:(NSNotification *)pNotification;  
@end
