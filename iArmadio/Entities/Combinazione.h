//
//  Combinazione.h
//  iArmadio
//
//  Created by Casa Fortunato on 20/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Stagione, Stile, Vestito;

@interface Combinazione : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * gradimento;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSSet *conStile;
@property (nonatomic, retain) NSSet *fattaDi;
@property (nonatomic, retain) NSSet *perLaStagione;
@end

@interface Combinazione (CoreDataGeneratedAccessors)

- (void)addConStileObject:(Stile *)value;
- (void)removeConStileObject:(Stile *)value;
- (void)addConStile:(NSSet *)values;
- (void)removeConStile:(NSSet *)values;

- (void)addFattaDiObject:(Vestito *)value;
- (void)removeFattaDiObject:(Vestito *)value;
- (void)addFattaDi:(NSSet *)values;
- (void)removeFattaDi:(NSSet *)values;

- (void)addPerLaStagioneObject:(Stagione *)value;
- (void)removePerLaStagioneObject:(Stagione *)value;
- (void)addPerLaStagione:(NSSet *)values;
- (void)removePerLaStagione:(NSSet *)values;

@end
