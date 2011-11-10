//
//  Shake2Style.h
//  iArmadio
//
//  Created by Casa Fortunato on 20/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IarmadioDao.h"
#import "iArmadioAppDelegate.h"
#import "ClothViewController.h"
#import "LookViewController.h"
#import <AudioToolbox/AudioServices.h>

@protocol ShakeDelegate
@required
- (void)getVestitiShake:(NSArray *)vestiti;
- (NSArray *)setCategoryShake;
@end

@interface Shake2Style : UIViewController <UIActionSheetDelegate>{
    IarmadioDao *dao;
    IBOutlet UIImageView *imageView;
    IBOutlet UILabel *stagione;
    IBOutlet UILabel *localita;
    BOOL enableShake;
    id <ShakeDelegate> delegate;
}
@property (assign, nonatomic) id delegate;
@property (nonatomic) BOOL enableShake;

+ (Shake2Style *)shared;
- (Combinazione *)shake2style:(NSArray *)filterStili filterStagione:(NSString *)filterStagione;

-(IBAction)done:(id)sender;

@end
