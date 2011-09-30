//
//  Shake2Style.h
//  iArmadio
//
//  Created by Casa Fortunato on 20/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IarmadioDao.h"

@interface Shake2Style : NSObject{
    IarmadioDao *dao;
}

@property (nonatomic, retain, readonly) IarmadioDao *dao;



- (Combinazione *)shake2style:(NSArray *)filterStili filterStagioni:(NSArray *)filterStagioni;

@end
