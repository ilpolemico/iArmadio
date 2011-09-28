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


@class ClothViewController;

@interface ClothTableViewController : UITableViewController{
    IarmadioDao *dao;
    NSMutableArray *vestitiForType;
}

- (void)reloadVestiti;     
@end
