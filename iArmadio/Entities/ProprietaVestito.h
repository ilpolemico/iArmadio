//
//  ProprietaVestito.h
//  iArmadio
//
//  Created by Casa Fortunato on 02/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Proprieta, Vestito;

@interface ProprietaVestito : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) Vestito *delVestito;
@property (nonatomic, retain) Proprieta *haNome;

@end
