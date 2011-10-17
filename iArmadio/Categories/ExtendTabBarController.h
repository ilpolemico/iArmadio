//
//  Extend.h
//  iArmadio
//
//  Created by Casa Fortunato on 15/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iArmadioAppDelegate.h"
 

@interface UITabBarController (ExtendTabBarController)

-(void)presentModalViewController:(UIViewController *) controller animated:(BOOL)animated;

-(void)viewWillAppear:(BOOL)animated;
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;

@end
