//
//  Tutorial.h
//  iArmadio
//
//  Created by Casa Fortunato on 05/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IarmadioDao.h"

static NSString * const TUTORIAL_PLIST = @"Tutorial";

#define ACTION_START @"action_startApp"
#define ACTION_ADDCLOTH @"action_addCloth"
#define ACTION_LOOKVIEW @"action_lookView"
#define ACTION_LOOKTABLE @"action_lookTable"
#define ACTION_COVERFLOW @"action_coverFlow"
#define ACTION_PREFERITI @"action_preferiti"


@interface Tutorial : NSObject{
    NSMutableDictionary *tutorial;
    IarmadioDao *dao;
    BOOL enable;
}

@property (assign, nonatomic) BOOL enable;

+(Tutorial *)shared;
- (void) actionInfo:(NSString *)action;
- (void)loadTutorialDictionary;
- (void) showInfo:(NSString *)info;

@end
