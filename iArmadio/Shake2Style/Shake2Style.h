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

@protocol Shake2Delegate


@required
- (void)getVestitiShake:(NSArray *)vestiti;
- (NSArray *)setCategoryShake;
@end


@interface Shake2Style : UIViewController <UIActionSheetDelegate>{
    IarmadioDao *dao;
    BOOL enableShake;
    id <Shake2Delegate> delegate;
}
@property (assign, nonatomic) id delegate;
@property (nonatomic) BOOL enableShake;

+ (Shake2Style *)shared;
- (Combinazione *)shake2style:(NSArray *)filterStili filterStagione:(NSString *)filterStagione;
- (Vestito *)shake2styleVestiti:(NSArray *)tipi filterStagione:(NSString *)filterStagione;


@end



