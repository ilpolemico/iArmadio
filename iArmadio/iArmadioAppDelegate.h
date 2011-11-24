//
//  iArmadioAppDelegate.h
//  iArmadio
//
//  Created by Luca Fortunato
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "IarmadioDao.h"
#import "GeoLocal.h"
#import "Shake2Style.h"
#import "Configuration.h"
#import "Tutorial.h"
#import "ExtendTabBarController.h"
#import "CoverViewController.h"
#import "LookViewController.h"
#import "ClothViewController.h"
#import "ClothManagerViewController.h"



@class Shake2Style;
@class GeoLocal;
@class CoverViewController;
@class ClothViewController;
@class LookViewController;

@interface iArmadioAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UIScrollViewDelegate>{

    GeoLocal *geolocal;
    IarmadioDao *dao;
    Shake2Style *shake2style;
    Tutorial *tutorial;
    CurrState *currstate;
    IBOutlet UIWindow *window;
    IBOutlet UITabBarController *tabBarController;
    UIImageView *tabBarArrow;
    UIScrollView *openView;
    UIScrollView *openViewLeft;
    int lastTranslation;
    UIImageView *blinkLabel;
    NSTimer *timerblink;
    CoverViewController *coverviewcontroller;
    LookViewController *lookviewcontroller;
    ClothViewController *addviewcontroller; 
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain, readonly) IarmadioDao *dao;
@property (nonatomic, retain) UIImageView* tabBarArrow;

- (void)blinkingLabel:(NSTimer *)timer;
-(void)openArmadio;



@end
