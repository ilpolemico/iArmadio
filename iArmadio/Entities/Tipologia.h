//
//  Tipologia.h
//  iArmadio
//
//  Created by Casa Fortunato on 20/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tipologia, Vestito;

@interface Tipologia : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * nome;
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
