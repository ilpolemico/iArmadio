//
//  Tipologia.h
//  iArmadio
//
//  Created by Casa Fortunato on 20/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tipologia, Vestito;

@interface Tipologia : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * plural;
@property (nonatomic, retain) NSNumber * choice;
@property (nonatomic, retain) NSSet *allow;
@property (nonatomic, retain) NSSet *vestiti;
@end

@interface Tipologia (CoreDataGeneratedAccessors)

- (void)addAllowObject:(Tipologia *)value;
- (void)removeAllowObject:(Tipologia *)value;
- (void)addAllow:(NSSet *)values;
- (void)removeAllow:(NSSet *)values;
- (void)addVestitiObject:(Vestito *)value;
- (void)removeVestitiObject:(Vestito *)value;
- (void)addVestiti:(NSSet *)values;
- (void)removeVestiti:(NSSet *)values;
@end
