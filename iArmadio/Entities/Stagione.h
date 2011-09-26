//
//  Stagione.h
//  iArmadio
//
//  Created by Casa Fortunato on 20/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Combinazione, Vestito;

@interface Stagione : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * temp_max;
@property (nonatomic, retain) NSNumber * temp_min;
@property (nonatomic, retain) NSString * stagione;
@property (nonatomic, retain) NSString * date_from;
@property (nonatomic, retain) NSString * date_to;
@property (nonatomic, retain) NSSet *combinazione;
@property (nonatomic, retain) NSSet *vestito;
@end

@interface Stagione (CoreDataGeneratedAccessors)

- (void)addCombinazioneObject:(Combinazione *)value;
- (void)removeCombinazioneObject:(Combinazione *)value;
- (void)addCombinazione:(NSSet *)values;
- (void)removeCombinazione:(NSSet *)values;

- (void)addVestitoObject:(Vestito *)value;
- (void)removeVestitoObject:(Vestito *)value;
- (void)addVestito:(NSSet *)values;
- (void)removeVestito:(NSSet *)values;

@end
