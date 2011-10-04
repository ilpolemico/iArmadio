//
//  Proprieta.h
//  iArmadio
//
//  Created by Casa Fortunato on 03/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProprietaVestito;

@interface Proprieta : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) ProprietaVestito *isNome;

@end
