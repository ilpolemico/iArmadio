//
//  CurrState.h
//  iArmadio
//
//  Created by Casa Fortunato on 02/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IarmadioDao.h"

@interface CurrState : NSObject{
    NSString *currStagioneKey;
    NSNumber *currStagioneIndex;
    NSString *currStile;
    NSString *currEventi;
    NSString *currTipologia;
    NSNumber *currGradimento; 
    NSString *currSection;
    NSString *oldCurrSection;

}

@property (nonatomic,retain)  NSString *currStagioneKey;
@property (nonatomic,retain)  NSString *currSection;
@property (nonatomic,retain)  NSString *oldCurrSection;
@property (nonatomic,retain)  NSNumber *currStagioneIndex;
@property (nonatomic, retain) NSString *currStile;
@property (nonatomic, retain) NSString *currEventi;
@property (nonatomic, retain) NSString *currTipologia;
@property (nonatomic, retain) NSNumber *currGradimento; 


+ (CurrState *)shared;

@end
