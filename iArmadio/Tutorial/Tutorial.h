//
//  Tutorial.h
//  iArmadio
//
//  Created by Casa Fortunato on 05/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tutorial : NSObject{
}

+(Tutorial *)shared;
-(void) actionInfo:(NSString *)action;

@end
