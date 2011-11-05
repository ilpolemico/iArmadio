//
//  LookManagerController.h
//  iArmadio
//
//  Created by Casa Fortunato on 01/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IarmadioDao.h"
#import "LookTableViewController.h"

@interface LookManagerViewController : UIViewController{

    IarmadioDao *dao;
    IBOutlet UINavigationController *navcontroler;
}

@property (retain, readonly, nonatomic) IBOutlet UINavigationController *navcontroler;




@end
