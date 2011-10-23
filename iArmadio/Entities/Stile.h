//
//  Stile.h
//  iArmadio
//
//  Created by Casa Fortunato on 23/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Combinazione, Vestito;

@interface Stile : NSManagedObject

@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * stile;
@property (nonatomic, retain) NSSet *combinazione;
@property (nonatomic, retain) NSSet *vestiti;
@end

@interface Stile (CoreDataGeneratedAccessors)

- (void)addCombinazioneObject:(Combinazione *)value;
- (void)removeCombinazioneObject:(Combinazione *)value;
- (void)addCombinazione:(NSSet *)values;
- (void)removeCombinazione:(NSSet *)values;
- (void)addVestitiObject:(Vestito *)value;
- (void)removeVestitiObject:(Vestito *)value;
- (void)addVestiti:(NSSet *)values;
- (void)removeVestiti:(NSSet *)values;
@end
