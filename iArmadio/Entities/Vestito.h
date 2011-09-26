//
//  Vestito.h
//  iArmadio
//
//  Created by Casa Fortunato on 20/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Combinazione, ProprietaVestito, Stagione, Stile, Tipologia;

@interface Vestito : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * gradimento;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * immagine;
@property (nonatomic, retain) NSSet *conProprieta;
@property (nonatomic, retain) NSSet *conStile;
@property (nonatomic, retain) NSSet *inCombinazioni;
@property (nonatomic, retain) NSSet *perLaStagione;
@property (nonatomic, retain) NSSet *tipi;
@end

@interface Vestito (CoreDataGeneratedAccessors)

- (void)addConProprietaObject:(ProprietaVestito *)value;
- (void)removeConProprietaObject:(ProprietaVestito *)value;
- (void)addConProprieta:(NSSet *)values;
- (void)removeConProprieta:(NSSet *)values;

- (void)addConStileObject:(Stile *)value;
- (void)removeConStileObject:(Stile *)value;
- (void)addConStile:(NSSet *)values;
- (void)removeConStile:(NSSet *)values;

- (void)addInCombinazioniObject:(Combinazione *)value;
- (void)removeInCombinazioniObject:(Combinazione *)value;
- (void)addInCombinazioni:(NSSet *)values;
- (void)removeInCombinazioni:(NSSet *)values;

- (void)addPerLaStagioneObject:(Stagione *)value;
- (void)removePerLaStagioneObject:(Stagione *)value;
- (void)addPerLaStagione:(NSSet *)values;
- (void)removePerLaStagione:(NSSet *)values;

- (void)addTipiObject:(Tipologia *)value;
- (void)removeTipiObject:(Tipologia *)value;
- (void)addTipi:(NSSet *)values;
- (void)removeTipi:(NSSet *)values;

@end
