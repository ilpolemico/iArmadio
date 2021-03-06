//
//  SetupViewController.h
//  iArmadio
//
//  Created by Casa Fortunato on 06/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IarmadioDao.h"
#import "GeoLocal.h"
#import "CreditsViewController.h"

@interface SetupViewController : UIViewController{
    IarmadioDao *dao;
    IBOutlet UINavigationController *navcontroler;
    IBOutlet UILabel *labelGPS;
    IBOutlet UILabel *labelShake;
    IBOutlet UIView *viewImpostazioni;
    IBOutlet UISwitch *gps;
    IBOutlet UISwitch *shake;
}

@property (retain,nonatomic) IBOutlet UINavigationController *navcontroler;
@property (retain,nonatomic) IBOutlet UIView *viewImpostazioni;
@property (retain,nonatomic) IBOutlet UILabel *labelGPS;
@property (retain,nonatomic) IBOutlet UILabel *labelShake;
@property (retain,nonatomic) IBOutlet UISwitch *gps;
@property (retain,nonatomic) IBOutlet UISwitch *shake;

-(IBAction)credits:(id)sender;
-(IBAction)enableGPS:(id)sender;
-(IBAction)enableShake:(id)sender;
-(IBAction)reset:(id)sender;

@end
