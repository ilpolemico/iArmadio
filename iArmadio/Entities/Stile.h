//
//  Stile.h
//  iArmadio
//
//  Created by Casa Fortunato on 06/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Combinazione, Vestito;

@interface Stile : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * stile;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) Combinazione *combinazione;
@property (nonatomic, retain) NSSet *vestiti;
@end

@interface Stile (CoreDataGeneratedAccessors)

- (void)addVestitiObject:(Vestito *)value;
- (void)removeVestitiObject:(Vestito *)value;
- (void)addVestiti:(NSSet *)values;
- (void)removeVestiti:(NSSet *)values;

@end
