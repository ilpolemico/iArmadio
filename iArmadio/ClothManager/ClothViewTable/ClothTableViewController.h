//
//  LookTableViewController.h
//  iArmadio
//
//  Created by Casa Fortunato on 22/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IarmadioDao.h"
#import "ClothViewController.h"


@class ClothViewController;

@interface ClothTableViewController : UITableViewController{
    IarmadioDao *dao;
    NSMutableArray *vestitiForType;
    ClothViewController *getviewcontroller;
}

- (void)reloadVestiti;     
@end
