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
#import "Vestito.h"
#import "Tipologia.h"


@class GeoLocal;
@class IarmadioDao;

@interface iArmadioAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>{

    GeoLocal *geolocal;
    IarmadioDao *dao;
    IBOutlet UIWindow *window;
    IBOutlet UITabBarController *tabBarController;
    
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain, readonly) IarmadioDao *dao;


-(NSString *) filePathDocuments: (NSString *) fileName;
-(NSString *) filePathBundle: (NSString *) fileName;



@end
