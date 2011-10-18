//
//  iArmadioAppDelegate.h
//  iArmadio
//
//  Created by William Pompei on 03/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "IarmadioDao.h"
#import "GeoLocal.h"
#import "Shake2Style.h"
#import "Configuration.h"
#import "ExtendTabBarController.h"




@interface iArmadioAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>{

    GeoLocal *geolocal;
    IarmadioDao *dao;
    Shake2Style *shake2style;
    IBOutlet UIWindow *window;
    IBOutlet UITabBarController *tabBarController;
    UIImageView* tabBarArrow;
    
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain, readonly) IarmadioDao *dao;
@property (nonatomic, retain) UIImageView* tabBarArrow;


@end
