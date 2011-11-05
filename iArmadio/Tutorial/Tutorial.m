//
//  Tutorial.m
//  iArmadio
//
//  Created by Casa Fortunato on 05/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Tutorial.h"

static Tutorial *singleton;

@implementation Tutorial


+ (Tutorial *)shared{
    if(singleton == nil){
        singleton = [[Tutorial alloc] init];
    }
    return singleton;
}

-(void)actionInfo:(NSString *)action{

}
@end
